######################################### DO NOT EDIT! #########################################
#### This file is automatically generated from data-raw/2-generate_r_code_from_containers.R ####
################################################################################################

#' @title Inferring a trajectory inference using reCAT
#' 
#' @description
#' Will generate a trajectory using
#' [reCAT](https://doi.org/10.1038/s41467-017-00039-z).
#' 
#' This method was wrapped inside a
#' [container](https://github.com/dynverse/dynmethods/tree/master/containers/recat).
#' The original code of this method is available
#' [here](https://github.com/tinglab/reCAT).
#' 
#' @references Liu, Z., Lou, H., Xie, K., Wang, H., Chen, N., Aparicio, O.M.,
#' Zhang, M.Q., Jiang, R., Chen, T., 2017. Reconstructing cell cycle pseudo
#' time-series via single-cell transcriptome data. Nature Communications 8.
#' 
#' @param TSPFold integer; No documentation provided by authors (default: `2`;
#' range: from `2` to `10`)
#' @param beginNum integer; No documentation provided by authors (default: `10`;
#' range: from `2` to `20`)
#' @param endNum integer; No documentation provided by authors (default: `15`;
#' range: from `2` to `20`)
#' @param step_size integer; Determines the number of k to skip in your consensus
#' path, ie ifstep_size = 2, then reCAT would only calculate and merge the paths
#' fork = 12, 14, 16, 18, ..., n-2, n. We recommend step_size of up to a maximum
#' of 5 while preserving the performance of reCAT. Usually a step_size of 2 (by
#' default) would suffice and bigger steps are recommended for larger datasets
#' (>1000 cells) in order to reduce computational time. (default: `2`; range: from
#' `2` to `20`)
#' @param base_cycle_range_start integer; The minimal number of four k's for
#' computing the reference cycle mentioned in the manuscript. Can be set to 6 or 7
#' (default: `6`; range: from `6` to `7`)
#' @param base_cycle_range_end integer; The maximal number of four k's for
#' computing the reference cycle mentioned in the manuscript. Can be set to 6 or 7
#' (default: `9`; range: from `9` to `10`)
#' @param max_num integer; No documentation provided by authors (default: `300`;
#' range: from `100` to `500`)
#' @param clustMethod discrete; No documentation provided by authors (default:
#' `"GMM"`; values: {`"GMM"`, `"Pam"`, `"Kmeans"`})
#' @inheritParams dynwrap::create_container_ti_method
#' 
#' @return A TI method wrapper to be used together with
#' \code{\link[dynwrap:infer_trajectories]{infer_trajectory}}
#' @export
ti_recat <- function(
    TSPFold = 2,
    beginNum = 10,
    endNum = 15,
    step_size = 2,
    base_cycle_range_start = 6,
    base_cycle_range_end = 9,
    max_num = 300,
    clustMethod = "GMM",
    run_environment = NULL
) {
  create_container_ti_method(
    docker_repository = "dynverse/recat",
    run_environment = run_environment,
    TSPFold = TSPFold,
    beginNum = beginNum,
    endNum = endNum,
    step_size = step_size,
    base_cycle_range_start = base_cycle_range_start,
    base_cycle_range_end = base_cycle_range_end,
    max_num = max_num,
    clustMethod = clustMethod
  )
}

