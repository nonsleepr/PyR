#' Execute Python code.
#'
#' @param code Python code string.
#' @examples
#' python.exec("a = 1 + 2")
#' @export
python.exec <- function(code) {
  invisible(.python.exec(code))
}
