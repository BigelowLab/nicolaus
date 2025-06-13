#' Get the nicolaus data path from a user specified file
#'
#' @export
#' @param filename the name the file to store the path as a single line of text
#' @return character data path
root_path <- function(filename = "~/.copernicusdata"){
  readLines(filename)
}



#' Build a nicolaus path
#'
#' @export
#' @param ... further arguments for \code{file.path()}
#' @param root the root path
#' @return character path description
nicolaus_path <- function(...,
                            root = root_path()) {
  
  file.path(root, ...)
}