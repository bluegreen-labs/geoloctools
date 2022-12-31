#' Flatten PAMLr data
#'
#' Convert nested PAMLr (list) data to a tidy data frame. Only
#' processes meta-data or light level data separate as they
#' generally have different sampling frequencies (use the
#' lux parameter to switch between both).
#'
#' @param pamlr_data pam data as a nested list
#' @param lux process lux files to report light levels for geolight
#'  processing
#'
#' @return returns a tidy tibble with activity, pressure, pitch and
#'  temperature data
#' @export

glt_flatten_PAML <- function(
    pamlr_data,
    lux = FALSE
){
  df <- lapply(names(pamlr_data), function(x){

    # split out tags by name
    tag <- pamlr_data[[x]]

    if (lux){
      light <- tag[["light"]]

      if ("folder" %in% names(light)){
        data.frame(
          tag = x,
          folder = light$folder,
          date = light$date,
          light = light$obs
        )
      } else {
        data.frame(
          tag = x,
          date = light$date,
          light = light$obs
        )
      }

    } else {

      variables <- names(tag)

      # grab pressure and acceleration data (only)
      if('pressure' %in% variables ) {
        pressure <- tag[['pressure']]

        pressure <- data.frame(
          date = pressure$date,
          folder = pressure$folder,
          pressure = pressure$obs
        )

      } else {
        pressure <- data.frame(
          date = NA
        )
      }

      if('acceleration' %in% variables ) {
        acceleration <- tag[['acceleration']]

        acceleration <- data.frame(
          date = acceleration$date,
          folder = acceleration$folder,
          pitch = acceleration$pit,
          activity = acceleration$act
        )

      } else {
        acceleration <- data.frame(date = NA)
      }

      if('temperature' %in% variables ) {
        temperature <- tag[['temperature']]

        temperature <- data.frame(
          date = temperature$date,
          folder = temperature$folder,
          temperature = temperature$obs
        )

      } else {
        temperature <- data.frame(date = NA)
      }

      # combine data
      tmp <- dplyr::full_join(pressure, acceleration)
      tmp <- dplyr::full_join(tmp, temperature)
      tmp$tag <- x
      return(tmp)
      }
  })

  df <- dplyr::bind_rows(df)
  return(df)
}
