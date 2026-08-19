# On top of rocker/ml's install.r (tidyverse, devtools, pak, arrow, V8, ...)
install.packages(c('quarto', 'IRkernel'))
IRkernel::installspec(user = FALSE, sys_prefix = TRUE)

## Spatial set. bspm/r2u resolves the system deps, so no apt-get here.
install.packages(c('sf', 'stars', 'gdalcubes', 'terra', 'tmap', 'mapgl'))
