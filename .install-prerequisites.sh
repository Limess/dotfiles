#!/usr/bin/env bash

set -e

# Install XCode Command Line Tools if necessary
if [[ "$(uname -s)" == "Darwin" ]]; then
    xcode-select --install || echo "XCode already installed"
fi

# Install Homebrew if necessary
if command -v brew &>/dev/null; then
    echo 'Homebrew is already installed'
else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ "$(uname -s)" == "Darwin" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ "$(uname -s)" == "Linux" ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
fi

# Install 1password if necessary
if command -v op &>/dev/null; then
    echo "1password is already installed"
else
    case "$(uname -s)" in
    Darwin)
        brew install 1password-cli
        eval $(op signin --account "EI6GPO6VNJAVLGDDID3B75JI6E")
        ;;
    Linux)
        curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
        sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg && \
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | \
        sudo tee /etc/apt/sources.list.d/1password.list && \
        sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/ && \
        curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
        sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol && \
        sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22 && \
        curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
        sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg && \
        sudo apt update && sudo apt install 1password-cli
        ;;
    *)
        echo "unsupported OS"
        exit 1
        ;;
    esac
fi
