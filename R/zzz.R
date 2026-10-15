# Package environment variables:
.jags_pkg_env <- new.env(parent = emptyenv())
.jags_pkg_env$pkgname <- character(0)
.jags_pkg_env$libname <- character(0)
.jags_pkg_env$dyn_loaded <- FALSE
.jags_pkg_env$pkg_compile_flags <- rjags::pkg.compile.flags("ALL")

.onLoad <- function(libname, pkgname){

  # First try to load rjags:
  tryCatch({
    if(!isNamespaceLoaded("rjags")) loadNamespace("rjags")
  }, error = function(e) {
    stop("The following error was obtained when attaching rjags:\n\t", conditionMessage(e), call.=FALSE)
  })

  # Preserve the name of the package for use in .onUnload etc:
  .jags_pkg_env$pkgname <- pkgname
  .jags_pkg_env$libname <- libname

  # The dynlib isn't present when running roxygen:
  if(!file.exists(file.path(libname, pkgname, "libs", paste0(pkgname, .Platform$dynlib.ext)))){
    cat("Note: non-existant dynlib (this is expected during roxygenization)\n")
  }else{
    tryCatch({
      # First load the dynamic library:
      library.dynam(pkgname, pkgname, libname)
      # And set the dyn_loaded flag to TRUE:
      .jags_pkg_env$dyn_loaded <- TRUE
      # Then load the module:
      suppressMessages(rjags::load.pkg.module(pkgname, libname, .jags_pkg_env$pkg_compile_flags))

    }, error = function(e) {
      stop("Loading the module/dynlib failed with the following error:\n\t", conditionMessage(e), call.=FALSE)
    })
  }

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
