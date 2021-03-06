% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ti_projected_tscan.R
\name{ti_projected_tscan}
\alias{ti_projected_tscan}
\title{Inferring a trajectory inference using Projected TSCAN}
\usage{
ti_projected_tscan(minexpr_percent = 0, minexpr_value = 0,
  cvcutoff = 0, clusternum_lower = 2L, clusternum_upper = 9L,
  modelNames = "VVV", run_environment = NULL)
}
\arguments{
\item{minexpr_percent}{numeric; (default: \code{0}; range: from \code{0} to \code{1})}

\item{minexpr_value}{numeric; (default: \code{0}; range: from \code{0} to \code{10})}

\item{cvcutoff}{numeric; (default: \code{0}; range: from \code{0} to \code{5})}

\item{clusternum_lower}{integer; (default: \code{2L}; range: from \code{2L} to \code{20L})}

\item{clusternum_upper}{integer; (default: \code{9L}; range: from \code{2L} to \code{20L})}

\item{modelNames}{discrete; (default: \code{"VVV"}; values: {\code{"EII"}, \code{"VII"},
\code{"EEI"}, \code{"VEI"}, \code{"EVI"}, \code{"VVI"}, \code{"EEE"}, \code{"EVE"}, \code{"VEE"}, \code{"VVE"},
\code{"EEV"}, \code{"VEV"}, \code{"EVV"}, \code{"VVV"}})}

\item{run_environment}{In which environment to run the method, can be \code{"docker"} or \code{"singularity"}.}
}
\value{
A TI method wrapper to be used together with
\code{\link[dynwrap:infer_trajectories]{infer_trajectory}}
}
\description{
Will generate a trajectory using Projected TSCAN.

This method was wrapped inside a
\href{https://github.com/dynverse/dynmethods/tree/master/containers/projected_tscan}{container}.
}
