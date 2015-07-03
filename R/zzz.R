.onLoad <- function( libname, pkgname ){
  .python.init("import json\nimport collections")
  .create_py_helper_functions()
}

.onUnload <- function( libpath ){
  .python.close()
}
