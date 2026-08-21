# Vendored `start.sh` from jupyter/docker-stacks

These three files are copied verbatim from
[`jupyter/docker-stacks`](https://github.com/jupyter/docker-stacks), directory
`images/docker-stacks-foundation/`, pinned at the commit in `UPSTREAM_COMMIT`.
They are distributed under the Modified BSD License (see the header in each
file); Copyright (c) Jupyter Development Team.

## Why they are here

`rocker/binder` used to inherit `start.sh` by deriving from
`jupyter/minimal-notebook`. Now that it builds on `rocker/ml-spatial`, that
entrypoint is gone, and with it **runtime `NB_UID`/`NB_GID` remapping** --
`docker run --user root -e NB_UID=1234` would leave the notebook server running
as root rather than dropping to the remapped user.

BinderHub itself does not need this (it runs the image as its built-in
`jovyan`/1000 and sets no `NB_UID`), but JupyterHub and plain-`docker run`
deployments do, and it is a documented part of the Jupyter image contract:
`NB_UID`, `NB_GID`, `NB_USER`, `CHOWN_HOME`, `CHOWN_EXTRA`, `NB_UMASK`,
`GRANT_SUDO`, `JUPYTER_ENV_VARS_TO_UNSET`.

They are vendored rather than reimplemented so that the documented behaviour of
those variables matches upstream exactly instead of drifting from a local
approximation.

## Composition with tini

`rocker/ml-spatial` sets `ENTRYPOINT ["tini", "-g", "--"]`. This image extends
it to `ENTRYPOINT ["tini", "-g", "--", "start.sh"]`, which is precisely what
`jupyter/minimal-notebook` did, so tini remains PID 1 and reaps zombies while
`start.sh` handles the user remapping before exec'ing the command.

## Updating

Re-copy all three files from the same upstream directory and update
`UPSTREAM_COMMIT`. Do not edit them locally -- keeping them verbatim is the
point.
