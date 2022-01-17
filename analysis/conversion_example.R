library(pamlr)
library(tidyverse)
source("migtech2pamlr.R")

# load demo data from Migrate Technologies files
PAM_data <- migtech2pamlr("data/")

# grab one particular logger (subset main list)
PAM_data <- PAM_data$CC893

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
