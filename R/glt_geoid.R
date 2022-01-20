#' Get geoid correction
#'
#' Get a geoid correction value
#' for a latitude longitude pair
#'
#' @param longitude longitude, single value or vector
#' @param latitude latitude, single value or vector
#'
#' @return geoid height, for the correction of values measured relative
#'  to a reference ellipsoid (GPS)
#' @export
#'
#' @examples
#' \dontrun{
#' correction <- glt_geoid(4, 50)
#' }

glt_geoid <- function(
  longitude,
  latitude
) {

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
    data.frame(
      longitude = longitude,
      latitude  = latitude
    ),
    method = "bilinear"
  ))

  # scale the data
  height_geoid <- 0.003 * values - 108

  # return corrected values
  return(
    data.frame(height_geoid = height_geoid)
    )
}
