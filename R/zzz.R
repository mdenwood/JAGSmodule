pkg_compile_flags <- rjags::pkg.compile.flags("ALL")

.onLoad <- function(libname, pkgname){

  # Skip if running roxygen, as we don't have a dll/so available:
  if(!"roxygen2" %in% loadedNamespaces()){
    suppressMessages(rjags::load.pkg.module(pkgname, libname, pkg_compile_flags))
  }

}

.onAttach <- function(libname, pkgname){

  mods <- rjags::list.modules()
  if(pkgname %in% mods){
    packageStartupMessage("Package module ", pkgname, " loaded by rjags ", pkg_compile_flags[["MAJOR_VERSION"]], ".x")
  }else{
    packageStartupMessage("Package module ", pkgname, " was NOT loaded at startup")
  }
}
