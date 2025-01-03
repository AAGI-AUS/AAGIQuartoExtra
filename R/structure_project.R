#' Create a Standard Folder Structure for a Quarto Project
#'
#' This function creates a standardized folder structure for a Quarto project.
#' The structure includes folders for data, code, figures, documents, outputs, source files, and admin tasks.
#'
#' @param project_path Character. The root path of the Quarto project where the folders will be created.
#'
#' @details
#' - **data**: Contains the raw data files used in the project. These files should not be altered and are ideally read-only.
#' - **code**: Contains the scripts or code files used to run the project.
#' - **figs**: Contains plots, images, tables, or figures created and saved by your code.
#'   It should be possible to delete and regenerate this folder with the scripts in the project.
#' - **doc**: Contains any manuscripts or interim summaries produced during the project.
#' - **output**: Contains non-figure objects created by the scripts, such as processed data or logs.
#' - **src**: Contains any files you may want to `source()` in your scripts, such as .R files containing helper functions.
#' - **admin**: Contains administrative files related to the project (e.g., notes, project planning documents, and metadata).
#'
#' @note Folder structure inspired by Kathryn Destasio's best practices for R projects: https://kdestasio.github.io/post/r_best_practices/
#'
#' @export
setup_folders <- function(project_path = ".") {

  # Ensure project path exists
  if (!dir.exists(project_path)) {
    stop("The specified project path does not exist.")
  }

  # Define folder names and descriptions
  folders <- list(
    data = "Contains raw data files used in the project. Ideally read-only.",
    code = "Contains scripts or code files used to run the project.",
    figs = "Contains plots, images, tables, or figures created and saved by your code.",
    doc = "Contains any manuscripts or interim summaries produced during the project.",
    output = "Contains non-figure objects created by the scripts, such as processed data or logs.",
    src = "Contains files you may want to `source()` in your scripts (e.g., helper functions).",
    admin = "Contains administrative files, such as project notes, metadata, or planning documents."
  )

  # Create folders and output messages
  lapply(names(folders), function(folder_name) {
    folder_path <- file.path(project_path, folder_name)
    if (!dir.exists(folder_path)) {
      dir.create(folder_path, recursive = TRUE)
      message(paste("Created folder:", folder_name, "-", folders[[folder_name]]))
    } else {
      message(paste("Folder already exists:", folder_name))
    }
  })

  invisible(TRUE)
}


#' Rename the index.qmd File and Update _quarto.yml for a Quarto Project
#'
#' This function renames the `index.qmd` file to a new name based on the project name and output type.
#' It also updates the `_quarto.yml` file to specify the output type and directory for the project.
#' This function should be run in the root directory of a Quarto project and after the `setup_folders()` function.
#'
#' @param output_type Character. The type of output to be generated (e.g., "Report", "Slides", "Manuscript").
#'
#' @details
#' The function extracts the project name from the directory name and uses it to rename the `index.qmd` file.
#' The new file name format is `01_projectname_outputtype.qmd`.
#' The `_quarto.yml` file is updated with the output type and directory for the project.
#'
#' @export
setup_docs <- function(output_type = "Report") {
  # Get the current working directory as the project directory
  project_dir <- getwd()

  # Ensure the project directory exists
  if (!dir.exists(project_dir)) {
    stop("The current working directory is not valid as a project directory.")
  }

  # Extract project name without prefix before the underscore
  project_name <- sub("^[^_]*_", "", basename(project_dir))

  # Define paths
  index_file <- file.path(project_dir, "index.qmd")
  new_doc_file <- file.path(project_dir, paste0("01_", project_name, "_", output_type, ".qmd"))
  yaml_file <- file.path(project_dir, "_quarto.yml")

  # Ensure the index.qmd file exists
  if (!file.exists(index_file)) {
    stop("index.qmd file does not exist in the project directory.")
  }

  # Rename the index.qmd file to the new name
  file.rename(index_file, new_doc_file)

  # Read and update the _quarto.yml file
  if (file.exists(yaml_file)) {
    yaml_content <- readLines(yaml_file)
  } else {
    yaml_content <- c("project:", "  title: \"\"")
  }

  # Update YAML with the new rendering configuration
  yaml_content <- c(
    yaml_content,
    "  type: default",
    "  output-dir: doc"
  )

  # Write updated YAML back to the file
  writeLines(yaml_content, yaml_file)

  message("Renamed index.qmd to ", new_doc_file, " and updated _quarto.yml.")
}
