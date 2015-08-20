#' Call python function with parameters.
#'
#' @param func Function name string.
#' @param .saveTo Name of the Python variable to save results of the call.
#' @param .getResults Wether to return results of the execution.
#' @param ... Optional function parameters, could be names as well.
#' @return Value returned by called function.
#' @examples
#' python.call("str", 100.5)
#' @export
python.call <- function(func, ..., .saveTo = "pyr._", .getResults = TRUE) {
  args <- list(...)
  args <- jsonlite::toJSON(args, null="null", na="null")
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
