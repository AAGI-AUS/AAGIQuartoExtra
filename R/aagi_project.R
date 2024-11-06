# this is the function used for the RStudio project template
aagi_project <- function(path, ...) {

  dots <- list(...)

  # ensure the path exists
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  path <- normalizePath(path)

  # get the name of the project
  file <- fs::path_file(path)

  # create _quarto.yml file
  quarto_yml_content <- paste0("project:\n  title: \"", file, "\"\n")
  writeLines(quarto_yml_content, con = file.path(path, "_quarto.yml"))

  # create index.qmd file
  JAFtoolbox::create_aagi_ext(file_name = "index",
                                ext_name = dots$doc_type,
                                university = dots$partner,
                                path = path)

  # move the references.bib file inside _extentions/aagi/ move it to the root
  file.copy(from = fs::path(path, "_extensions/aagi/references.bib"),
            to = fs::path(path, "references.bib"),
            overwrite = TRUE)

  # initialize python virtual environment
  if (dots$python_venv) {
    python_venv_dir <- fs::path(path, "pyenv")
    reticulate::virtualenv_create(python_venv_dir)
  }

  # initialize renv
  if (dots$with_renv) renv::init(path)
}


