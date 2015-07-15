#' Call python function with parameters.
#'
#' @param func Function name string.
#' @param ... Optional function parameters, could be names as well.
#' @return Value returned by called function.
#' @examples
#' python.call("str", 100.5)
#' @export
python.call <- function(func, ..., .saveTo = "pyr._", .getResults = TRUE) {
  args <- list(...)
  args <- jsonlite::toJSON(args)
  code <- sprintf("%s = %s(*pyr.str_to_args('%s'), **pyr.str_to_kwargs('%s'))", .saveTo, func, args, args)
  .python.exec(code)
  if (.getResults) {
    .python.exec(sprintf("pyr._ = json.dumps(%s)", .saveTo))
    ret <- python.get("pyr._")
    if(length(ret) && ret != "") {
      jsonlite::fromJSON(ret)
    }
  }
}
