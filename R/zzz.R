# Package environment variables:
.jags_pkg_env <- new.env(parent = emptyenv())
.jags_pkg_env$pkgname <- character(0)
.jags_pkg_env$libname <- character(0)
.jags_pkg_env$dyn_loaded <- FALSE
.jags_pkg_env$pkg_compile_flags <- rjags::pkg.compile.flags("ALL")

.onLoad <- function(libname, pkgname){

  # Preserve the name of the package for use in .onUnload etc:
  .jags_pkg_env$pkgname <- pkgname
  .jags_pkg_env$libname <- libname

  # This will fail if running roxygen but allow proceeding:
  tryCatch({
    # First allow rjags to check for the presence of JAGS and load the module:
    suppressMessages(rjags::load.pkg.module(pkgname, libname, .jags_pkg_env$pkg_compile_flags))
    # Then load the rest of the dynamic library:
    library.dynam(pkgname, pkgname, libname)
    # And set the dyn_loaded flag to TRUE:
    .jags_pkg_env$dyn_loaded <- TRUE

  }, error = function(e) {
    warning("Failed to load the module/dynlib: this is expected during roxygenization", call.=FALSE)
  })

}

.onAttach <- function(libname, pkgname){
  if(pkgname %in% rjags::list.modules()){
    packageStartupMessage("Package module ", pkgname, " loaded")
  }else{
    packageStartupMessage("Package module ", pkgname, " was NOT loaded at startup")
  }
}

.onUnload <- function(libname){
  # First unload the JAGS module, if loaded:
  if(.jags_pkg_env$pkgname %in% rjags::list.modules()){
    rjags::unload.module(.jags_pkg_env$pkgname, quiet = TRUE)
  }
  # Then the dynlib, if loaded by .onLoad:
  if(.jags_pkg_env$dyn_loaded){
    library.dynam.unload(.jags_pkg_env$pkgname, libname)
  }
}
