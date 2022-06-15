#' Converts altitudes in hPa in m
#'
#' Uses the standard atmosphere as a reference.
#' Note that this method differs from the ERA5 reference
#'
#' @param hpa altitude expressed as hPa
#'
#' @return vector in meters
#' @export
#'
hPa_to_meter <- function(hpa){

  T0 <- 288.15 # standard temperature at sea level
  L <- 0.0065 # lapse rate
  P0 <- 1013.25 # standard atmosphere at sea level
  g <- 9.81 # gravity
  R0 <- 287.053 # gas constant

  # altitude in standard atmosphere
  z <- (T0/L) * (((P0/hpa)^((L*R0)/g)) - 1)

  return(z)
}
