#' Assign value to Python variable.
#'
#' @param var_name Variable name string.
#' @param val Value to be assigned.
#' @examples
#' python.assign("a", 10)
#' @export
python.assign <- function(var_name, val) {
  val <- jsonlite::toJSON(val)
  code <- sprintf("%s = json.loads('%s')", var_name, val)
  invisible(.python.exec(code))
}
