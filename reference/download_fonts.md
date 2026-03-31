# Download Proxima Nova fonts from the AAGI private repository

This function downloads the Proxima Nova font files from the private
AAGI repository and extracts them to the specified destination
directory.

## Usage

``` r
download_fonts(
  font_repo = "jafernandez01/font-resources",
  font_dir = "fonts/",
  dest_dir = "./_extensions/aagi-report",
  pat = Sys.getenv("GITHUB_PAT")
)
```

## Arguments

- font_repo:

  The GitHub repository containing the font files

- font_dir:

  The directory within the repository containing the font files

- dest_dir:

  The destination directory to extract the font files

- pat:

  The GitHub Personal Access Token (PAT) to access the private
  repository

## Value

TRUE if the fonts are downloaded and extracted successfully, FALSE
otherwise
