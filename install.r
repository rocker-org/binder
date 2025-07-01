# tidyverse/dev set
install.packages(c(
'archive',
'languageserver',
'httpgd',
'quarto',
'tidyverse',
'devtools',
'pak',
'shiny',
'duckdbfs',
'arrow',
'V8'))

install.packages("IRkernel")
IRkernel::installspec(user = FALSE, sys_prefix=TRUE)

## Spatial set
install.packages(c('sf', 'stars', 'gdalcubes', 'terra', 'tmap', 'mapgl'))

