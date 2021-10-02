export IS_WSL=$(uname -a | grep -i -c "microsoft")

if [[ "${IS_WSL}" -eq 1 ]]; then
    export BROWSER="/mnt/c/Program\ Files/Mozilla\ Firefox/firefox.exe"

    alias open="$BROWSER $1"
fi

