# load libraries
library(geoloctools)
library(tidyverse)
library(rnaturalearth)
library(mapview)
library(sf)

plot_stuff <- function(file){
  data <- glt_read_pos(
    pos = file
  )

  data <- data %>%
    filter(
      !(latitude == 0 | longitude == 0)
    )

  p <- ggplot() +
    geom_sf(data = land) +
    geom_path(
      data = data,
      aes(
        longitude,
        latitude
      )
    ) +
    geom_point(
      data = data,
      aes(
        longitude,
        latitude,
        #colour = as.factor(hour)
        colour = paste(year, month)
      )
    ) +
    # coord_sf(
    #   xlim = c(min(data$longitude), max(data$longitude)),
    #   ylim = c(min(data$latitude), max(data$latitude)),
    # )
    coord_sf(
      xlim = c(-9, -8),
      ylim = c(41, 42),
    )

  print(p)

  # df <- data %>%
  #   st_as_sf(coords = c("longitude","latitude"), crs = 4326)
  #
  # m <- mapview(
  #   df,
  #   #popup = popupTable(data),
  #   map.types = "OpenTopoMap"
  #   )
  #
  # print(m)
  #
  # land <- ne_countries(scale = 50, returnclass = "sf")

}
