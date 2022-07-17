lux_to_TAGS <- function(
    file,
    path
){

  # read lux file
  df <- GeoLight::luxTrans(file)

  # add empty columns
  df$twilight <- 0
  df$interp <- FALSE
  df$excluded <- FALSE

  # convert datetime
  df$datetime <- format(df$datetime, "%Y-%m-%dT%H:%M:%S.000Z")

  # read lux file
  df <- GeoLight::luxTrans(file)
  twl <- twilightCalc(
    df$datetime,
    df$light,
    LightThreshold = 1.5,
    ask = FALSE
  )

  df <- FLightR::GeoLight2TAGS(df, gl_twl = twl)

  if(!missing(path)){
    write.table(
      df,
      file.path(
        path,
        sprintf("TAGS.%s.csv",tools::file_path_sans_ext(basename(file)))
      ),
      col.names = TRUE,
      row.names = FALSE,
      quote = FALSE,
      sep = ","
    )
  } else {
    return(df)
  }
}
