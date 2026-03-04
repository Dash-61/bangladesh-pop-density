# Statistical Visualizations

This R script provides functions to generate various statistical charts and visualizations.

## Dependencies
Please make sure to install the following R packages:
```R
install.packages(c('ggplot2', 'dplyr', 'tidyr'))
```

## Example Functions

### Bar Chart
```R
create_bar_chart <- function(data, x_col, y_col) {
  library(ggplot2)
  ggplot(data, aes_string(x = x_col, y = y_col)) + 
    geom_bar(stat = 'identity') + 
    theme_minimal() + 
    labs(title = 'Bar Chart', x = x_col, y = y_col)
}
```

### Scatter Plot
```R
create_scatter_plot <- function(data, x_col, y_col) {
  library(ggplot2)
  ggplot(data, aes_string(x = x_col, y = y_col)) + 
    geom_point() + 
    theme_minimal() + 
    labs(title = 'Scatter Plot', x = x_col, y = y_col)
}
}
```

### Boxplot
```R
create_boxplot <- function(data, x_col, y_col) {
  library(ggplot2)
  ggplot(data, aes_string(x = x_col, y = y_col)) + 
    geom_boxplot() + 
    theme_minimal() + 
    labs(title = 'Boxplot', x = x_col, y = y_col)
}
}
```

## Summary
This script provides essential functions for generating visualizations to analyze data effectively.