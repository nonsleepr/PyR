#' Call python function with parameters.
#'
#' @param func Function name string.
#' @param ... Optional function parameters, could be names as well.
#' @return Value returned by called function.
#' @examples
#' python.call("str", 100.5)
python.call <- function(func, ...) {
  args <- jsonlite::toJSON(list(...))
  code <- sprintf("json.dumps(%s(*pyr.str_to_args('%s'), **pyr.str_to_kwargs('%s')))", func, args, args)
  ret <- .python.exec(code)
  if(ret != "") {
    jsonlite::fromJSON(ret)
  }
}