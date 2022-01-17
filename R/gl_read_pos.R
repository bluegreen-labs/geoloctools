#' Read .pos file to data frame
#'
#' Converts .pos file to data frame for easy manipulation
#'
#' @param pos the location of a *.pos data-logger file
#'
#' @return
#' @export

gl_read_pos <- function(pos){

  # read original position data
  df <- read.table(pos, skip = 5, sep = ",", stringsAsFactors = FALSE)

  # drop columns without known meaning (to me anyway)
  df <- df[,-c(7,12,13)]

  # give the remaining columns proper headers
  colnames(df) = c("day",
                   "month",
                   "year",
                   "hour",
                   "min",
                   "sec",
                   "gps_signals",
                   "latitude",
                   "longitude",
                   "altitude",
                   "voltage")

  # add bird name
  df$tag <- tools::file_path_sans_ext(basename(pos))

  # convert year
  df$year <- df$year + 2000

  # add a date column
  df$date <- as.Date(sprintf("%s-%s-%s",df$year,df$month,df$day))

  # return as data frame
  return(df)
}
