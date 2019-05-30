<!-- badges: start -->
[![stability-experimental](https://img.shields.io/badge/stability-experimental-orange.svg)](https://github.com/joethorley/stability-badges#experimental)
[![Build Status](https://travis-ci.org/rocker-org/binder.svg?branch=master)](https://travis-ci.org/rocker-org/binder)
[![](https://img.shields.io/docker/pulls/rocker/binder.svg)](https://hub.docker.com/r/rocker/binder) [![](https://img.shields.io/docker/automated/rocker/binder.svg)](https://hub.docker.com/r/rocker/binder/builds)
<!-- [![](https://images.microbadger.com/badges/image/rocker/binder.svg)](https://microbadger.com/images/rocker/binder) --> 
[![Launch binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/rocker-org/binder/master?urlpath=rstudio)
<!-- badges: end -->



![](img/rocker.png) ![](img/binder.png) 

# rocker/binder

Adds [binder](http://mybinder.org/) abilities on top of the [`rocker/geospatial`](https://hub.docker.com/r/rocker/geospatial) images. 


# Deploy methods


## Using mybinder.org services

_This approach uses the public binder cloud and requires no installation_

Add the following components to your repository:

1. A `Dockerfile`
1. Optionally, a badge to the `README.md`


### `Dockerfile`

Add a file named `Dockerfile` with the following contents to the root of a GitHub
repository: 
 

```bash
FROM rocker/binder:3.4.3

## Copies your repo files into the Docker Container
USER root
COPY . ${HOME}
RUN chown -R ${NB_USER} ${HOME}

## Become normal user again
USER ${NB_USER}

## Run an install.R script, if it exists.
RUN if [ -f install.R ]; then R --quiet -f install.R; fi
```

If you add an `install.R` file to the root directory of your GitHub repo as well, any R commands in that file will automatically be run as well.  This should make it easier for users to install additional R packages from CRAN, GitHub etc by just writing R code to do so.  

*Note* You can extend this Dockerfile if necessary to include additional system dependencies; see [Troubleshooting](#troubleshooting) below.

### Badge

To launch on https://mybinder.org, go to that address and enter the
`https` address of your GitHub repository.  You can also create a shiny badge for your `README.md` by adding the following markdown text:

```
[![Binder](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/<GITHUB_USER>/<REPO>/<BRANCH>?urlpath=rstudio)
```

filling in `<GITHUB_USER>`, `<REPO>` and `<BRANCH>` as appropriate.  Here is an example badge to launch the `binder-examples/dockerfile-rstudio` repo.  

[![Binder](http://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/rocker-org/binder/master?urlpath=rstudio)


See the [binder/](/binder)  subdirectory for a minimal example.  Note: you can always put your `Dockerfile` in `binder/Dockerfile` if you don't want to put it in the root directory.  


## Running on your own machines, Using Docker


_This approach works on any machine on which you have Docker installed._

The `rocker/binder` images can be run like any other docker image:

```
docker run -p 8888:8888 rocker/binder
```

Note that binder will run Juyter Notebook on port `8888` by default.  The above
command will print to the terminal (and the docker container log) the URL
which includes a randomly generated token for secure login, so be sure to
include that in the URL you paste into the browser.

## Opening RStudio once Binder Launches

:sparkles: **NEW** :sparkles:: By including `?urlpath=rstudio` on the binder urls in the examples above, Binder should automatically open in an RStudio instance, rather than a Jupyter notebook.  Otherwise, see the documentation below for navigating to an RStudio instance from Jupyter:

**Old method**:  Once inside Jupyter Notebook, RStudio Server should be an option under the menu
"New":

![](img/rstudio-session.jpg)

That should start you into an RStudio session (with no further login required).


## Troubleshooting

**It didn't work! What do I do now?**.  If you are installing additional R packages, this will sometimes fail when a package requires an external library that is not found on the container.  We're working on a more elegant solution for this case, but meanwhile, you'll need to modify the Dockerfile to install these libraries.  For instance, the `gsl` [R package page reads](https://cran.r-project.org/web/packages/gsl/)


```
SystemRequirements:	Gnu Scientific Library version >= 1.12
```

To solve this, you will need to add the following line to your Dockerfile, right after the line that says `USER root`:

```
RUN apt-get update && apt-get -y install libgsl-dev
```

Or, just get in touch by opening an issue. We'll try and resolve common cases so more things work out of the box.  


## Credits

* [Ryan Lovett](http://github.com/ryanlovett) for writing the core part of this,
  [nbrsessionproxy](http://github.com/jupyterhub/nbrsessionproxy).
* [Taylor Reiter](https://github.com/taylorreiter) for testing & shaping this.
* [Yuvi Panda](https://github.com/yuvipanda) & [Aaron Culich](http://github.com/aculich) for bringing it together on Binder.
* [Chris Holdgraf](http://github.com/choldgraf/) for this [nice GIF](https://twitter.com/choldgraf/status/921165684188393472)
* [Tim Head](https://github.com/betatim) for this [nice GIF](https://twitter.com/betatim/status/921156659166277634)

