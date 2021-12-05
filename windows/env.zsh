export IS_WSL=$(uname -a | grep -i -c "microsoft")

if [[ "${IS_WSL}" -eq 1 ]]; then
    	# Use wsl-open on WSL https://github.com/4U6U57/wsl-open
	alias open="wsl-open $1"
fi


if [ -z "$SSH_TTY" ]; then
	if [ "${IS_WSL}" -eq 1 ]; then
	    # http://manpages.ubuntu.com/manpages/xenial/man1/keychain.1.html
		# https://devblogs.microsoft.com/commandline/sharing-ssh-keys-between-windows-and-wsl-2/
		# add id_rsa ssh key to keychain which is shared between tabs and start ssh agent
		eval `keychain --agents ssh -q --eval id_rsa`
	fi
fi

# Simple alternative to background tasks on startup rather than having to run fakesystemd
# check with ps first as we need sudo to actually check status
dnsmasq_running=$(ps -fC dnsmasq)
if ("$?" == "1") then
	sudo service dnsmasq status
	if ("$?" == "0") then
		# dnsmasq is running
	else
		sudo service dnsmasq start
	endif
endif
