export PIPENV_VENV_IN_PROJECT=true
export POETRY_VIRTUALENVS_IN_PROJECT=true

export PATH=$PATH:$(python3 -c "import site; print(site.USER_BASE)")/bin/
if command -v python 1>/dev/null 2>&1; then
	export PATH=$PATH:$(python -c "import site; print(site.USER_BASE)")/bin/
fi
export PATH=$HOME/.poetry/bin:$PATH
if command -v pyenv 1>/dev/null 2>&1; then
	eval "$(pyenv init --path)"
	eval "$(pyenv init -)"
	eval "$(pyenv virtualenv-init -)"
fi
