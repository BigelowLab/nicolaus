#' Save a tabular catalog
#' 
#' @export
#' @param x catalog table
#' @param filename chr the name of the output file
#' @return the input table
write_catalog = function(x,
                         filename = nicolaus_path("catalogs", "all_products_copernicus_marine_service.rds")){
  readr::write_rds(x, file = filename)
}

#' Read a tabular catalog
#' 
#' @export
#' @param filename chr the name of the inout file
#' @return the input table
read_catalog = function(filename = nicolaus_path("catalogs", "all_products_copernicus_marine_service.rds")){
  readr::read_rds(filename)
}