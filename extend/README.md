# Candidate: rocker/binder as a derivative of rocker/ml

See rocker-org/binder#61. This is a *proposal*, not yet the published image --
the root `Dockerfile` is still what CI builds.

`rocker/ml` already supplies Ubuntu 24.04, R 4.6.1 + RStudio Server (r2u/bspm),
code-server, quarto, the `/opt/venv` Python stack, `tini` as PID 1, and jovyan
with passwordless sudo. Everything in here is the Binder-specific delta:

- `install.r` -- IRkernel (+ `installspec`), quarto, and the spatial set
- `requirements.txt` -- mystmd, jupyterlab-myst, and `notebook`
- `vscode-extensions.txt` -- the two extensions ml does not ship

Build and test locally:

    docker build -f extend/Dockerfile -t binder-ml-test extend
    docker run --rm -p 8888:8888 binder-ml-test
