library(dplyr)
library(purrr)
library(readr)
library(tibble)
library(igraph)

library(CellTrails)

checkpoints <- list()

#   ____________________________________________________________________________
#   Load data                                                               ####

data <- read_rds("/input/data.rds")
expression <- data$expression

params <- jsonlite::read_json("/input/params.json")

checkpoints$method_afterpreproc <- as.numeric(Sys.time())

#   ____________________________________________________________________________
#   Infer trajectory                                                        ####
# steps from the vignette https://dcellwanger.github.io/CellTrails/

sce <- SingleCellExperiment(assays=list(logcounts = t(expression)))

# filter features
tfeat1 <- filterTrajFeaturesByDL(sce, threshold = params$threshold_dl, show_plot = FALSE)
tfeat2 <- filterTrajFeaturesByCOV(sce, threshold = params$threshold_cov, show_plot = FALSE)
tfeat3 <- filterTrajFeaturesByFF(sce, threshold = params$threshold_ff, show_plot = FALSE)

trajFeatureNames(sce) <- Reduce(intersect, list(tfeat1, tfeat2, tfeat3))

# dimensionality reduction
se <- embedSamples(sce)
d <- findSpectrum(se$eigenvalues, frac=params$frac)
latentSpace(sce) <- se$components[, d]

# find states
cl <- findStates(sce, min_size = params$min_size, min_feat = params$min_feat, max_pval = params$max_pval, min_fc = params$min_fc)
states(sce) <- cl

# construct tree
sce <- connectStates(sce, l = params$l)

# fit trajectory
# this object can contain multiple trajectories (= "components"), so we have to extract information for every one of them and combine afterwards
components <- CellTrails::trajComponents(sce)

# only retain components with more than 2 states, otherwise the fitTrajectory will error
components_ix <- seq_along(components)[map_lgl(components, ~length(.) > 1)]

trajectories <- map(
  components_ix,
  function(trajectory_ix) {
    traj <- selectTrajectory(sce, trajectory_ix)
    fitTrajectory(traj)
  }
)


checkpoints$method_aftermethod <- as.numeric(Sys.time())

#   ____________________________________________________________________________
#   Process cell graph                                                      ####

cell_ids <- sampleNames(sce)
grouping <- sce$CellTrails.state %>% as.character() %>% set_names(cell_ids)
dimred <- sce@reducedDims$CellTrails

cell_graph <- map_dfr(
  trajectories,
  function(traj) {
    graph <- CellTrails:::.trajGraph(traj)
    cell_ids_graph <- igraph::vertex.attributes(graph)$sampleName
    cell_graph <- graph %>%
      igraph::as_data_frame() %>%
      mutate(
        from = cell_ids_graph[as.numeric(from)],
        to = cell_ids_graph[as.numeric(to)],
        directed = FALSE
      ) %>%
      dplyr::rename(
        length = weight
      )
  }
)

to_keep <- unique(c(cell_graph$from, cell_graph$to))

lst(
  grouping,
  dimred,
  cell_graph,
  to_keep,
  timings = checkpoints
) %>% write_rds("/output/output.rds")