#' Import the json product catalog
#' 
#' @export
#' @param filename chr, the name of the catalog name
#' @param flatten logical, if TRUE then transform the out to a flat table
#' @return a named list of json elements or a table
import_catalog = function(filename = nicolaus_path("catalogs", 
                                                   "all_products_copernicus_marine_service.json"),
                          flatten = TRUE){
  x = jsonlite::read_json(filename)[['products']]
  names(x) <- sapply(x,
                     function(p){
                       p$product_id
                     })
  
  x <- lapply(x, function(y) {
    class(y) <- c("product", class(y))
    y
  })
  
  class(x) <- c("products", class(x))
  
  if (flatten) x = flatten_product(x)
  
  return(x)
}