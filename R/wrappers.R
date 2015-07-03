.create_py_helper_functions <- function() {
  code <- "
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

python.call <- function(func, ...) {
  args <- jsonlite::toJSON(list(...))
  code <- sprintf("json.dumps(%s(*pyr.str_to_args('%s'), **pyr.str_to_kwargs('%s')))", func, args, args)
  ret <- .python.exec(code)
  if(ret != "") {
    jsonlite::fromJSON(ret)
  }
}

python.assign <- function(var_name, val) {
  val <- jsonlite::toJSON(val)
  code <- sprintf("%s = json.loads('%s')", var_name, val)
  invisible(.python.exec(code))
}

python.eval <- function(code) {
  .python.exec(code, "eval")
}

python.exec <- function(code) {
  invisible(.python.exec(code))
}
