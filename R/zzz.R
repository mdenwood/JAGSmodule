pkg_compile_flags <- rjags::pkg.compile.flags("BINCOMPAT")

.onLoad <- function(libname, pkgname){
  
  # Skip if running roxygen:
  if(!"roxygen2" %in% loadedNamespaces()){
    suppressMessages(rjags::load.pkg.module(pkgname, pkg_compile_flags))
  }

}
