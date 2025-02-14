export PIPENV_VENV_IN_PROJECT=true

export POETRY_VIRTUALENVS_IN_PROJECT=true
export POETRY_VIRTUALENVS_PREFER_ACTIVE_PYTHON=true

export PIPX_HOME="$HOME/.local/pipx"

export PATH=$HOME/.poetry/bin:$HOME/.local/bin:$PATH

if command -v pyenv 1>/dev/null 2>&1; then
	eval "$(pyenv init --path)"
	eval "$(pyenv init -)"
	eval "$(pyenv virtualenv-init -)"
fi

# seems unnecessary these days
# export PATH=$PATH:$(python3 -c "import site; print(site.USER_BASE)")/bin/
# if command -v python 1>/dev/null 2>&1; then
#	export PATH=$PATH:$(python -c "import site; print(site.USER_BASE)")/bin/
# fi

IS_WSL=$(uname -a | grep -i -c "microsoft")

if [[ "${IS_WSL}" -eq 1 ]]; then
    # ensure sysdtem install of libffi is used for pyenv compilation rather than homebrew version
    export LDFLAGS="-L /usr/lib/x86_64-linux-gnu"
fi

alias dvc="nocorrect dvc"
alias gto="nocorrect gto"

