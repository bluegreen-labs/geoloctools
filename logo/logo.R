library(hexSticker)
library(tidyverse)

imgurl <- "logo/pin.png"

sticker(imgurl,
        package = "GeoLocTools",
        p_size = 21,
        p_color = "black",
        h_color = "black",
        h_fill = "white",
        filename = "logo.png",
        s_y = 1.3,
        s_x = 1,
        p_y = 0.8
)
