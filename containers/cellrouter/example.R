set.seed(1)
data <- dyntoy::generate_dataset(
  id = "specific_example/cellrouter",
  num_cells = 200,
  num_features = 300,
  model = "tree"
)
params <- list()
