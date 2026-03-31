# Create a Standard Folder Structure for a Quarto Project

This function creates a standardized folder structure for a Quarto
project. The structure includes folders for data, code, figures,
documents, outputs, source files, and admin tasks.

## Usage

``` r
setup_folders(project_path = ".")
```

## Arguments

- project_path:

  Character. The root path of the Quarto project where the folders will
  be created.

## Details

- **data**: Contains the raw data files used in the project. These files
  should not be altered and are ideally read-only.

- **code**: Contains the scripts or code files used to run the project.

- **figs**: Contains plots, images, tables, or figures created and saved
  by your code. It should be possible to delete and regenerate this
  folder with the scripts in the project.

- **doc**: Contains any manuscripts or interim summaries produced during
  the project.

- **output**: Contains non-figure objects created by the scripts, such
  as processed data or logs.

- **src**: Contains any files you may want to
  [`source()`](https://rdrr.io/r/base/source.html) in your scripts, such
  as .R files containing helper functions.

- **admin**: Contains administrative files related to the project (e.g.,
  notes, project planning documents, and metadata).

## Note

Folder structure inspired by Kathryn Destasio's best practices for R
projects: https://kdestasio.github.io/post/r_best_practices/
