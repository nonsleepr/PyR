#' PyR: Set of Functions to Allow Use of Python in R
#'
#' A bridge between R and Python. Thes package is inspired by rPython
#' package but adds some additional functionality like dealing with Python
#' exceptions and converting native Python data types to native R data types.
#' The pacakge was also inspired by http://gallery.rcpp.org/articles/rcpp-python/ .
#'
#' @docType package
#' @name PyR-package
NULL


.onLoad <- function( libname, pkgname ){
  .python.init()
  code <- "
import json
import collections
import pyr
def _pyr_str_to_args(json_string):
    obj = json.JSONDecoder(object_pairs_hook=collections.OrderedDict).decode(json_string)
    if isinstance(obj, dict):
        args = [v for i, (k, v) in enumerate(obj.items()) if k == str(i+1)]
    elif isinstance(obj, list):
        args = obj
    else:
        args = []
    args = [v if len(v) > 1 else (None if len(v) == 0 else v[0]) for v in args]
    return args

def _pyr_str_to_kwargs(json_string):
    obj = json.JSONDecoder(object_pairs_hook=collections.OrderedDict).decode(json_string)
    if isinstance(obj, dict):
        kwargs = [(k, v) for i, (k, v) in enumerate(obj.items()) if k != str(i+1)]
    else:
        kwargs = []
    kwargs = dict([(k, v if len(v) > 1 else (None if len(v) == 0 else v[0])) for k, v in kwargs])
    return kwargs

pyr.str_to_args = _pyr_str_to_args
pyr.str_to_kwargs = _pyr_str_to_kwargs
"
  .python.exec(code, start = "file")

}

.onUnload <- function( libpath ){
  .python.close()
}
