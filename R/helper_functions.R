#' Converts altitudes in hPa in m
#'
#' uses ERA 1000mbar reference
#'
#' @param hpa altitude expressed as hPa
#'
#' @return vector in meters
#' @export
hPa_to_meter <- function(hpa){
  145366.45 * (
    1 - (hpa/1000)^0.190284
  ) / 3.2808
}
