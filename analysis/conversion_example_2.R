# install libraries from github
# not hosted on CRAN
#if(!require(devtools)){install.packages("devtools")}
#devtools::install_github("bluegreen-labs/geoloctools")
#devtools::install_github("KiranLDA/pamlr")
#devtools::install_github("SLisovski/GeoLight")

# # load libraries
# library(pamlr)
# library(geoloctools)
# library(tidyverse)
#
# # load demo data from Migrate Technologies files
# PAM_data <- glt_migtech_pamlr(
#   path = "~/Desktop/logger_data/"
# )
#
# # grab one particular logger (subset main list)
# PAM_data <- PAM_data$CC906

source(
  "R/helper_functions.R"
)


do.call("bind_rows", PAM_data)


pressure <- PAM_data$pressure %>%
  mutate(
    time = format(date,"%H"),
    month = format(date,"%Y - %m"),
    altitude = hPa_to_meter(obs)
  ) %>%
  group_by(month, time) %>%
  summarize(
    altitude = mean(altitude)
  )

p <- ggplot(pressure) +
  geom_line(
    aes(
      time,
      altitude,
      group = month,
      colour = month
    )
  ) +
  scale_colour_discrete(
    RColorBrewer::brewer.pal(12, "Set3")
  ) +
  theme_classic()

print(p)
