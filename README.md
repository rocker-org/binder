# Template for RStudio on Binder / JupyterHub

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/rocker-org/binder/HEAD?urlpath=rstudio)

Generate a Git repository that can run R code with RStudio on
the browser via [mybinder.org](https://mybinder.org) or any JupyterHub
from this template repository!

## How to use this repo

### 1. Add a Dockerfile to your repo with contents like so:

```
FROM rocker/binder

COPY install.r install.r
RUN Rscript install.r
```

### 2. Install any packages you want

You can create an `install.r` file that will be executed on build.
Use `install.packages()` to install:

```R
install.packages("ggplot2")
```

Binary versions of packages will be quickly installed from [r2u](https://github.com/eddelbuettel/r2u) via [bspm](https://cloud.r-project.org/web/packages/bspm/index.html).  _There is no need to manually manage 'system' dependencies with apt-get, these are handled automatically in the Docker build phase_. 

Commonly used packages in the `tidyverse` and `geospatial` collection are already installed, see [`install.r`](install.r)

### 3. Modify the Binder Badge in the README.md

The 'Launch on Binder' badge in this README points to the template repository.
You should modify it to point to your own repository. Keep the `urlpath=rstudio`
parameter intact - that is what makes sure your repo will launch directly into
RStudio

