# A function to apply single non-fancy (or fancy) quotes
#
# @param x character string
# @param fancy logical, curly quotes? (TRUE) or plain quotes (FALSE)?
# @return single quoted value of x
squote = function(x, fancy = FALSE){
  on.exit({
    options("useFancyQuotes")
  })
  orig_fancy = options("useFancyQuotes")
  options(useFancyQuotes = fancy)
  sQuote(x)
}


#' Fetch the Copernicus catalog (all of it)
#' 
#' @export
#' @param filename chr, the output filename
#' @param verbose logical, if TRUE issue progress messages
#' @param app chr, the copernicusmarine application
#' @return 0 (success) or non-0 (failure)
fetch_catalog = function(filename = nicolaus_path("catalogs", 
                                                  "all_products_copernicus_marine_service.json"),
                         verbose = FALSE,
                         app = copernicus::get_copernicus_app()){
 
  args = if (verbose) {
      sprintf("describe --disable-progress-bar > %s", squote(filename))
    } else {
      sprintf("describe > %s", squote(filename))
    }
  system2(app, args)
}
