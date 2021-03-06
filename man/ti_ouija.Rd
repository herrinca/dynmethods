% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ti_ouija.R
\name{ti_ouija}
\alias{ti_ouija}
\title{Inferring a trajectory inference using ouija}
\usage{
ti_ouija(iter = 100L, response_type = "switch",
  inference_type = "hmc", normalise_expression = TRUE,
  run_environment = NULL)
}
\arguments{
\item{iter}{numeric; Number of iterations (default: \code{100L}; range: from \code{10L}
to \code{1000L})}

\item{response_type}{discrete; A vector declaring whether each gene exhibits
"switch" or "transient"expression. Defaults to "switch" for all genes (default:
\code{"switch"}; values: {\code{"switch"}, \code{"transient"}})}

\item{inference_type}{discrete; The type of inference to be performed, either
\code{hmc} for HamiltonianMonte Carlo or \code{vb} for ADVI (Variational
Bayes). Note that HMC is typically more accuratebut VB will be orders of
magnitude faster. (default: \code{"hmc"}; values: {\code{"hmc"}, \code{"vb"}})}

\item{normalise_expression}{logical; Logical, default TRUE. If TRUE the data is
pre-normalisedso the average peak expression is approximately 1. This makes the
strength parametersapproximately comparable between genes.}

\item{run_environment}{In which environment to run the method, can be \code{"docker"} or \code{"singularity"}.}
}
\value{
A TI method wrapper to be used together with
\code{\link[dynwrap:infer_trajectories]{infer_trajectory}}
}
\description{
Will generate a trajectory using \href{https://doi.org/10.1101/060442}{ouija}.

This method was wrapped inside a
\href{https://github.com/dynverse/dynmethods/tree/master/containers/ouija}{container}.
The original code of this method is available
\href{https://github.com/kieranrcampbell/ouija}{here}.
}
\references{
Campbell, K.R., Yau, C., 2016. A descriptive marker gene approach
to single-cell pseudotime inference.
}
