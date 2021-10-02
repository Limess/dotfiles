export IS_WSL=$(uname -a | grep -i -c "microsoft")

if [[ "${IS_WSL}" -eq 1 ]]; then
    	# Use wsl-open on WSL https://github.com/4U6U57/wsl-open
	alias open="wsl-open $1"
fi

