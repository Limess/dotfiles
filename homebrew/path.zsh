BREW_SITE_FUNCTIONS="$(brew --prefix)/share/zsh/site-functions"
export FPATH=$BREW_SITE_FUNCTIONS:$FPATH
export fpath=($BREW_SITE_FUNCTIONS $fpath)
