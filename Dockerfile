FROM rocker/geospatial:3.6.3

ENV NB_USER rstudio
ENV NB_UID 1000
ENV HOME /home/${NB_USER}
ENV CONDA_DIR /opt/conda

# Set ENV for all programs...
ENV PATH ${CONDA_DIR}/bin:$PATH
# And set ENV for R! It doesn't read from the environment...
RUN echo "PATH=${PATH}" >> /usr/local/lib/R/etc/Renviron
RUN echo "export PATH=${PATH}" >> ${HOME}/.profile

# The `rsession` binary that is called by nbrsessionproxy to start R doesn't seem to start
# without this being explicitly set
ENV LD_LIBRARY_PATH /usr/local/lib/R/lib

WORKDIR ${HOME}

RUN mkdir -p ${CONDA_DIR} && \
    chown ${NB_USER}:${NB_USER} ${CONDA_DIR}

USER ${NB_USER}

RUN curl -sSL https://github.com/conda-forge/miniforge/releases/download/4.8.3-4/Miniforge3-4.8.3-4-Linux-x86_64.sh > /tmp/miniforge-installer.sh && \
    bash /tmp/miniforge-installer.sh -f -b -p ${CONDA_DIR} && \
    rm /tmp/miniforge-installer.sh


USER ${NB_USER}

RUN python3 -m venv ${CONDA_DIR} && \
    pip3 install --no-cache-dir \
         jupyter-rsession-proxy

RUN R --quiet -e "devtools::install_github('IRkernel/IRkernel')" && \
    R --quiet -e "IRkernel::installspec(prefix='${CONDA_DIR}')"

CMD jupyter notebook --ip 0.0.0.0


## If extending this image, remember to switch back to USER root to apt-get
