## Install the patched version of rjags-4 (assumes JAGS 4.x is installed) and JAGSmodule from r-universe:
install.packages(c("rjags","JAGSmodule"), repos = c('https://ku-awdc.r-universe.dev', 'https://cloud.r-project.org'))
library("JAGSmodule")
unloadNamespace("JAGSmodule")

## Re-compile JAGSmodule locally using compiler flags provided by rjags-4:
install.packages("JAGSmodule", type="source", repos = 'https://ku-awdc.r-universe.dev')
library("JAGSmodule")
unloadNamespace("JAGSmodule")
unloadNamespace("rjags")

## Restart R (required on macOS at least)

## Install rjags-5 (assumes JAGS 5.x is installed):
remotes::install_version("rjags", version="5-4", type="source", repos="https://ku-awdc.github.io/drat/")

## Now we will get an informative error:
library("JAGSmodule")

## Until it is re-compiled (after re-starting R again):
install.packages("JAGSmodule", type="source", repos="https://ku-awdc.r-universe.dev")
library("JAGSmodule")
rjags::list.modules()
