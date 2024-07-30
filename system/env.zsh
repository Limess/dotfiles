export EDITOR='vim'

### Less
# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${yellow}";
# https://github.com/sharkdp/bat/issues/2219#issuecomment-1645456156
export MANPAGER="sh -c 'sed -r \"s/\x1B\[([0-9]{1,3}(;[0-9]{1,2};?)?)?[mGK]//g\" | bat --language man --plain'"

### Languages
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';

if [[ "$(uname)" == "Darwin" ]]; then
    ulimit -n 9999
fi

alias ls=eza
alias cat="bat"
alias grep=rg
alias wrk=wrk2

# used by https://warrensbox.github.io/tgswitch/
export PATH=$PATH:/home/charlie_briggs/bin
