# Population Density in Bangladesh

This project utilizes satellite-derived population density data specific to Bangladesh, sourced from the **WorldPop Project**. The primary dataset employed is *bgd_pop_2025_CN_1km_R2025A_UA*, which operates at a 1km resolution.

## Data Sources
- **WorldPop Project**: This dataset provides up-to-date population estimates derived from satellite imagery and ground-based survey data.
- **GADM**: Used for defining geographical boundaries with precision.

## Methodology

### Data Collection
The data is collected from the WorldPop Project, which employs advanced methods for estimating population distributions. Raster data is derived from multiple sources, primarily focusing on urban expansion and demographic trends.

### Data Processing Steps
1. **Raster Processing**: The population data is originally in raster format which needs appropriate handling to ensure accuracy during further analysis.
2. **Density Calculation**: Using the processed raster data, density calculations are performed to ascertain population densities across different districts and regions.
3. **Smoothing**: Spatial smoothing techniques are applied to minimize fluctuations and ensure coherent population estimates.
4. **Visualization**: Finally, the processed data is visualized using GIS tools to provide insightful representations of population distributions across Bangladesh.

This approach emphasizes the use of WorldPop satellite-derived data, moving away from previous reliance on the Bangladesh Bureau of Statistics. The adoption of such data enhances the reliability and accuracy of population density estimates in the region.