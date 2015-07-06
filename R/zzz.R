#' PyR: Set of Functions to Allow Use of Python in R
#'
#' A bridge between R and Python. Thes package is inspired by rPython
#' package but adds some additional functionality like dealing with Python
#' exceptions and converting native Python data types to native R data types.
#' The pacakge was also inspired by http://gallery.rcpp.org/articles/rcpp-python/ .
#'
#' @docType package
#' @name PyR-package
NULL


.onLoad <- function( libname, pkgname ){
  .python.init()
  code <- readLines(system.file("python","pyr_init.py", package="PyR"))
  code <- paste(code, collapse = "\n")
  .python.exec(code, start = "file")

}

.onUnload <- function( libpath ){
  .python.close()
}
