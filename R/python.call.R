#' Call python function with parameters.
#'
#' @param func Function name string.
#' @param ... Optional function parameters, could be names as well.
#' @return Value returned by called function.
#' @examples
#' python.call("str", 100.5)
#' @export
python.call <- function(func, ...) {
  args <- jsonlite::toJSON(list(...))
  code <- sprintf("pyr._ = json.dumps(%s(*pyr.str_to_args('%s'), **pyr.str_to_kwargs('%s')))", func, args, args)
  .python.exec(code)
  ret <- python.get("pyr._")
  if(length(ret) && ret != "") {
    jsonlite::fromJSON(ret)
  }
}
