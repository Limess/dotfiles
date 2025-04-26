#!/bin/bash

set -e

# Setup zsh shell
echo "> Using zsh shell"

# Find zsh path
if [ -f "/usr/local/bin/zsh" ]; then
  ZSH_PATH="/usr/local/bin/zsh"
elif [ -f "/usr/bin/zsh" ]; then
  ZSH_PATH="/usr/bin/zsh"
elif [ -f "/bin/zsh" ]; then
  ZSH_PATH="/bin/zsh"
else
  echo "zsh not found. Please install zsh first."
  exit 1
fi

# Check if zsh is the default shell
if [ "$SHELL" != "$ZSH_PATH" ]; then
    echo "$ZSH_PATH" | sudo tee -a /etc/shells
    chsh -s "$ZSH_PATH"
fi
