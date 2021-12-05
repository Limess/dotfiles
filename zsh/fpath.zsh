if type brew &>/dev/null
then
    echo $(brew --prefix)/share/zsh/site-functions
    FPATH="${FPATH}:$(brew --prefix)/share/zsh/site-functions"
fi
