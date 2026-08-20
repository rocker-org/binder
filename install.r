# On top of rocker/ml-spatial's install.r (tidyverse, devtools, pak, arrow, V8,
# languageserver, httpgd, duckdbfs, shiny, ...) and its extend/install.r
# (sf, stars, terra, gdalcubes, rstac, mapgl, geoarrow, gifski).
install.packages(c('quarto', 'tmap'))

install.packages("IRkernel")
IRkernel::installspec(user = FALSE, sys_prefix = TRUE)
