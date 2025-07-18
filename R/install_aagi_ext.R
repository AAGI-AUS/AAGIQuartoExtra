#' Install or Update AAGI Quarto Extension
#'
#' This function installs a specified AAGI Quarto extension into the current
#' working directory or updates an existing installation to the version included
#' in the package. The extension will be installed to the '_extensions' folder
#' in the current directory.
#'
#' @param ext_name String indicating which extension to install. Must be one of 
#'   "aagi-report" or "aagi-short-report".
#' @param force Logical indicating whether to force installation even if the 
#'   extension already exists. Default is FALSE, which will prompt the user
#'   when an existing extension is found.
#'
#' @return Invisibly returns TRUE if the extension was installed or updated,
#'   FALSE otherwise.
#'
#' @examples
#' \dontrun{
#' # Install the AAGI report extension
#' install_aagi_ext("aagi-report")
#' 
#' # Force update the AAGI short report extension
#' install_aagi_ext("aagi-short-report", force = TRUE)
#' }
#'
#' @export
install_aagi_ext <- function(ext_name = "aagi-report", force = FALSE) {
  # Validate the extension name
  valid_extensions <- c("aagi-report", "aagi-short-report")
  if (!ext_name %in% valid_extensions) {
    stop(
      "Invalid extension name. Available extensions are: ",
      paste(valid_extensions, collapse = ", ")
    )
  }

  # Create _extensions directory if it doesn't exist
  if (!dir.exists("_extensions")) {
    dir.create("_extensions", recursive = TRUE, showWarnings = FALSE)
    message("Created '_extensions' folder")
  }

  ext_dir <- file.path("_extensions", ext_name)
  ext_exists <- dir.exists(ext_dir)

  # Check if extension already exists and get user confirmation for update
  if (ext_exists && !force) {
    update_choice <- utils::menu(
      c("Yes", "No"),
      title = paste0(
        "Extension '", ext_name, "' already exists. ",
        "Would you like to update it to the version included in the package?"
      )
    )
    
    if (update_choice != 1) {
      message("Extension update canceled.")
      return(invisible(FALSE))
    }
  }

  # Read extension information before installation
  pkg_ext_path <- system.file(paste0("extdata/_extensions/", ext_name), 
                             package = "AAGIQuartoExtra")
  
  if (pkg_ext_path == "") {
    stop("Extension files not found in the package. Please reinstall the package.")
  }
  
  # Read extension.yml to get version information
  ext_yml_path <- file.path(pkg_ext_path, "_extension.yml")
  if (!file.exists(ext_yml_path)) {
    stop("Extension definition file (_extension.yml) not found.")
  }
  
  ext_yml <- readLines(ext_yml_path)
  
  ext_ver <- trimws(gsub(
    x = ext_yml[grepl(x = ext_yml, pattern = "version:")],
    pattern = "version: ([^#]*)#?.*",
    replacement = "\\1"
  ))
  
  ext_nm <- trimws(gsub(
    x = ext_yml[grepl(x = ext_yml, pattern = "^title:")],
    pattern = "title: ([^#]*)#?.*",
    replacement = "\\1"
  ))

  # Copy extension files to the _extensions folder
  dir.create(ext_dir, recursive = TRUE, showWarnings = FALSE)
  
  file.copy(
    from = list.files(pkg_ext_path, full.names = TRUE),
    to = ext_dir,
    overwrite = TRUE,
    recursive = TRUE
  )

  # Verify installation
  n_files <- length(dir(ext_dir))
  
  if (n_files < 2) {
    message("Extension installation appears to have failed.")
    return(invisible(FALSE))
  } else {
    if (ext_exists) {
      message(paste0(ext_nm, " (v", ext_ver,") ", "has been updated successfully."))
    } else {
      message(paste0(ext_nm, " (v", ext_ver,") ", "has been installed successfully."))
    }
    return(invisible(TRUE))
  }
}
