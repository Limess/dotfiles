#!/usr/bin/env bash

test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
test -d /opt/homebrew/bin/brew && eval $(/opt/homebrew/bin/brew shellenv)

# command so we always exit with code 0
true
