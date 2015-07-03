.onLoad <- function( libname, pkgname ){
  py_init("import json\nimport collections")
  create_py_helper_functions()
}

.onUnload <- function( libpath ){
  py_close()
}
