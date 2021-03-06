% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/repRisk.R
\name{repRisk}
\alias{repRisk}
\alias{repRisk.ffm}
\alias{repRisk.tsfm}
\title{Decompose portfolio risk into individual factor contributions and provide tabular report}
\usage{
repRisk(object, ...)

\method{repRisk}{tsfm}(object, weights = NULL, risk = c("Sd", "VaR", "ES"),
  decomp = c("RM", "FMCR", "FCR", "FPCR"), digits = NULL, invert = FALSE,
  nrowPrint = 20, p = 0.95, type = c("np", "normal"),
  use = "pairwise.complete.obs", bystock = TRUE, isPrint = TRUE,
  isPlot = TRUE, ...)

\method{repRisk}{ffm}(object, weights = NULL, risk = c("Sd", "VaR", "ES"),
  decomp = c("RM", "FMCR", "FCR", "FPCR"), digits = NULL, invert = FALSE,
  nrowPrint = 20, p = 0.95, type = c("np", "normal"), bystock = TRUE,
  isPrint = TRUE, isPlot = TRUE, ...)
}
\arguments{
\item{object}{fit object of class \code{tsfm}, or \code{ffm}.}

\item{...}{other optional arguments passed to \code{\link[stats]{quantile}} and 
optional arguments passed to \code{\link[stats]{cov}}}

\item{weights}{a vector of weights of the assets in the portfolio, names of 
the vector should match with asset names. Default is NULL, in which case an 
equal weights will be used.}

\item{risk}{one of 'Sd' (standard deviation), 'VaR' (Value-at-Risk) or 'ES' (Expected Tail 
Loss or Expected Shortfall for calculating risk decompositon. Default is 'Sd'}

\item{decomp}{one of 'RM' (risk measure), 'FMCR' (factor marginal contribution to risk), 
'FCR' 'factor contribution to risk' or 'FPCR' (factor percent contribution to risk). Default is 'RM'}

\item{digits}{digits of number in the resulting table. Default is NULL, in which case digtis = 3 will be
used for decomp = ('RM', 'FMCR', 'FCR'), digits = 1 will be used for decomp = 'FPCR'. Used only when 
isPrint = 'TRUE'}

\item{invert}{a logical variable to choose if change VaR/ES to positive number, default
is False}

\item{nrowPrint}{a numerical value deciding number of assets/portfolio in result vector/table to print.
Used only when isPrint = 'TRUE'}

\item{p}{confidence level for calculation. Default is 0.95.}

\item{type}{one of "np" (non-parametric) or "normal" for calculating VaR & Es. 
Default is "np".}

\item{use}{an optional character string giving a method for computing factor
covariances in the presence of missing values. This must be (an 
abbreviation of) one of the strings "everything", "all.obs", 
"complete.obs", "na.or.complete", or "pairwise.complete.obs". Default is 
"pairwise.complete.obs".}

\item{bystock}{a logical value to choose slice/condition by stock(TRUE) or factors(FALSE. Default is TRUE.
Used only when isPlot = 'TRUE'}

\item{isPrint}{logical variable to print numeric output or not.}

\item{isPlot}{logical variable to generate plot or not. isPlot = FALSE when decomp = 'RM'.}
}
\value{
A table containing 
\item{decomp = 'RM'}{length-(N + 1) vector of factor model risk measure of portfolio return 
as well assets return.}
\item{decomp = 'FMCR'}{(N + 1) * (K + 1) matrix of marginal contributions to risk of portfolio 
return as well assets return, with first row of values for the portfolio and the remaining rows for 
the assets in the portfolio, with  (K + 1) columns containing values for the K risk factors and the
residual respectively}
\item{decomp = 'FCR'}{(N + 1) * (K + 2) matrix of component contributions to risk of portfolio 
return as well assets return, with first row of values for the portfolio and the remaining rows for 
the assets in the portfolio, with  first column containing portfolio and asset risk values and remaining
(K + 1) columns containing values for the K risk factors and the residual respectively}
\item{decomp = 'FPCR'}{(N + 1) * (K + 1) matrix of percentage component contributions to risk 
of portfolio return as well assets return, with first row of values for the portfolio and the remaining rows for 
the assets in the portfolio, with  (K + 1) columns containing values for the K risk factors and the
residual respectively}
Where, K is the number of factors, N is the number of assets.
}
\description{
Compute the factor contributions to standard deviation (SD), Value-at-Risk (VaR), 
Expected Tail Loss or Expected Shortfall (ES) of the return of individual asset within a portfolio 
return of a portfolio based on Euler's theorem, given the fitted factor model.
}
\examples{
# Time Series Factor Model
data(managers)
fit.macro <- factorAnalytics::fitTsfm(asset.names=colnames(managers[,(1:6)]),
                     factor.names=colnames(managers[,(7:9)]),
                     rf.name=colnames(managers[,10]), data=managers)
report <- repRisk(fit.macro, risk = "ES", decomp = 'FPCR', 
                  nrowPrint = 10)
report 

# plot
repRisk(fit.macro, risk = "ES", decomp = 'FPCR', isPrint = FALSE, 
        isPlot = TRUE)

# Fundamental Factor Model
data("stocks145scores6")
dat = stocks145scores6
dat$DATE = as.yearmon(dat$DATE)
dat = dat[dat$DATE >=as.yearmon("2008-01-01") & 
          dat$DATE <= as.yearmon("2012-12-31"),]

# Load long-only GMV weights for the return data
data("wtsStocks145GmvLo")
wtsStocks145GmvLo = round(wtsStocks145GmvLo,5)  
                                                     
# fit a fundamental factor model
fit.cross <- fitFfm(data = dat, 
              exposure.vars = c("SECTOR","ROE","BP","MOM121","SIZE","VOL121",
              "EP"),date.var = "DATE", ret.var = "RETURN", asset.var = "TICKER", 
              fit.method="WLS", z.score = TRUE)
repRisk(fit.cross, risk = "Sd", decomp = 'FCR', nrowPrint = 10,
        digits = 4) 
# get the factor contributions of risk 
repRisk(fit.cross, wtsStocks145GmvLo, risk = "Sd", decomp = 'FPCR', 
        nrowPrint = 10)               
# plot
repRisk(fit.cross, wtsStocks145GmvLo, risk = "Sd", decomp = 'FPCR', 
        isPrint = FALSE, isPlot = TRUE)  
}
\author{
Douglas Martin, Lingjie Yi
}
\seealso{
\code{\link{fitTsfm}}, \code{\link{fitFfm}}
for the different factor model fitting functions.

\code{\link{portSdDecomp}} for factor model Sd decomposition.
\code{\link{portVaRDecomp}} for factor model VaR decomposition.
\code{\link{portEsDecomp}} for factor model ES decomposition.
}

