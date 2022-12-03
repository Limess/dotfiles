#!/usr/bin/env bash

export IS_WSL=$(uname -a | grep -i -c "microsoft")

if [[ "${IS_WSL}" -eq 1 ]]; then
    # Use wsl-open on WSL https://github.com/4U6U57/wsl-open
    alias open="wsl-open $1"

    if [ -z "$SSH_TTY" ]; then
    # http://manpages.ubuntu.com/manpages/xenial/man1/keychain.1.html
    # https://devblogs.microsoft.com/commandline/sharing-ssh-keys-between-windows-and-wsl-2/
    # add id_rsa ssh key to keychain which is shared between tabs and start ssh agent
        eval `keychain --agents ssh -q --eval id_rsa`
    fi

    export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/usr/lib/x86_64-linux-gnu/pkgconfig"
fi
