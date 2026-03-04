# =============================================================
# 1. Load Libraries
# =============================================================
library(terra)
library(sf)
library(ggplot2)
library(dplyr)
library(geodata)
library(ggrepel)
library(units)
library(grid)

# =============================================================
# 2. Load Population Raster
# =============================================================
pop <- rast("/Users/dash/Library/CloudStorage/GoogleDrive-bedadyuti.sees22@nalandauniv.edu.in/My Drive/R/bgd_pop_2025_CN_1km_R2025A_UA_v1.tif")

# =============================================================
# 3. Load Bangladesh Boundary (GADM Level 0)
# =============================================================
bgd_country <- geodata::gadm(country = "BGD", level = 0, path = tempdir())
bgd_country <- st_as_sf(bgd_country)

# Crop raster
bgd_vect <- vect(bgd_country)
pop_crop <- crop(pop, bgd_vect)

# =============================================================
# 4. Project Raster to EPSG:3106
# =============================================================
pop_projected <- project(pop_crop, "EPSG:3106", method = "bilinear")

# =============================================================
# 5. Density Calculation
# =============================================================
areakm2 <- cellSize(pop_projected, unit = "km")
density <- pop_projected / areakm2

# Moderate smoothing (clean but not washed)
pop_smooth <- focal(density, w = 5, fun = "mean", na.rm = TRUE)

# =============================================================
# 6. Mask & Trim
# =============================================================
bgd_country_3106 <- st_transform(bgd_country, 3106)
bgd_vect_3106    <- vect(bgd_country_3106)

pop_mask  <- mask(pop_smooth, bgd_vect_3106)
pop_final <- trim(pop_mask)

# =============================================================
# 7. Convert Raster to Data Frame
# =============================================================
pop_df <- as.data.frame(pop_final, xy = TRUE, na.rm = TRUE)
colnames(pop_df) <- c("x", "y", "density")

# =============================================================
# 8. Load Division Boundaries (GADM Level 1)
# =============================================================
bgd_div <- geodata::gadm(country = "BGD", level = 1, path = tempdir())
bgd_div <- st_as_sf(bgd_div)
bgd_div_3106 <- st_transform(bgd_div, 3106)

# =============================================================
# 9. Manual Division Capitals (Stable & Clean)
# =============================================================
cities_bgd <- data.frame(
  NAME = c("Rangpur","Rajshahi","Mymensingh","Sylhet",
           "Dhaka","Khulna","Barishal","Chattogram"),
  lon = c(89.2500,88.6000,90.4000,91.8800,
          90.4125,89.5403,90.3535,91.7832),
  lat = c(25.7500,24.3700,24.7500,24.8900,
          23.8103,22.8456,22.7010,22.3569)
)

cities_bgd <- st_as_sf(cities_bgd,
                       coords = c("lon","lat"),
                       crs = 4326)

cities_bgd <- st_transform(cities_bgd, 3106)

# =============================================================
# 10. Styling Breaks & Colors
# =============================================================
breaks <- c(0, 600, 1000, 1400, 2500, 5000, 12000, Inf)

labels <- c("< 600", "600 – 1k", "1k – 1.4k (Avg)",
            "1.4k – 2.5k", "2.5k – 5k", "5k – 12k", "> 12k+")

vintage_colors <- c(
  "#A8C5C6", "#B5C18E", "#DED09F",
  "#E6BA8E", "#D59D91", "#C1272D", "#4D0B0B"
)

# =============================================================
# 11. Build Final Map
# =============================================================
p <- ggplot() +
  
  # Density contours
  geom_contour_filled(
    data = pop_df,
    aes(x = x, y = y, z = density),
    breaks = breaks,
    alpha = 0.95
  ) +
  
  # Division boundaries (thin)
  geom_sf(
    data = bgd_div_3106,
    fill = NA,
    color = "#3A3A3A",
    linewidth = 0.25
  ) +
  
  # National border (stronger)
  geom_sf(
    data = bgd_country_3106,
    fill = NA,
    color = "#2C2621",
    linewidth = 0.8
  ) +
  
  # City points (ring effect)
  geom_sf(data = cities_bgd, color = "white", size = 3) +
  geom_sf(data = cities_bgd, color = "black", size = 1.2) +
  
  # Labels
  geom_text_repel(
    data = cities_bgd,
    aes(label = NAME, geometry = geometry),
    stat = "sf_coordinates",
    size = 4,
    fontface = "bold.italic",
    family = "serif",
    box.padding = 1,
    segment.color = "grey20",
    bg.color = "white",
    bg.r = 0.15
  ) +
  
  # Legend
  scale_fill_manual(
    values = vintage_colors,
    name = expression(People~per~km^2),
    labels = labels,
    guide = guide_legend(
      nrow = 1,
      title.position = "top",
      title.hjust = 0.5,
      label.position = "bottom",
      keywidth = unit(1.4, "cm")
    )
  ) +
  
  labs(
    title = "POPULATION DENSITY",
    subtitle = "Bangladesh (2025)",
    caption = "Map by Bedadyuti Dash | Data: WorldPop 1 km | Projection: EPSG:3106"
  ) +
  
  theme_void() +
  theme(
    plot.background  = element_rect(fill = "#F3EFE6", color = NA),
    panel.background = element_rect(fill = "#F3EFE6", color = NA),
    plot.margin = margin(40, 40, 40, 40),
    plot.title = element_text(size = 42, face = "bold",
                              hjust = 0.5, family = "serif",
                              color = "#2C2621"),
    plot.subtitle = element_text(size = 22,
                                 hjust = 0.5,
                                 color = "grey30",
                                 family = "serif",
                                 margin = margin(b = 20)),
    legend.position = "bottom",
    legend.text = element_text(size = 13,
                               family = "serif",
                               face = "bold"),
    legend.title = element_text(size = 16,
                                family = "serif"),
    plot.caption = element_text(size = 14,
                                color = "grey40",
                                hjust = 0.5,
                                margin = margin(t = 40))
  ) +
  
  coord_sf(crs = 3106,
           datum = NA,
           expand = FALSE,
           clip = "on")

# =============================================================
# 12. Export
# =============================================================
ggsave("BGD_Population_Density_Map.png",
       plot = p,
       width = 12,
       height = 15,
       dpi = 300,
       bg = "#F3EFE6")