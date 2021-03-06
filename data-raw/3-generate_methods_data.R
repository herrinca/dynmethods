library(tidyverse)

# generate methods object
devtools::install(dependencies = FALSE)
methods <- dynwrap::get_ti_methods(ti_packages = "dynmethods", evaluate = TRUE) %>%
  select(-method_func)

devtools::use_data(methods, overwrite = TRUE)
devtools::document()
devtools::install(dependencies = FALSE)

