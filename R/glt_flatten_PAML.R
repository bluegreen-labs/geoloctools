#' Flatten PAMLr data
#'
#' Convert nested PAMLr (list) data to a tidy data frame.
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

      print(str(light))

      data.frame(
        tag = x,
        date = light$date,
        light = light$obs
      )
    } else {

      # grab pressure and acceleration data (only)
      pressure <- tag[['pressure']]
      acceleration <- tag[['acceleration']]
      temperature <- tag[['temperature']]

      data.frame(
        tag = x,
        date = pressure$date,
        pressure = pressure$obs,
        pitch = acceleration$pit,
        activity = acceleration$act,
        temperature = temperature$obs
      )
    }
  })

  df <- dplyr::bind_rows(df)
  return(df)
}
