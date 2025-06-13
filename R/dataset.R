#' Load example datasets
#' 
#' @export
#' @return list of datasets
example_datasets = function(){
  readRDS(system.file("exdata/datasets.rds", package = "nicolaus"))
}

#' Flatten one or more dataset nodes
#' 
#' @export
#' @param dd a "datasets" list
#' @param service chr the preferred service
#' @param verbose logical, output messages if TRUE
#' @param ... arguments passed to flatten_variables
#' @return table of product information
flatten_dataset = function(dd = example_datasets(), 
                           service =  "arco-geo-series",
                           verbose = FALSE,
                           ...){
  dd = if (inherits(dd, "datasets")){
    dd 
  } else if (inherits(dd, "dataset")){
    dd = list(dd)
    class(dd) = c("datasets", class(dd))
    names(dd) = dd[[1]]$dataset_id
  } else {
    stop("input must be of class 'datasets' or 'dataset'")
  }
  # https://help.marine.copernicus.eu/en/articles/8286798-copernicus-marine-toolbox-api-explore-the-catalogue-and-metadata
  lapply(dd,
    function(d){
      services = d$versions[[1]]$parts[[1]]$services
      if (is.null(services)) return(services)
      names(services) <- sapply(services, "[[", "service_name")
      vv = services[[service[1]]]$variables
      vv = lapply(vv,
                 function(v){
                   class(v) <- c("variable", class(v))
                   v
                 })
      class(vv) <- c("variables", class(vv))
      if (verbose) cat("dataset_id:", d$dataset_id, "\n" )
      flatten_variable(vv)  |>
        dplyr::bind_rows()  |>
        dplyr::mutate(dataset_id = d$dataset_id, .before = 1)
    }) |>
    dplyr::bind_rows()
}

