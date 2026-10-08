## Install the patched version of rjags-4 (assumes JAGS 4.x is installed):
remotes::install_version("rjags", version="4-18", type="source", repos="https://ku-awdc.github.io/drat/")

## Compile JAGSmodule using compiler flags provided by rjags-4:
install.packages("JAGSmodule", type="source", repos="https://ku-awdc.github.io/drat/")

## Install rjags-5 (assumes JAGS 5.x is installed):
remotes::install_version("rjags", version="5-4", type="source", repos="https://ku-awdc.github.io/drat/")

## Now we will get an informative error:
library("JAGSmodule")

## Until it is re-compiled (after re-starting R):
install.packages("JAGSmodule", type="source", repos="https://ku-awdc.github.io/drat/")
library("JAGSmodule")
rjags::list.modules()
