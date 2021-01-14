#!/bin/sh
alias reload!='exec "$SHELL" -l'

function zbat() { zcat "$1" | bat --file-name "$1" }
