#  R package JAGSmodule file R/zzz.R
#  Copyright (C) 2026 Matt Denwood
#
#  This file can be used (unmodified) by any R package wishing to implement
#  an inbuilt JAGS module
#
#  This program is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public License version
#  2 as published by the Free Software Foundation.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  A copy of the GNU General Public License is available at
#  http://www.r-project.org/Licenses/

#' @importFrom rjags load.pkg.module unload.module list.modules

# Package environment variables:
.jags_pkg_env <- new.env(parent = emptyenv())
.jags_pkg_env$pkgname <- character(0)
.jags_pkg_env$libname <- character(0)
.jags_pkg_env$dyn_loaded <- FALSE
.jags_pkg_env$pkg_compile_flags <- rjags::pkg.compile.flags("ALL")

.onLoad <- function(libname, pkgname){

  # First try to load rjags (this sets paths on Windows etc):
  tryCatch({
    if(!isNamespaceLoaded("rjags")) loadNamespace("rjags")
  }, error = function(e) {
    stop("The following error was obtained when loading rjags:\n\t",
         conditionMessage(e), call.=FALSE)
  })

  # Preserve the name of the package for use in .onUnload etc:
  .jags_pkg_env$pkgname <- pkgname
  .jags_pkg_env$libname <- libname

  # Guard against non-present dynlib when running roxygen:
  if(file.exists(file.path(libname, pkgname, "libs",
                            paste0(pkgname, .Platform$dynlib.ext)))){
    tryCatch({
      # Load the dynamic library:
      library.dynam(pkgname, pkgname, libname)
      # And set the dyn_loaded flag to TRUE:
      .jags_pkg_env$dyn_loaded <- TRUE
    }, error = function(e) {
      stop("Loading the package dynlib failed with the following error:\n\t", conditionMessage(e), call.=FALSE)
    })
  }

}

.onAttach <- function(libname, pkgname){
  # Only attempt to load the package module if the dynlib is loaded:
  if(.jags_pkg_env$dyn_loaded){
    tryCatch({
      # Load the package module:
      suppressMessages(rjags::load.pkg.module(pkgname, libname, .jags_pkg_env$pkg_compile_flags))
      packageStartupMessage("module ", pkgname, " loaded")
    }, error = function(e) {
      stop("Loading the JAGS module failed with the following error:\n\t", conditionMessage(e), call.=FALSE)
    })
  }else{
    packageStartupMessage("The JAGS module was not loaded because the package dynlib wasn't found\n(this is expected during roxygenization and with devtools::load_all)")
  }
}

.onDetach <- function(libname){
  # Unload the JAGS module (silently), if loaded:
  if(.jags_pkg_env$pkgname %in% list.modules()){
    unload.module(.jags_pkg_env$pkgname, quiet = TRUE)
  }
}

.onUnload <- function(libname){
  # First unload the JAGS module (silently), if loaded:
  if(.jags_pkg_env$pkgname %in% list.modules()){
    unload.module(.jags_pkg_env$pkgname, quiet = TRUE)
  }
  # Then the dynlib, if loaded by .onLoad:
  if(.jags_pkg_env$dyn_loaded){
    library.dynam.unload(.jags_pkg_env$pkgname, libname)
  }
}
