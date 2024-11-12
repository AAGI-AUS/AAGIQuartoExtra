#' Helper function to setup GITHUB_PAT interactively
#'
#' This function provides instructions to the user on how to create a GitHub Personal Access Token (PAT) and set it up for use in the current R session.
#'
#' @return TRUE if the GITHUB_PAT is successfully set up, FALSE otherwise
setup_github_pat <- function() {
  # Check if GITHUB_PAT is already set
  pat <- Sys.getenv("GITHUB_PAT")
  if (nzchar(pat)) {
    message("Your GITHUB_PAT is already set.")
    return(TRUE)
  }

  # Display explanation message
  message("It seems that your GITHUB_PAT is not set or not available.")
  message("This is required to access private repositories for font files.")

  # Provide instructions
  message("\nPlease follow these steps to create and set up your GITHUB_PAT:")
  message("1. Go to: https://github.com/settings/tokens")
  message("2. Click on 'Generate new token' and provide a name and expiration date for your token.")
  message("3. Under 'Select scopes', choose at least 'repo' to enable access to private repositories.")
  message("4. Click 'Generate token' at the bottom and copy the generated token.\n")

  # Ask user if they want to open the GitHub token page
  answer <- readline(prompt = "Would you like to open the GitHub token creation page now? [Y/n]: ")
  if (tolower(answer) %in% c("y", "")) {
    # Open GitHub token creation page in browser
    utils::browseURL("https://github.com/settings/tokens")
  }

  # Prompt user to enter their PAT
  pat <- readline(prompt = "Please enter your newly generated GITHUB_PAT: ")

  # Check if the input PAT is valid (PAT should be 40 characters long)
  if (nchar(pat) == 40) {
    # Ask the user if they want to store it in .Renviron
    answer <- readline(prompt = "Would you like to save this PAT to your .Renviron file for future use? [Y/n]: ")

    if (tolower(answer) %in% c("y", "")) {
      # Write the PAT to the .Renviron file
      renviron_path <- normalizePath("~/.Renviron", mustWork = FALSE)

      # Check if .Renviron already exists, if not create it
      if (!file.exists(renviron_path)) {
        file.create(renviron_path)
      }

      # Append the PAT to .Renviron
      write(paste0("GITHUB_PAT=", pat), renviron_path, append = TRUE)
      message("GITHUB_PAT has been saved to your .Renviron file.")

      # Reload .Renviron so the changes take effect
      readRenviron(renviron_path)
    } else {
      # Set the PAT for the current session only
      Sys.setenv(GITHUB_PAT = pat)
      message("GITHUB_PAT has been set for the current session.")
    }

    return(TRUE)
  } else {
    message("The provided token does not appear to be valid. Please try again.")
    return(FALSE)
  }
}


#' Download Proxima Nova fonts from the AAGI private repository
#'
#' This function downloads the Proxima Nova font files from the private AAGI repository and extracts them to the specified destination directory.
#'
#' @param font_repo The GitHub repository containing the font files
#' @param font_dir The directory within the repository containing the font files
#' @param dest_dir The destination directory to extract the font files
#' @param pat The GitHub Personal Access Token (PAT) to access the private repository
#'
#' @return TRUE if the fonts are downloaded and extracted successfully, FALSE otherwise
#'
#' @export
download_fonts <- function(font_repo = "jafernandez01/font-resources",
                           font_dir = "fonts/",
                           dest_dir = "./_extensions/aagi-report",
                           pat = Sys.getenv("GITHUB_PAT")) {
  # Check if the PAT is available; if not, prompt user to set it up
  if (!nzchar(pat)) {
    message("No GITHUB_PAT found. Please set up your GITHUB_PAT to access the private repository.\n")
    setup_successful <- setup_github_pat()
    if (!setup_successful) {
      stop("Failed to set up GITHUB_PAT. Cannot proceed with font download.")
    }
    # Reassign the PAT after setup
    pat <- Sys.getenv("GITHUB_PAT")
  }

  # Authenticate with GitHub using PAT and download the font files
  if (nzchar(pat)) {
    # If not installed, check if we have the font locally in the 'local_fonts/fonts/' directory
    local_font_path <- "_extensions/aagi-report/fonts/ProximaNova.sty"

    if (!file.exists(local_font_path)) {
      message("Downloading fonts from the private repository...")

      download_url <- paste0("https://", pat, "@github.com/", font_repo, "/tarball/master")
      # download_url <- paste0("https://", "github.com/", font_repo)
      dest_file <- tempfile(fileext = ".tar")

      # Download and extract files
      remotes:::download(url = download_url, path = dest_file, auth_token = pat, quiet = TRUE)

      # Create a temporary extraction directory to avoid unwanted folder levels
      temp_extract_dir <- tempfile()
      dir.create(temp_extract_dir)

      # Extract the tar file to the temporary directory
      utils::untar(dest_file, exdir = temp_extract_dir)

      # Find the extracted top-level directory
      extracted_dir <- list.dirs(temp_extract_dir, full.names = TRUE, recursive = FALSE)[1]

      # Check if the expected 'fonts' folder exists within the extracted directory
      fonts_path <- file.path(extracted_dir, font_dir)

      # Move 'fonts' directory to destination (dest_dir)
      file.rename(fonts_path, file.path(dest_dir, basename(fonts_path)))

      # Optionally, clean up temporary extraction directory
      unlink(temp_extract_dir, recursive = TRUE)

      if (dir.exists(file.path(dest_dir, basename(fonts_path)))) {

        message("Fonts downloaded and extracted successfully to: ", dest_dir)
        return(TRUE)
      } else {
        message("Failed to find the expected fonts directory in the extracted contents.")
        return(FALSE)
      }
    } else {
      message("Fonts already exist locally. Skipping download.")
      return(TRUE)
    }
  } else {
    stop("GitHub PAT not provided or invalid.")
  }
}
