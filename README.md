[![stability-experimental](https://img.shields.io/badge/stability-experimental-orange.svg)](https://github.com/joethorley/stability-badges#experimental)

![](img/rocker.png) ![](img/binder-logo.png) 

# rocker/binder

Adds [binder](http://binder.org) abilities on top of the `rocker/tidyverse` images. 


## Deploy methods


### Using Docker


_This approach works on any machine on which you have Docker installed._

The `rocker/binder` images can be run like any other docker image:

```
docker -p 8888:8888 run rocker/binder
```

Note that binder will run JuyterHub on port `8888` by default.  The above
command will print to the terminal (and the docker container log) the URL
which includes a randomly generated token for secure login, so be sure to
include that in the URL you paste into the browser.


Once inside JupyterHub, RStudio Server should be an option under the menu
"New":

![](img/rstudio-session.jpg)

That should start you into an RStudio session (with no further login required).


### Using beta.mybinder.org services

_This approach uses the public binder cloud and requires no installation_


Add a Dockerfile with the following contents to the root of a GitHub
repository.  
 

```bash
FROM rocker/binder:3.4.2
```

Extend as necessary (see below).  Then go to <beta.mybinder.org> and enter the
`https` address of your repository to launch your instance on the public Binder
infrastructure.


##### Details


The `3.4.2` indicates the version of R requested. Use a specific version to ensure a consistent build environment or use `latest`
to get the latest avialable version of R and R packages.     

No additional lines are needed unless you want to install further libraries. In
that case, you will need to first switch to root user to run `apt-get`, and then
switch back to `$NB_USER` (`rstudio`) to keep JupterHub startup happy.
For instance:

```bash
FROM rocker/binder:3.4.2

USER root
RUN apt-get update && apt-get -y install libv8-dev


USER ${NB_USER}
```


## Credits

https://twitter.com/twitter/statuses/921165684188393472

