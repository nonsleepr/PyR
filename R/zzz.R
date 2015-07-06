.onLoad <- function( libname, pkgname ){
  .python.init()
  code <- readLines(system.file("python","pyr_init.py", package="PyR"))
  code <- paste(code, collapse = "\n")
  .python.exec(code, start = "file")

}

.onUnload <- function( libpath ){
  .python.close()
}
