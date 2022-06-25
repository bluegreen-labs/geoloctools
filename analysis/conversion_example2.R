library(geoloctools)
library(pamlr)
library(tidyverse)

# load demo data from Migrate Technologies files
PAM_data <- glt_migtech_pamlr("~/Desktop/multisensordatafromportugal_/all/")

# plot activity and light levels as shown in the
# PAMLr documentation

lapply(names(PAM_data), function(file){

  png(filename = sprintf("~/Desktop/%s.png", file))
  data <- PAM_data[[which(names(PAM_data) == file)]]

  print(data)

  par( mfrow= c(1,2), oma=c(0,2,0,6))
  par(mar =  c(4,2,4,2))

  pamlr::plot_sensorimage(data$acceleration$date, ploty=FALSE,
                          log(data$acceleration$act+0.001), main = "Activity",
                          col=c("black",viridis::cividis(90)), cex=1.2, cex.main = 2)

  pamlr::plot_sensorimage(data$light$date, labely=FALSE,
                          data$light$obs,  main="Light",
                          col=c("black",viridis::cividis(90)), cex=1.2, cex.main = 2)

  dev.off()
})

