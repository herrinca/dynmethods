generate_file_from_container <- function(container) {
  definition <- dynwrap::extract_definition_from_docker_image(container)

  file_text <- paste0(
    # header
    "######################################### DO NOT EDIT! #########################################\n",
    "#### This file is automatically generated from data-raw/2-generate_r_code_from_containers.R ####\n",
    "################################################################################################\n",
    "\n",

    # documentation
    generate_documentation_from_definition(definition), "\n",

    # function
    generate_function_from_definition(definition), "\n"
  )

  path <- paste0("R/ti_", definition$id, ".R")

  readr::write_file(file_text, path)
}


generate_documentation_from_definition <- function(definition) {
  # url within name
  c(
    paste0("@title Inferring a trajectory inference using ", definition$name),
    "",
    "@description ", format_description(definition),
    "",
    format_container_url(definition),
    format_code_url(definition),
    "",
    format_citation(definition),
    "",
    format_parameter_documentation(definition),
    "",
    "@return A TI method wrapper to be used together with \\code{\\link[dynwrap:infer_trajectories]{infer_trajectory}}",
    "@export"
  ) %>%
    strwrap(width = 80) %>%
    paste0("#' ", ., collapse = "\n")
}

generate_function_from_definition <- function(definition) {
  # forbidden are forbidden combinations of parameters; e.g. xmin > xmax.
  parameter_ids <-
    names(definition$parameters) %>%
    keep(~. != "forbidden")

  # collect default parameters
  parameters <- map_chr(parameter_ids, function (pid) {
    paste0(
      pid,
      " = ",
      deparse(definition$parameters[[pid]]$default, width.cutoff = 500)
    )
  }) %>%
    c(., "run_environment = NULL") %>%
    paste0("    ", ., collapse = ",\n")

  # generate code for passing the default parameters to create_ti_method
  args <- map_chr(parameter_ids, ~ paste0(., " = ", .)) %>%
    paste0("    ", ., collapse = ",\n")

  # return code for function
  paste0(
    "ti_", definition$id, " <- function(\n",
    parameters, "\n",
    ") {\n",
    "  create_container_ti_method(\n",
    "    docker_repository = \"", definition$docker_repository, "\",\n",
    "    run_environment = run_environment,\n",
    args, "\n",
    "  )\n",
    "}\n"
  )
}

format_description <- function(definition) {
  if (!is.null(definition$description)) {
    definition$description
  } else {
    paste0("Will generate a trajectory using ", format_url_name(definition), ".")
  }
}

format_code_url <- function(definition) {
  if (!is.null(definition$code_url)) {
    paste0("The original code of this method is available [here](", definition$code_url, ").")
  } else {
    ""
  }
}

format_container_url <- function(definition) {
  if (!is.null(definition$container_url)) {
    paste0("This method was wrapped inside a [container](", definition$container_url, ").")
  } else {
    ""
  }
}

#' @importFrom rcrossref cr_cn
format_citation <- function(definition) {
  if (!is.null(definition$doi)) {
    paste0(
      "@references ",
      rcrossref::cr_cn(dois = definition$doi[[1]], format = "text", style = "elsevier-harvard")
    )
  } else {
    ""
  }
}

format_url_name <- function(definition) {
  if (!is.null(definition$doi)) {
    paste0("[", definition$name, "](https://doi.org/", definition$doi[[1]], ")")
  } else if (!is.null(definition$code_url)) {
    paste0("[", definition$name, "](", definition$code_url, ")")
  } else {
    definition$name
  }
}

#' @importFrom Hmisc capitalize
format_parameter_documentation <- function(definition) {
  # forbidden are forbidden combinations of parameters; e.g. xmin > xmax.
  parameter_ids <-
    names(definition$parameters) %>%
    keep(~. != "forbidden")

  # generate documentation per parameter separately
  param_texts <- map_chr(
    parameter_ids,
    function(parameter_id) {
      parameter <- definition$parameters[[parameter_id]]

      description <-
        parameter$description %>%
        ifelse(!is.null(.), ., "") %>%     # use "" if no description is provided
        str_replace_all("\n", "") %>%      # remove newlines
        Hmisc::capitalize()                # capitalise sentences

      range_text <-
        case_when(
          parameter$type == "discrete" ~ paste0("; values: {", paste0("`", sapply(parameter$values, deparse), "`", collapse = ", "), "}"),
          parameter$type %in% c("integer", "numeric") ~ paste0("; range: from `", deparse(parameter$lower), "` to `", deparse(parameter$upper), "`"),
          TRUE ~ ""
        )

      defaults <-
        case_when(
          parameter$type %in% c("integer", "numeric", "discrete") ~ paste0(" (default: `", deparse(parameter$default, width.cutoff = 500), "`", range_text, ")"),
          TRUE ~ ""
        )

      paste0("@param ", parameter_id, " ", parameter$type, "; ", description, defaults)
    }
  )

  c(param_texts, "@inheritParams dynwrap::create_container_ti_method")
}
