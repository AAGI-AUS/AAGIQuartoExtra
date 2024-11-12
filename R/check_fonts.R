#' Internal: Check if the Proxima Nova font is installed
#'
#' This function checks if the Proxima Nova font is installed on the user's system.
#'
#' @return TRUE if the Proxima Nova font is installed, FALSE otherwise
check_proxima_nova_installed <- function() {
  # Load necessary libraries
  if (!requireNamespace("systemfonts", quietly = TRUE)) {
    utils::install.packages("systemfonts")
  }

  fonts <- systemfonts::system_fonts()
  any(grepl("Proxima Nova", fonts$family))
}


#' Internal: Function to display instructions for setting up the font
#'
#' This function displays instructions for setting up the Proxima Nova font for use in the Quarto project.
#'
#' @return NULL
display_font_setup_instructions <- function() {
  message("The Proxima Nova font is not installed on your system.")

  message("\nTo use this font, you can either:")
  message("1. Install the Proxima Nova font on your system, or")
  message("2. Download the Proxima Nova font files (OTF format) and place them in a '_extensions/aagi/fonts/' directory within your Quarto project.")

  message("\nIf you have access to the AAGI private repository, you can run the `AAGIQuartoExtra::download_fonts()` function to fetch the font files.")

  message("\nThe template will use Arial as the fallback font.")
}


#' Check if the Proxima Nova font is installed
#'
#' This function checks if the Proxima Nova font is installed on the user's system. If the font is not installed, it provides instructions on how to set up the font for use in the Quarto project.
#'
#' @return NULL
#' @export
check_fonts <- function() {
  # Check if Proxima Nova is installed
  if (!check_proxima_nova_installed()) {
    # If not installed, check if we have the font locally in the 'local_fonts/fonts/' directory
    local_font_path <- "_extensions/aagi-report/fonts/ProximaNova.sty"

    if (!file.exists(local_font_path)) {
      # Display instructions if the font is not found locally
      display_font_setup_instructions()
    } else {
      # If the font is found locally, set the font path
      message("Proxima Nova font found locally.")
    }
  } else {
    message("Proxima Nova font is installed on your system.")
  }
}
