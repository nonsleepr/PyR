#' Get Python object.
#'
#' @param obj_name Name of the Python object.
#' @param env Optional environment, where corresponding R object will be created.
#' @return R object corresponding to Python object.
#' @examples
#' PyStr <- python.get_object("str")
#' s <- PyStr("hello, {name}")
#' s$format(name = "world")
#' @export
python.get_object <- function(obj_name, env = parent.frame()) {
  code <- sprintf("[k for k in dir(%s) if not k.startswith('_') and callable(getattr(%s, k))]", obj_name, obj_name)
  method_names <- python.eval(code)
  methods <- lapply(setNames(method_names, method_names), function(m) {
    eval(substitute(function(...) {
      python.call(sprintf("pyr.instances['%s'].%s", self, m), ...)
    }, list(m = m)))
  })
  methods$initialize <- eval(substitute(function(...) {
    self <<- sprintf("inst%d", 1)
    class <<- obj_name
    python.exec("try:\n    pyr.instances\nexcept AttributeError:\n    pyr.instances = {}")
    python.call(class, .saveTo = sprintf("pyr.instances['%s']", self), .getResults = FALSE, ...)
  }, list(obj_name = obj_name)))
  methods$finalize = function() {
    python.exec(sprintf("del pyr.instances['%s']", self))
  }
  cls <- setRefClass(paste0("PyR_", obj_name), fields = list(self = "character", class = "character", .objName = "ANY"),
              methods = methods,
              where = env)
  cls
}
