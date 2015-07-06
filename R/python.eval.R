#' Evaluate Python expression.
#'
#' @param code Python code string, evaluated in it's own namespace.
#' @return Result of evaluation.
#' @examples
#' python.eval("1+1")
#' @export
python.eval <- function(code) {
  .python.exec(code, "eval")
}
