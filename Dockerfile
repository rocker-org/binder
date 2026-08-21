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

# Restore jupyter/docker-stacks' start.sh, lost when this image stopped deriving
# from jupyter/minimal-notebook. It is what implements runtime NB_UID/NB_GID
# remapping (plus CHOWN_HOME, NB_UMASK, GRANT_SUDO and friends); without it,
# `docker run --user root -e NB_UID=1234` leaves the server running as root.
# Vendored verbatim and pinned -- see start-hooks/README.md.
# start.sh needs NB_GID declared (rocker/ml sets only NB_UID) or it expands empty
# and groupadd fails. It must be a SHARED group, not jovyan's user-private one:
# start.sh remaps via `userdel` + `useradd`, and userdel removes a private group
# along with the user, after which `useradd --gid` fails on the now-missing group.
# 100 (users) is what docker-stacks and the old minimal-notebook base used, and
# jovyan is already a member.
ENV NB_GID=100

USER root

# Make NB_GID=100 true rather than aspirational. rocker/ml gives jovyan a
# user-private group (gid 1000), so with NB_GID=100 declared above, start.sh's
# non-root path finds a mismatch it cannot fix without root and warns on every
# single container start:
#
#   WARNING container must be started as root to change the desired user's
#           group id with NB_GID="100"!
#
# Putting jovyan in users(100) -- which is what docker-stacks and the old
# minimal-notebook base did, and which jovyan is already a supplementary member
# of -- makes the declared and actual gid agree, so the warning goes away.
# Files built as jovyan:jovyan keep group 1000, but jovyan still owns them by
# uid, so access is unaffected.
RUN usermod -g users ${NB_USER}
COPY start-hooks/start.sh start-hooks/_docker_stacks_log.sh start-hooks/run-hooks.sh /usr/local/bin/
# See the file's own header: Ubuntu 26.04's sudo-rs ignores --preserve-env, which
# start.sh depends on to carry the environment across its root -> NB_USER drop.
COPY start-hooks/sudoers-zz-jupyter-env /etc/sudoers.d/zz-jupyter-env
RUN chmod +x /usr/local/bin/start.sh /usr/local/bin/_docker_stacks_log.sh /usr/local/bin/run-hooks.sh && \
    chmod 0440 /etc/sudoers.d/zz-jupyter-env && visudo -c -f /etc/sudoers.d/zz-jupyter-env && \
    mkdir -p /usr/local/bin/start-notebook.d /usr/local/bin/before-notebook.d
USER ${NB_USER}

# tini stays PID 1 (so zombies are still reaped) and start.sh runs inside it,
# exactly as jupyter/minimal-notebook composed the two.
ENTRYPOINT ["tini", "-g", "--", "start.sh"]
