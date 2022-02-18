export EDITOR='vim'

### Less
# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${yellow}";
export MANPAGER='less -X';

### Languages
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';

if [[ "$(uname)" == "Darwin" ]]; then
    ulimit -n 9999
fi

alias ls=exa
alias cat="bat"
alias grep=rg
alias wrk=wrk2

# used by https://warrensbox.github.io/tgswitch/
export PATH=$PATH:/home/charlie_briggs/bin
