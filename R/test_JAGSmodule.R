#' Load the internal JAGS module provided by runjags
#'
#' @name test_JAGSmodule
#' @aliases test_JAGSmodule test_JAGSmodule
#'
#' @description
#' Some basic facilities to test the distributions provided by the package module.
#' TODO: remove and replace with d/p/q/rlomax etc
#'
#' @param distribution One of lomax, mouch, genpar of halfcauchy
#' @param funtype One of d, p or q
#' @param parameters a vector of parameters
#' @param x the x (for funtype="d"), q (for funtype="p"), or p (for funtype="q") value to use in the distribution
#' @param uselog should the probability be returned (or given) on the log axis?
#' @param lower ignored for funtype="d"
#'
#' @keywords methods
#' @seealso
#' \code{\link{load_JAGSmodule}}
#'
#' @references
#' Denwood, M.J. 2016. runjags: An R Package Providing Interface Utilities, Model Templates, Parallel Computing Methods and Additional Distributions for MCMC Models in JAGS. J. Stat. Softw. 71. doi:10.18637/jss.v071.i09.
#'
#' @examples
#' test_JAGSmodule("lomax", "d", c(1,1), 1)
#' test_JAGSmodule("mouch", "p", c(1), 1)
#'
#' @export
test_JAGSmodule <- function(distribution, funtype, parameters, x, uselog=FALSE, lower=TRUE){

  if(!.jags_pkg_env$dyn_loaded){
    stop("The package dynlib was not loaded at package load time", call.=FALSE)
  }

  if(!is.character(distribution)) stop("The distribution type must be one of par1, par2, par3, par4, lomax, mouch, genpar or halfcauchy")
  disttype <- switch(distribution, par1=1, par2=2, par3=3, par4=4, lomax=5, mouch=6, genpar=7, hcauchy=8, halfcauchy=8, 0)
  if(disttype==0) stop("The distribution type must be one of par1, par2, par3, par4, lomax, mouch, genpar or halfcauchy")
  if(disttype %in% 1:4) stop("The par1, par2, par3, par4 distributions are not supported")

  if(!is.character(funtype)) stop("The function type must be one of d, p and q")
  dpqr <- switch(funtype, d=1, p=2, q=3, r=4, 0)
  if(dpqr==0) stop("The function type must be one of d, p and q")
  if(dpqr==4) stop("The function type must be one of d, p and q - r is not available")

  npars <- length(parameters)
  N <- length(x)
  values <- numeric(N)

  # Having problems with bools on sparc, so use ints here:
  output <- .C("testmodule",disttype=as.integer(disttype),dpqr=as.integer(dpqr),uselog=as.integer(uselog),lower=as.integer(lower),N=as.integer(N), x=as.double(x),npars=as.integer(npars),parameters=as.double(parameters),values=as.double(values),status=integer(1),PACKAGE=.jags_pkg_env$pkgname)

  if(output$status==1) stop("Incorrect number of parameters provided")
  if(output$status==2) stop("Unrecognised distribution type")
  if(output$status==3) stop("Invalid parameter values provided")
  if(output$status==4) stop("Function type not valid")
  if(output$status==5) stop("Function type not valid")

  return(output$values)

}
