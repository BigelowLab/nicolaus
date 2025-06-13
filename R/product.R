#' Load example products
#' 
#' @export
#' @return list of products
example_products = function(){
  readRDS(system.file("exdata/products.rds", package = "nicolaus"))
}


#' Flatten one or more product nodes node
#' 
#' @export
#' @param pp a "products" list of one or more "product" objects
#' @param verbose logical, output messages if TRUE
#' @param ... arguments passed to flatten_dataset
#' @return table of product information
flatten_product = function(pp = example_products(), verbose = FALSE, ...){
  
  pp = if (inherits(pp, "products")){
    pp 
  } else if (inherits(pp, "product")){
    pp = list(pp)
    class(pp) <- c("products", class(pp))
    names(pp) = pp[[1]]$product_id
  } else {
    stop("input must be of class 'products' or 'product'")
  }
  
  lapply(pp,
         function(p){
           p$datasets = lapply(p$datasets,
                               function(d) {
                                 class(d) = c("dataset", class(d))
                                 return(d)
                               })
           names(p$datasets) = sapply(p$datasets, '[[', "dataset_id")
           class(p$datasets) <- c("datasets", class(p$datasets))
           if (verbose) cat("product_id:", p$product_id, "\n")
           flatten_dataset(p$datasets, verbose = verbose, ...) |>
             dplyr::mutate(product_id = p$product_id, .before = 1)
         }) |>
    dplyr::bind_rows()
}
