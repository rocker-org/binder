ARG BASE=rocker/ml-spatial:latest
FROM $BASE

# rocker/ml-spatial already provides: Ubuntu 26.04, R + RStudio Server (r2u/bspm),
# code-server, quarto's binaries, the /opt/venv Python stack (jupyterlab,
# jupyterhub, rsession/vscode proxies, torch, the geospatial set), tini as PID 1,
# and jovyan with passwordless sudo. It also provides the system GDAL with the
# Arrow/Parquet driver plugins, which every R and Python binding here links.
#
# Everything below is only what a Binder image needs on top of that.

USER root

# mystmd's PyPI distribution is a thin Python wrapper around a Node binary and
# bundles no Node of its own -- conda-forge's `mystmd` did, which is why this was
# invisible while binder was conda-based. Without a Node on PATH, `myst` prompts
# to download one into $HOME on first run: it fails non-interactively (EOFError)
# and would land inside JupyterHub's mounted volume even if it succeeded.
# Ubuntu 26.04 ships Node 22, comfortably above mystmd's floor.
#
# NOTE: deliberately NOT deleting /var/lib/apt/lists here. bspm shells out to apt
# to install the r-cran-* binaries in install.r below, and with the lists emptied
# it silently falls back to compiling every R package from source.
RUN apt-get update && apt-get install -y --no-install-recommends nodejs

USER ${NB_USER}

# MyST, plus `notebook`: repo2docker/BinderHub expect a `jupyter-notebook`
# entrypoint on PATH, and rocker/ml-spatial ships jupyterlab only, which does
# not provide one.
COPY --chown=${NB_USER}:${NB_USER} requirements.txt /tmp/requirements.txt
RUN uv pip install --no-cache-dir -r /tmp/requirements.txt && rm /tmp/requirements.txt

COPY --chown=${NB_USER}:${NB_USER} vscode-extensions.txt /tmp/vscode-extensions.txt
RUN xargs -n 1 code-server --extensions-dir ${CODE_EXTENSIONSDIR} --install-extension \
      < /tmp/vscode-extensions.txt && rm /tmp/vscode-extensions.txt

# IRkernel (the R Jupyter kernel) and the two R packages the spatial base does
# not carry. bspm/r2u resolves the system deps, so no apt-get here.
COPY --chown=${NB_USER}:${NB_USER} install.r /tmp/install.r
RUN Rscript /tmp/install.r && rm /tmp/install.r
