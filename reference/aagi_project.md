# Create a new AAGI project

Create a new AAGI project with the following structure:

## Usage

``` r
aagi_project(path, ...)
```

## Arguments

- path:

  Path to save the new project

- ...:

  Additional arguments

## Value

A new AAGI project

## Details

- A new directory with the name of the project

- A `_quarto.yml` file with the title of the project

- A `index.qmd` file with the title of the project

- A `references.bib` file

- A `pyenv` directory if `python_venv` is `TRUE`

- A `renv` directory if `with_renv` is `TRUE`
