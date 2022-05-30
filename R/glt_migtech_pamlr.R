#' Converts Migrate Tech data to PAMLr
#'
#' Data conversion to wrangle data into the
#' PAMLr data format for easy visualization
#' of geolocator data
#'
#' @param path location of lux (and optional .deg)
#' Migrate Technologies data files
#'
#' @return A nested list of variables, ID (taken from
#' the .lux files) is returned as a top level list
#' item, within it contained the data as formated
#' according to
#'
#' @export

glt_migtech_pamlr <- function(path){

  # list all light log files (others come later)
  light_logs <- list.files(path,
                           "*.lux",
                           full.names = TRUE)

  # gather properly formatted data lists
  data_list <- lapply(light_logs, function(log){

    lux <- read.table(
      log,
      header = TRUE,
      skip = 19,
      sep = "\t"
    ) %>%
      rename(
        'date' = 'DD.MM.YYYY.HH.MM.SS',
        'obs' =  contains("lux")
      ) %>%
      mutate(
        date = as.POSIXct(
          date,
          "%d/%m/%Y %H:%M:%S", tz = "UTC")
      )

    # format light data correctly
    lux <- list(light = lux)

    # append id
    lux <- append(lux, list('id' = id))

    # check for degree file
    deg_file <- paste0(tools::file_path_sans_ext(log),".deg")

    if (file.exists(deg_file)){
      deg <- readr::read_delim(
        deg_file,
        skip = 19,
        delim = "\t"
      ) %>%
        rename(
          'date' = contains("DD"),
          'temperature' = contains("T("),
          'pressure' = contains("Pa"),
          'acceleration_pit' = contains("Xavrg"),
          'acceleration_act' = contains("Zact")
        ) %>%
        mutate(
          date = as.POSIXct(
            date,
            "%d/%m/%Y %H:%M:%S", tz = "UTC")
        )

      variables <- c(
        "pressure",
        "acceleration",
        "temperature",
        "magnetic"
      )

      deg <- sapply(
        variables, function(var){
          if(any(grepl(var, names(deg)))){

            # convert pressure
            if(var == "pressure"){
              df <- data.frame(
                'date' = deg$date,
                'obs' = as.integer(unlist(deg[var])) / 100
              )
            }

            # convert temperature
            if(var == "temperature"){
              df <- data.frame(
                'date' = deg$date,
                'obs' = as.integer(unlist(deg[var]))
              )
            }

            # convert acceleration
            if(var == "acceleration"){
              df <- data.frame(
                'date' = deg$date,
                'pit' = as.integer(unlist(deg["acceleration_pit"])),
                'act' = as.integer(unlist(deg["acceleration_act"]))
              )
            }

            # return deg data
            return(df)
          }
        }, USE.NAMES = TRUE)

      # append the deg file data to the lux data
      lux <- append(lux, deg)
    }

    # remove empty values
    lux <- Filter(Negate(is.null), lux)

    # return pamlr data
    return(lux)
  })

  # assign ids to list items
  names(data_list) <- tools::file_path_sans_ext(basename(light_logs))
  return(data_list)
}
