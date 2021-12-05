#!/usr/bin/env bash

# Workaround for terragrunt/tfenv compatibility with brew
# Should be installed to $(brew --repo homebrew/core)/.git/hooks/post-merge
# See https://github.com/gruntwork-io/terragrunt/issues/580#issuecomment-828763058

changed_files="$(git diff-tree -r --name-only --no-commit-id ORIG_HEAD HEAD)"

check_run() {
	echo "$changed_files" | grep --quiet "$1" && eval "$2"
}

function is_gnu_sed(){
  sed --version >/dev/null 2>&1
}

function sed_i_wrapper(){
  if is_gnu_sed; then
    $(which sed) "$@"
  else
    a=()
    for b in "$@"; do
      [[ $b == '-i' ]] && a=("${a[@]}" "$b" "") || a=("${a[@]}" "$b")
    done
    $(which sed) "${a[@]}"
  fi
}

# Remove terraform dependency from terragrunt
check_run terragrunt.rb "sed_i_wrapper -i 's/depends_on \"terraform\"//g' Formula/terragrunt.rb"
