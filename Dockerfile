FROM rocker/binder:latest

## Declares build arguments
ARG NB_USER
ARG NB_UID

COPY --chown=${NB_USER} . ${HOME}

## Run an install.R script, if it exists.
RUN if [ -f install.R ]; then R --quiet -f install.R; fi

USER root
RUN pip install --upgrade jupyter-rsession-proxy>=2.0 notebook jupyterlab
USER ${NB_USER}