FROM rocker/geospatial:latest
ENV NB_USER rstudio
ENV NB_UID 1000
ENV HOME /home/${NB_USER}

RUN apt-get update && \
    apt-get -y install python3-pip && \
    pip3 install --no-cache-dir \
         notebook==5.2 \
         git+https://github.com/jupyterhub/nbrsessionproxy.git@6eefeac11cbe82432d026f41a3341525a22d6a0b \
         git+https://github.com/jupyterhub/nbserverproxy.git@5508a182b2144d29824652d8977b32302517c8bc && \
    apt-get purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    R --quiet -e "devtools::install_github('IRkernel/IRkernel')"

COPY . ${HOME}
RUN chown -R ${NB_UID} ${HOME}
RUN if [ -f install.R ]; then R --quiet -f install.R; fi

## These commands must be run in $HOME by $NB_USER, with $NB_UID already set
## note: for some reason, just doing in a root run command with su ${NB_USER}
USER ${NB_USER}
WORKDIR ${HOME} 

## Magic to allow JupyterHub to manage arbitrary sessions, including RStudio
RUN  R --quiet -e "IRkernel::installspec()" && \
    jupyter serverextension enable --user --py nbserverproxy && \
    jupyter serverextension enable --user --py nbrsessionproxy && \
    jupyter nbextension install    --user --py nbrsessionproxy && \
    jupyter nbextension enable     --user --py nbrsessionproxy

## Is IRkernel not getting R_LIBS from .Renviron?
ENV LD_LIBRARY_PATH /usr/local/lib/R/lib


CMD jupyter notebook --ip 0.0.0.0


## If extending this image, remember to switch back to USER root to apt-get

