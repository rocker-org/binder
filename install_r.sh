#!/bin/bash

# determine Ubuntu release
source /etc/os-release

## First: update apt and get keys
apt-get update -qq && apt-get install --yes --no-install-recommends wget ca-certificates gnupg
wget -q -O- https://eddelbuettel.github.io/r2u/assets/dirk_eddelbuettel_key.asc \
    | tee -a /etc/apt/trusted.gpg.d/cranapt_key.asc

## Second: add the repo -- here we use the well-connected mirror
echo "deb [arch=amd64] https://r2u.stat.illinois.edu/ubuntu ${UBUNTU_CODENAME} main" > /etc/apt/sources.list.d/cranapt.list
apt-get update

## Third: ensure current R is used
wget -q -O- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc \
    | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
echo "deb [arch=amd64] https://cloud.r-project.org/bin/linux/ubuntu ${UBUNTU_CODENAME}-cran40/" > /etc/apt/sources.list.d/cran_r.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 67C2D66C4B1D4339 51716619E084DAB9
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends r-base r-base-dev r-recommended

## Fourth: add pinning to ensure package sorting
echo "Package: *" > /etc/apt/preferences.d/99cranapt
echo "Pin: release o=CRAN-Apt Project" >> /etc/apt/preferences.d/99cranapt
echo "Pin: release l=CRAN-Apt Packages" >> /etc/apt/preferences.d/99cranapt
echo "Pin-Priority: 700"  >> /etc/apt/preferences.d/99cranapt

chown root:users ${R_HOME}/site-library
chmod g+ws ${R_HOME}/site-library

ln -s /usr/lib/R/site-library/littler/examples/install2.r /usr/local/bin/install2.r

## add user to sudoers -- not jupyterhub compatible
# usermod -a -G staff ${NB_USER}
# echo "${NB_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers


