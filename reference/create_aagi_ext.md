# Create new AAGI Quarto project from template

Install bundled Quarto extensions into current working directory and
create new qmd using skeleton documents. This function extends a
function written by Thomas Mock:
https://github.com/jthomasmock/octavo/blob/master/R/use_quarto_ext.R and
by Spencer Schien:
https://spencerschien.info/post/r_for_nonprofits/quarto_template/. This
is equivalent to the quarto command `quarto use` with a `--template`
flag.

## Usage

``` r
create_aagi_ext(
  file_name = NULL,
  ext_name = "aagi-report",
  university = "AU",
  path = "."
)
```

## Arguments

- file_name:

  Name of new qmd file and sub-directory to be created

- ext_name:

  String indicating which extension to install

- university:

  String indicating which university partner to use

- path:

  Path to save new qmd file

## Value

a message if extension was successfully copied over
