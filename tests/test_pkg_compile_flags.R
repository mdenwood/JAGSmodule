## Test we can load JAGSmodule then rjags:
library("JAGSmodule")
library("rjags")
stopifnot("JAGSmodule" %in% list.modules())
unloadNamespace("JAGSmodule")
stopifnot(!"JAGSmodule" %in% list.modules())
unloadNamespace("rjags")

## And vice versa:
library("rjags")
library("JAGSmodule")
stopifnot("JAGSmodule" %in% list.modules())
unloadNamespace("JAGSmodule")
stopifnot(!"JAGSmodule" %in% list.modules())

## Test loading without attaching:
stopifnot(requireNamespace("JAGSmodule"))
stopifnot("JAGSmodule" %in% list.modules())
unloadNamespace("JAGSmodule")

## Output of package compile flags:
rjags::pkg.compile.flags()
JAGSmodule:::.jags_pkg_env$pkg_compile_flags
