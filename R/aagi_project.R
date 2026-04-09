#' Create a new AAGI project
#'
#' Create a new AAGI project with the following structure:
#'
#' \itemize{
#'  \item{A new directory with the name of the project}
#'  \item{A `_quarto.yml` file with the title of the project}
#'  \item{A `index.qmd` file with the title of the project}
#'  \item{A `references.bib` file}
#'  \item{A `pyenv` directory if `python_venv` is `TRUE`}
#'  \item{A `renv` directory if `with_renv` is `TRUE`}
#'  }
#'
#' @param path Path to save the new project
#' @param ... Additional arguments
#'
#' @return A new AAGI project
aagi_project <- function(path, ...) {

  dots <- list(...)
  bundled_extensions <- c("aagi-report", "aagi-short-report", "aagi-presentation")
  valid_doc_types <- c(bundled_extensions, "all")
  doc_type <- dots$doc_type

  if (is.null(doc_type)) {
    doc_type <- "aagi-report"
  }

  if (!doc_type %in% valid_doc_types) {
    stop(
      "Invalid doc_type. Available options are: ",
      paste(valid_doc_types, collapse = ", ")
    )
  }

  if (identical(doc_type, "all")) {
    template_ext <- "aagi-report"
    extra_ext <- setdiff(bundled_extensions, template_ext)
  } else {
    template_ext <- doc_type
    extra_ext <- character(0)
  }

  # Ensure the path exists
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  path <- normalizePath(path)

  # Get the name of the project
  file <- fs::path_file(path)

  # Create _quarto.yml file
  quarto_yml_content <- paste0("project:\n  title: \"", file, "\"\n")
  writeLines(quarto_yml_content, con = file.path(path, "_quarto.yml"))

  # Create index.qmd file and import extension template
  AAGIQuartoExtra::create_aagi_ext(file_name = "index",
                                ext_name = template_ext,
                                university = dots$partner,
                                path = path)

  if (length(extra_ext) > 0) {
    for (ext in extra_ext) {
      file.copy(
        from = system.file(paste0("extdata/_extensions/", ext), package = "AAGIQuartoExtra"),
        to = fs::path(path, "_extensions"),
        overwrite = TRUE,
        recursive = TRUE,
        copy.mode = TRUE
      )
    }
  }

  # Move the references.bib file to the root directory
  file.copy(from = fs::path(path, "_extensions", template_ext, "references", ext = "bib"),
            to = fs::path(path, "references", ext = "bib"),
            overwrite = TRUE)

  # Initialize python virtual environment
  if (dots$python_venv) {
    python_venv_dir <- fs::path(path, "pyenv")
    reticulate::virtualenv_create(python_venv_dir)
  }

  # Initialize renv
  if (dots$with_renv) renv::init(path)
}
