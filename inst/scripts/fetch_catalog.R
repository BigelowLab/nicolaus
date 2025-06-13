suppressPackageStartupMessages({
  library(nicolaus)
  library(charlier)
})

charlier::start_logger(filename = nicolaus::nicolaus_path("catalogs", "log"))

ok = nicolaus::fetch_catalog()

if (ok == 0){
  x = nicolaus::import_catalog() |>
    write_catalog()
  charlier::info("catalog updated successfully")
} else {
  charlier::error("catalog not updated")
}

quit(save = "no", status = ok)
