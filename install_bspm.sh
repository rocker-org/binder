## Fifth: install bspm (and its Python requirements) and enable it
## If needed (in bare container, say) install python tools for bspm and R itself
apt-get install --yes --no-install-recommends python3-{dbus,gi,apt} \
	make sudo r-cran-{docopt,littler,remotes} 
## Then install bspm (as root) and enable it, and enable a speed optimization
Rscript -e 'install.packages("bspm")'

R_HOME=$(R RHOME)
# must go first.  Only configure for ROOT user
## done in Rprofile conditionally
#echo "options(bspm.sudo = TRUE)" >> .Rprofile
#echo "options(bspm.version.check=FALSE)" >> .Rprofile
#echo "suppressMessages(bspm::enable())" >> .Rprofile

chown root:users ${R_HOME}/site-library
chmod g+ws ${R_HOME}/site-library


