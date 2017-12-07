[![stability-experimental](https://img.shields.io/badge/stability-experimental-orange.svg)](https://github.com/joethorley/stability-badges#experimental)
[![Build Status](https://travis-ci.org/rocker-org/binder.svg?branch=master)](https://travis-ci.org/rocker-org/binder)
[![](https://img.shields.io/docker/pulls/rocker/binder.svg)](https://hub.docker.com/r/rocker/binder) [![](https://img.shields.io/docker/automated/rocker/binder.svg)](https://hub.docker.com/r/rocker/binder/builds)
<!-- [![](https://images.microbadger.com/badges/image/rocker/binder.svg)](https://microbadger.com/images/rocker/binder) --> 



![](img/rocker.png) ![](img/binder.png) 

# rocker/binder

Adds [binder](http://mybinder.org/) abilities on top of the `rocker/tidyverse` images. 


# Deploy methods


## Using beta.mybinder.org services

_This approach uses the public binder cloud and requires no installation_


Just add a file named `Dockerfile` with the following contents to the root of a GitHub
repository: 
 

```bash
FROM rocker/binder:3.4.2

## Copies your repo files into the Docker Container
COPY . ${HOME}
RUN chown -R ${NB_USER} ${HOME}

## Become normal user again
USER ${NB_USER}

## Run an install.R script, if it exists.
RUN if [ -f install.R ]; then R --quiet -f install.R; fi

```

If you add an `install.R` file to the root directory of your GitHub repo as well, any R commands in that file will automatically be run as well.  This should make it easier for users to install additional R packages from CRAN, GitHub etc by just writing R code to do so.  

You can extend this Dockerfile if necessary to include additional system dependencies.

To launch on https://beta.mybinder.org, go to that address and enter the
`https` address of your GitHub repository.  You can also create a shiny badge for your `README.md` by adding the following markdown text:

```
[![Binder](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/<GITHUB_USER>/<REPO>/<BRANCH>)
```

filling in `<GITHUB_USER>`, `<REPO>` and `<BRANCH>` as appropriate.  Here is an example badge to launch the `binder-examples/dockerfile-rstudio` repo.  

[![Binder](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/binder-examples/dockerfile-rstudio/master)


See https://github.com/binder-examples/dockerfile-rstudio for a minimal example.


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

Once inside Jupyter Notebook, RStudio Server should be an option under the menu
"New":

![](img/rstudio-session.jpg)

That should start you into an RStudio session (with no further login required).






## Credits

* [Ryan Lovett](http://github.com/ryanlovett) for writing the core part of this,
  [nbrsessionproxy](http://github.com/jupyterhub/nbrsessionproxy).
* [Taylor Reiter](https://github.com/taylorreiter) for testing & shaping this.
* [Yuvi Panda](https://github.com/yuvipanda) & [Aaron Culich](http://github.com/aculich) for bringing it together on Binder.
* [Chris Holdgraf](http://github.com/choldgraf/) for this [nice GIF](https://twitter.com/choldgraf/status/921165684188393472)
* [Tim Head](https://github.com/betatim) for this [nice GIF](https://twitter.com/betatim/status/921156659166277634)

