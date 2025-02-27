# Based on Jeroen's config: 
# https://github.com/r-universe-org/base-image/blob/f20ec9fc6f51ef8a89aad489206a43790bd9bf77/Rprofile



local({

  use_bspm <- function() {
    has_sudo <- 0 == system2("sudo", "-n true", stderr = FALSE, stdout = FALSE)
    has_sudo && require('bspm', quietly = TRUE)
  }

# Only use Runiverse if we don't have sudo
  if (!use_bspm()) {

    rver <- getRversion()
    distro <- system2('lsb_release', '-sc', stdout = TRUE)
    options(HTTPUserAgent = sprintf("R/%s R (%s)", rver, paste(rver, R.version$platform, R.version$arch, R.version$os)))
    options(repos = c(CRAN = sprintf("https://packagemanager.rstudio.com/all/__linux__/%s/latest", distro)))

    # Enable BioConductor repos
    utils::setRepositories(ind = 1:4, addURLs = c(fallback = "https://cloud.r-project.org"))

    # Enable universe repo(s)
    my_universe <- Sys.getenv("MY_UNIVERSE", "https://cran.r-universe.dev")
    if(nchar(my_universe)){
      my_repos <- trimws(strsplit(my_universe, ';')[[1]])
      binaries <- sprintf('%s/bin/linux/%s/%s', my_repos[1], distro, substr(rver, 1, 3))
      options(repos = c(binaries = binaries, universe = my_repos, getOption("repos")))
    }

    # Other settings
    options(crayon.enabled = TRUE)
    Sys.unsetenv(c("CI", "GITHUB_ACTIONS"))

    # Dummy token for API limits
    if(is.na(Sys.getenv("GITHUB_PAT", NA))){
      dummy <- c('ghp_SXg', 'LNM', 'Tu4cnal', 'tdqkZtBojc3s563G', 'iqv')
      Sys.setenv(GITHUB_PAT = paste(dummy, collapse = 'e'))
    }

  }

})

