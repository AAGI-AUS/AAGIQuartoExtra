# Create new Quarto document from template

Create a new AAGI Quarto document. If the extension is not already
installed, it will be copied over to the `_extensions` folder in the
current working directory. This function extends a function written by
Thomas Mock:
https://github.com/jthomasmock/octavo/blob/master/R/use_quarto_ext.R and
by Spencer Schien:
https://spencerschien.info/post/r_for_nonprofits/quarto_template/

## Usage

``` r
new_aagi_document(
  file_name = NULL,
  ext_name = "aagi-report",
  university = "UQ",
  update = FALSE
)
```

## Arguments

- file_name:

  Name of new qmd file and sub-directory to be created

- ext_name:

  String indicating which extension to install

- university:

  String indicating which university partner to use

- update:

  Logical indicating whether to update the extension if it already
  exists
