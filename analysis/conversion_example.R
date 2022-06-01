# install libraries from github
# not hosted on CRAN
#if(!require(devtools)){install.packages("devtools")}
#devtools::install_github("bluegreen-labs/geoloctools")
#devtools::install_github("KiranLDA/pamlr")
#devtools::install_github("SLisovski/GeoLight")

# load libraries
library(pamlr)
library(geoloctools)
library(tidyverse)

# load demo data from Migrate Technologies files
PAM_data <- glt_migtech_pamlr(
  path = "~/Desktop/logger_data/"
)

# grab one particular logger (subset main list)
PAM_data <- PAM_data$CC906

# plot activity and light levels as shown in the
# PAMLr documentation
par( mfrow= c(1,2), oma=c(0,2,0,6))
par(mar =  c(4,2,4,2))

plot_sensorimage(PAM_data$acceleration$date, ploty=FALSE,
                 log(PAM_data$acceleration$act+0.001), main = "Activity",
                 col=c("black",viridis::cividis(90)), cex=1.2, cex.main = 2)

plot_sensorimage(PAM_data$light$date, labely=FALSE,
                 PAM_data$light$obs,  main="Light",
                 col=c("black",viridis::cividis(90)), cex=1.2, cex.main = 2)
