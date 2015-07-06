#' Get value of Python variable.
#'
#' @param var_name Variable name string.
#' @return Value of the variable.
#' @examples
#' python.get('a')
#' @export
python.get <- function(var_name) {
  spl <- strsplit(var_name, "\\.")[[1]]
  if (length(spl) == 2) {
    module <- spl[1]
    var_name <- spl[2]
  } else {
    module <- "__main__"
  }
  .python.get(module, var_name)
}
