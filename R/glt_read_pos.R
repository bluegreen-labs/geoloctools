#' Read .pos file to data frame
#'
#' Converts .pos file to data frame for easy manipulation
#'
#' @param pos the location of a *.pos data-logger file
#' @param geoid correct altitudes for geiod shape (default = TRUE)
#'
#' @return data frame with position data
#' @export

glt_read_pos <- function(
  pos,
  geoid = TRUE
  ){

  # read original position data
  df <- utils::read.table(pos, skip = 5, sep = ",", stringsAsFactors = FALSE)

  # drop columns without known meaning (to me anyway)
  df <- df[,-c(7,12,13)]

  # give the remaining columns proper headers
  colnames(df) = c(
    "day",
    "month",
    "year",
    "hour",
    "min",
    "sec",
    "gps_signals",
    "latitude",
    "longitude",
    "height_ellips",
    "voltage"
    )

  # add bird name
  df$tag <- tools::file_path_sans_ext(basename(pos))

  # convert year
  df$year <- df$year + 2000

  # add a date column
  df$date <- as.Date(sprintf("%s-%s-%s",df$year,df$month,df$day))

  if(geoid){

    tif <- file.path(system.file(
      "extdata",
      package = "geoloctools",
      mustWork = TRUE),
      "egm2008-1.tif"
    )

    # grab geoid corrections
    r <- raster::brick(tif)

    # extract correction values for all locations
    values <- as.vector(raster::extract(
      r,
      df[,c("longitude","latitude")],
      method = "bilinear"
      ))

    # scale the data
    df$height_geoid <- 0.003 * values - 108

    # topographic height
    df$altitude <- df$height_ellips - df$height_geoid
  }

  # return as data frame
  return(df)
}
