# Install or Update AAGI Quarto Extension

This function installs a specified AAGI Quarto extension into the
current working directory or updates an existing installation to the
version included in the package. The extension will be installed to the
'\_extensions' folder in the current directory.

## Usage

``` r
install_aagi_ext(ext_name = "aagi-report", force = FALSE)
```

## Arguments

- ext_name:

  String indicating which extension to install. Must be one of
  "aagi-report" or "aagi-short-report".

- force:

  Logical indicating whether to force installation even if the extension
  already exists. Default is FALSE, which will prompt the user when an
  existing extension is found.

## Value

Invisibly returns TRUE if the extension was installed or updated, FALSE
otherwise.

## Examples

``` r
if (FALSE) { # \dontrun{
# Install the AAGI report extension
install_aagi_ext("aagi-report")

# Force update the AAGI short report extension
install_aagi_ext("aagi-short-report", force = TRUE)
} # }
```
