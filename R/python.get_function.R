#' Get Python function.
#'
#' @param fn_name Function name string.
#' @return Wrapper around Python function.
#' @examples
#' python.exec("def test_fn(a = 3, b = 4):\n    return a * b")
#' test_fn <- python.get_function('test_fn')
#' test_fn(10, 20)
#' test_fn(a = 10)
#' test_fn(b = 10)
#' @export
python.get_function <- function(fn_name) {
  obj <- python.get(fn_name)
  if (is.null(obj) || !grepl("<function ", obj)) {
    return(NULL)
  } else {
    ret_fn <- function(...) {
      python.call(fn_name, ...)
    }
    return(ret_fn)
  }
}
