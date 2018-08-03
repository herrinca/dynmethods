library(tidyverse)

rm(list = ls())

method <- "new_method"
file <- paste0("containers/", method, "/definition.yml")

# read definition and build docker
definition <- yaml::read_yaml(file)
docker_repo <- definition$docker_repository
folder <- stringr::str_replace(file, "/definition.yml$", "")
zzz <- processx::run("docker", args = c("build", folder, "-t", docker_repo), echo = TRUE)

# generate R file in dynmethods
devtools::load_all()
definition <- dynwrap::extract_definition_from_docker_image(docker_repo)
source("data-raw/2a-helper_functions.R")
file_text <- paste0(
  "######################################### DO NOT EDIT! #########################################\n",
  "#### This file is automatically generated from data-raw/2-generate_r_code_from_containers.R ####\n",
  "################################################################################################\n",
  "\n",
  generate_documentation_from_definition(definition), "\n",
  generate_function_from_definition(definition), "\n"
)
path <- paste0("R/ti_", definition$id, ".R")
readr::write_file(file_text, path)
devtools::document()
devtools::install(dep = FALSE)

# rebuild if changes were made
zzz <- processx::run("docker", args = c("build", folder, "-t", docker_repo), echo = TRUE)

# try to run the method with a toy dataset
source(paste0(folder, "/example.R"))
traj <- dynwrap::infer_trajectory(data, method, parameters = params, verbose = TRUE, debug = TRUE)
traj <- dynwrap::infer_trajectory(data, method, parameters = params, verbose = TRUE)
dynplot::plot_graph(traj)

# if it works, you can push it
# processx::run("docker", args = c("push", docker_repo), echo = TRUE)