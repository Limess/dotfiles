#!/bin/bash

set -ex

# Setup zsh shell
echo "> Using zsh shell"

# Check if zsh is the default shell
if [ "$SHELL" != "/usr/local/bin/zsh" ]; then
    echo /usr/local/bin/zsh | sudo tee -a /etc/shells
    chsh -s /usr/local/bin/zsh
fi
