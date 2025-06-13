nicolaus
================

Provides access to, and download from, [Copernicus Marine Data Store’s
catalog](https://marine.copernicus.eu/) using R language.

# Copernicus resources

Copernicus serves **so many** data resources; finding what you want can
be a challenge. Check out the new [Marine Data
Store](https://marine.copernicus.eu/news/introducing-new-copernicus-marine-data-store).
And checkout the listing
[here](https://marine.copernicus.eu/about/producers).

## Data catalogs

Like data offerings from [OBPG](https://oceancolor.gsfc.nasa.gov/),
Copernicus strives to provided consistent dataset identifiers that are
easily decoded programmatically (and with practice by eye). In order to
download programmatically you must have the `product_id` and or
`dataset_id` in hand. Learn more about Copernicus [nomenclature rules
here](https://help.marine.copernicus.eu/en/articles/6820094-how-is-defined-the-nomenclature-of-copernicus-marine-data#h_34a5a6f21d).

## `get` or `subset`

The [Copernicus Marine
Toolbox](https://help.marine.copernicus.eu/en/collections/4060068-copernicus-marine-toolbox)
command-line application, `copernicus-marine` provides two primary
methods for donwloading data: `get` and `subset`. `get` is not well
documented, but subset does what it implies - subsetting resources by
variable, spatial bounding box, depth and time. This package only
supports `subset`.

## Requirements

- [R v4.1+](https://www.r-project.org/)

### From CRAN

- [rlang](https://CRAN.R-project.org/package=rlang)
- [dplyr](https://CRAN.R-project.org/package=dplyr)
- [readr](https://CRAN.R-project.org/package=readr)
- [jsonlite](https://CRAN.R-project.org/package=jsonlite)

### From github

- [copernicus](https://github.com/BigelowLab/copernicus)

## Installation

    remotes::install_github("BigelowLab/nicolaus")

## Configuration

If you have already installed and configured the [copernicus R
package](https://github.com/BigelowLab/copernicus) then you are all set
to use this package. If you have not installed and configured the
[copernicus R package](https://github.com/BigelowLab/copernicus) then
please do that first.

## Fetch the products catalog

You can download a product catalog for local storage.

``` r
suppressPackageStartupMessages({
  library(nicolaus)
  library(dplyr)
})

ok = fetch_catalog()
ok
```

    ## [1] 0

## Import the products catalog

This downloads into a “catalogs” directory within your
[copernicus](https://github.com/BigelowLab/copernicus) data directory
Now read it in.

``` r
x = import_catalog()
dplyr::glimpse(x)
```

    ## Rows: 6,594
    ## Columns: 11
    ## $ product_id    <chr> "ARCTIC_ANALYSISFORECAST_BGC_002_004", "ARCTIC_ANALYSISF…
    ## $ dataset_id    <chr> "cmems_mod_arc_bgc_anfc_ecosmo_P1D-m", "cmems_mod_arc_bg…
    ## $ short_name    <chr> "chl", "dissic", "expc", "kd", "model_depth", "no3", "np…
    ## $ standard_name <chr> "mass_concentration_of_chlorophyll_a_in_sea_water", "mol…
    ## $ units         <chr> "mg m-3", "mole m-3", "mol m-2 d-1", "m-1", "meter", "mm…
    ## $ start_time    <dttm> 2019-03-22, 2019-03-22, 2019-03-22, 2019-03-22, NA, 201…
    ## $ end_time      <dttm> 2025-06-21, 2025-06-21, 2025-06-21, 2025-06-21, NA, 202…
    ## $ time_step     <dbl> 86400, 86400, 86400, 86400, NA, 86400, 86400, 86400, 864…
    ## $ min_depth     <dbl> 0, 0, 0, 0, NA, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, N…
    ## $ max_depth     <dbl> 4000, 4000, 4000, 4000, NA, 4000, 4000, 4000, 4000, 4000…
    ## $ n_depth       <dbl> 40, 40, 40, 40, NA, 40, 40, 40, 40, 40, 40, 40, 40, 40, …

By default this provides a flattened table of available products and
their datasets along with each dataset’s variables. There is a lot of
information in the JSON catalog that we place in the table including:

- depth min, max and depth layer count

- time min, max and step size

- short and standard name as well as unit for each variable

## Tally the catalog

``` r
dplyr::count(x, product_id, dataset_id)
```

    ## # A tibble: 899 × 3
    ##    product_id                              dataset_id                          n
    ##    <chr>                                   <chr>                           <int>
    ##  1 ARCTIC_ANALYSISFORECAST_BGC_002_004     cmems_mod_arc_bgc_anfc_ecosmo_…    14
    ##  2 ARCTIC_ANALYSISFORECAST_BGC_002_004     cmems_mod_arc_bgc_anfc_ecosmo_…    14
    ##  3 ARCTIC_ANALYSISFORECAST_PHY_002_001     cmems_mod_arc_phy_anfc_6km_det…    18
    ##  4 ARCTIC_ANALYSISFORECAST_PHY_002_001     cmems_mod_arc_phy_anfc_6km_det…    18
    ##  5 ARCTIC_ANALYSISFORECAST_PHY_002_001     cmems_mod_arc_phy_anfc_6km_det…    11
    ##  6 ARCTIC_ANALYSISFORECAST_PHY_002_001     cmems_mod_arc_phy_anfc_6km_det…    18
    ##  7 ARCTIC_ANALYSISFORECAST_PHY_ICE_002_011 cmems_mod_arc_phy_anfc_nextsim…    10
    ##  8 ARCTIC_ANALYSISFORECAST_PHY_ICE_002_011 cmems_mod_arc_phy_anfc_nextsim…    10
    ##  9 ARCTIC_ANALYSIS_FORECAST_WAV_002_014    dataset-wam-arctic-1hr3km-be       24
    ## 10 ARCTIC_MULTIYEAR_BGC_002_005            cmems_mod_arc_bgc_my_ecosmo_P1…    10
    ## # ℹ 889 more rows

## Save the products catalog as a table

It doesn’t take a long time to parse the JSON list into a table, but it
is worth the effort to save the table as a flat structure for later use.

``` r
x = write_catalog(x)
y = read_catalog()
identical(x,y)
```

    ## [1] TRUE
