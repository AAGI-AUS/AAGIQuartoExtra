# Rename the index.qmd File and Update \_quarto.yml for a Quarto Project

This function renames the `index.qmd` file to a new name based on the
project name and output type. It also updates the `_quarto.yml` file to
specify the output type and directory for the project. This function
should be run in the root directory of a Quarto project and after the
[`setup_folders()`](https://aagi-aus.github.io/AAGIQuartoExtra/reference/setup_folders.md)
function.

## Usage

``` r
setup_docs(output_type = "Report")
```

## Arguments

- output_type:

  Character. The type of output to be generated (e.g., "Report",
  "Slides", "Manuscript").

## Details

The function extracts the project name from the directory name and uses
it to rename the `index.qmd` file. The new file name format is
`01_projectname_outputtype.qmd`. The `_quarto.yml` file is updated with
the output type and directory for the project.
