#' Create new Quarto document from template
#'
#' Create a new AAGI Quarto document. If the extension is not already
#' installed, it will be copied over to the `_extensions` folder in the
#' current working directory. This function extends a function written by
#' Thomas Mock: https://github.com/jthomasmock/octavo/blob/master/R/use_quarto_ext.R
#' and by Spencer Schien: https://spencerschien.info/post/r_for_nonprofits/quarto_template/
#'
#' @param file_name Name of new qmd file and sub-directory to be created
#' @param ext_name String indicating which extension to install
#' @param university String indicating which university partner to use
#' @param update Logical indicating whether to update the extension if it already exists
#'
#' @export
new_aagi_document <- function(file_name = NULL,
                              ext_name = "aagi-report",
                              university = "UQ",
                              update = FALSE) {

  if (is.null(file_name)) {
    stop("You must provide a valid file_name")
  }

  stopifnot("Extension not in package" = ext_name %in% c("aagi-report", "aagi-short-report"))

  if(!file.exists("_extensions")) {
    dir.create("_extensions")
    message("Created '_extensions' folder")
  }

  if(!file.exists(paste0("_extensions/", ext_name)) || update) {

    dir.create(paste0("_extensions/", ext_name), recursive = TRUE, showWarnings = FALSE)

    file.copy(
      from = system.file(paste0("extdata/_extensions/", ext_name), package = "AAGIQuartoExtra"),
      to = paste0("_extensions/"),
      overwrite = TRUE,
      recursive = TRUE,
      copy.mode = TRUE
    )

  }

  n_files <- length(dir(paste0("_extensions/", ext_name)))

  if(n_files < 2){
    message("Extension appears not to have been created")
  } else if (n_files >= 2 && update) {
    message("Extension was updated successfully")
  } else {
    message("Extension appears installed in the '_extensions' folder")
  }

  template_lines <- readLines(paste0("_extensions/", ext_name, "/template.qmd"))

  if (university == "UA") {
    template_lines <- gsub(
      "report-series: \".*\"",
      'report-series: "Analytics for the Australian Grains Industry - University of Adelaide (AAGI-UA)"',
      template_lines
    )
    template_lines <- gsub(
      'email: \".*\"',
      'email: "your.email@adelaide.edu.au"',
      template_lines
    )
  } else if (university == "CU") {
    template_lines <- gsub(
      "report-series: \".*\"",
      'report-series: "Analytics for the Australian Grains Industry - Curtin University (AAGI-CU)"',
      template_lines
    )
    template_lines <- gsub(
      'email: \".*\"',
      'email: "your.email@curtin.edu.au"',
      template_lines
    )
  } else if (university == "UQ") {
    template_lines <- gsub(
      "report-series: \".*\"",
      'report-series: "Analytics for the Australian Grains Industry - University of Queensland (AAGI-UQ)"',
      template_lines
    )
    template_lines <- gsub(
      'email: \".*\"',
      'email: "your.email@uq.edu.au"',
      template_lines
    )
  }

  writeLines(text = template_lines, con = paste0(file_name, ".qmd", collapse = ""))

  rstudioapi::navigateToFile(paste0(file_name, ".qmd", collapse = ""))
}
