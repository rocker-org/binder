ARG BASE=quay.io/jupyter/minimal-notebook:ubuntu-24.04
FROM $BASE

# Make code-server extensions etc persist to container, not hub
ENV XDG_DATA_HOME=/opt/share
## Add rstudio's binaries to path for quarto
ENV PATH=$PATH:/usr/lib/rstudio-server/bin/quarto/bin

USER root
# code-server (VSCode)
RUN curl -fsSL https://code-server.dev/install.sh | sh && rm -rf .cache 

# apt utilities, code-server setup
RUN curl -s https://raw.githubusercontent.com/rocker-org/ml/refs/heads/master/install_utilities.sh | bash

## Grant user sudoer privileges
RUN adduser "$NB_USER" sudo && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers

# Install R, RStudio
RUN curl -s https://raw.githubusercontent.com/rocker-org/ml/refs/heads/master/install_r.sh | bash
RUN curl -s https://raw.githubusercontent.com/rocker-org/ml/refs/heads/master/install_rstudio.sh | bash

USER ${NB_USER}

COPY vscode-extensions.txt /tmp/vscode-extensions.txt
RUN xargs -n 1 code-server --install-extension < /tmp/vscode-extensions.txt

COPY environment.yml /tmp/environment.yml
RUN conda update --all --solver=classic -n base -c conda-forge conda && \
    conda env update --file /tmp/environment.yml

# When run at build-time, install.r automagically handles any necessary apt-gets
COPY install.r /tmp/install.r
RUN Rscript /tmp/install.r

