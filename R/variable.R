#' Generate a template for variables
#' 
#' @export
#' @param dataset_id chr, the dataset_id (by default NA)
#' @param n num, the number of rows to return
#' @return n-row table
variable_template = function(n = 1,
                             dataset_id = NA_character_){
  
  now = Sys.time() + NA
  dplyr::tibble(
    dataset_id = rep(dataset_id, n),
    short_name = NA_character_,
    standard_name = NA_character_,
    units = NA_character_,
    start_time = now,
    end_time = now,
    time_step = NA_real_,
    min_depth = NA_real_,
    max_depth = NA_real_,
    n_depth = NA_real_
  ) 
}

#' Load example variables
#' 
#' @export
#' @return list of variables
example_variables = function(){
  readRDS(system.file("exdata/variables.rds", package = "nicolaus"))
}


#' Given a variable node, get a standard_name, short_name or units
#' @export
#' @param x a variable node 
#' @param name chr, the desired element name
#' @return character, possibly NA
get_parts_value = function(x, name = "standard_name"){
  standard_name = sapply(x, function(x) {
    if (name %in% names(x)) {
      paste(x[[name]], collapse = " ")
    } else {
      NA_character_
    }
  })
}

#' Retrieve the time origin
#' 
#' @export
#' @return POSIXct origin time stamp
time_origin = function(){
  as.POSIXct("1970-01-01 00:00:00", 
             format = "%Y-%m-%d %H:%M:%S",
             tz = "UTC")
}

#' Parse a time value
#' 
#' So far we have encountered ms since 1970-01-01 and ISO8601
#' date-time stamps
#' 
#' @export
#' @param x the object to parse with one or more elements
#' @param unit chr, provided in the time coordinate list element
#' @param origin POSIXct, only used if time is in ms
#' @return POSIXct time value(s)
parse_time = function(x, 
                      unit = c("ISO8601"),
                      origin = time_origin()){
  switch(unit,
         "ISO8601" = as.POSIXct(x, format = "%Y-%m-%dT%H:%m:%sZ", tz = "UTC"),
          origin + (x/1000))
}


#' Flatten variable(s)
#' 
#' @export
#' @param vv list of one or more variables
#' @return table of flattened variable(s)
flatten_variable = function(vv = example_variables()){
  origin = time_origin()
  templ = variable_template()
  vv = if (inherits(vv, "variables")){
    vv 
  } else if (inherits(vv, "variable")){
    vv = list(vv)
    class(vv) = c("variables", class(vv))
    names(vv) = vv[[1]]$dataset_id
  } else {
    stop("input must be of class 'variables' or 'variable'")
  }
  
  lapply(vv,
    function(v, template = variable_template()){
      vnms = names(v)
      if ("short_name" %in% vnms) template$short_name = v$short_name
      if ("standard_name" %in% vnms) template$standard_name = v$standard_name
      if ("units" %in% vnms) template$units = v$units
      if ("coordinates" %in% vnms){
        names(v$coordinates) <- cnms <- sapply(v$coordinates, `[[`, "coordinate_id")
        if ("depth" %in% cnms){
          if ("values" %in% names(v$coordinates[['depth']])){
            r = range(v$coordinates[['depth']]$values)
            template$min_depth = r[1] 
            template$max_depth = r[2]
            template$n_depth = length(v$coordinates[['depth']]$values)
          }
        } #depth
        if ("time" %in% cnms){
          # time can have a list of values, or it can have a 
          # specified min/max, and it can have a step
          if ("minimum_value" %in% names(v$coordinates[['time']])){
            template$start_time = parse_time(v$coordinates[['time']]$minimum_value,
                                            unit = v$coordinates[['time']]$coordinate_unit,
                                            origin = origin)
          }
          if ("maximum_value" %in%  names(v$coordinates[['time']])){
            template$end_time = parse_time(v$coordinates[['time']]$maximum_value,
                                           unit = v$coordinates[['time']]$coordinate_unit,
                                           origin = origin)
          }
          if ("values"  %in%  names(v$coordinates[['time']])){
            r = parse_time(range(v$coordinates[['time']]$values),
                           unit = v$coordinates[['time']]$coordinate_unit,
                           origin = origin)
            template$start_time = r[1]  #origin + (r[1]/1000)
            template$end_time = r[2]    #origin + (r[2]/1000)
          }
          if ("step" %in% names(v$coordinates[['time']])) {
            template$time_step = v$coordinates[['time']]$step/1000
          }
        } # time
      }
        template
    }, template = templ) |>
    dplyr::bind_rows()
}
