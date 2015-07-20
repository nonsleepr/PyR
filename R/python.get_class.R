#' Get Python class.
#'
#' @param cls_name Name of the Python class.
#' @param env Optional environment, where corresponding R class will be created.
#' @return R class corresponding to Python class.
#' @examples
#' PyStr <- python.get_class("str")
#' s <- PyStr("hello, {name}")
#' s$format(name = "world")
#' @export
python.get_class <- function(cls_name, env = parent.frame()) {
  r_cls_name <- paste0("PyR_", cls_name)
  .inst_index <- NULL # To make "R CMD check" happy
  tryCatch({
    getRefClass(r_cls_name, where = env)
  }, error = function (e) {
    code <- sprintf("[k for k in dir(%s) if not k.startswith('_') and callable(getattr(%s, k))]", cls_name, cls_name)
    method_names <- python.eval(code)
    methods <- lapply(setNames(method_names, method_names), function(m) {
      eval(bquote(function(...) {
        PyR::python.call(sprintf(.(paste0("pyr.instances[%d].",m)), .inst_index), ...)
      }))
    })
    methods$initialize <- eval(bquote(function(...) {
      PyR::python.exec("pyr.instances.append(None)")
      .inst_index <<- PyR::python.eval("len(pyr.instances) - 1")
      PyR::python.call(.(cls_name), .saveTo = sprintf("pyr.instances[%d]", .inst_index), .getResults = FALSE, ...)
    }))
    methods$finalize <- function() {
      PyR::python.exec(sprintf("pyr.instances[%d] = None", .inst_index))
    }
    setRefClass(r_cls_name, fields = list(.inst_index = "integer"),
                methods = methods,
                where = env)
  })
}
