ARG BASE=rocker/ml
FROM $BASE

# rocker/ml already provides: Ubuntu 24.04, R + RStudio Server (r2u/bspm),
# code-server, quarto, the /opt/venv Python stack (jupyterlab, jupyterhub,
# rsession/vscode proxies), tini as PID 1, and jovyan with passwordless sudo.
# Everything below is what a Binder image needs on top of that.

USER ${NB_USER}

# MyST -- not part of rocker/ml
COPY --chown=${NB_USER}:${NB_USER} requirements.txt /tmp/requirements.txt
RUN uv pip install --no-cache-dir -r /tmp/requirements.txt && rm /tmp/requirements.txt

COPY --chown=${NB_USER}:${NB_USER} vscode-extensions.txt /tmp/vscode-extensions.txt
RUN xargs -n 1 code-server --extensions-dir ${CODE_EXTENSIONSDIR} --install-extension \
      < /tmp/vscode-extensions.txt && rm /tmp/vscode-extensions.txt

# IRkernel (the R Jupyter kernel, absent from rocker/ml) and the spatial set.
# bspm resolves the system deps via r2u, so no manual apt-get here.
COPY --chown=${NB_USER}:${NB_USER} install.r /tmp/install.r
RUN Rscript /tmp/install.r && rm /tmp/install.r
