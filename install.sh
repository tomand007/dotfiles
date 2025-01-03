!/bin/bash

# ensure script is running with bash
if [ ! "$BASH_VERSION" ]; then
	echo "please run this script with bash"
	exit 1
fi

# ensure scripts is run with sudo
if (( EUID != 0 )); then
	echo "please run with sudo"
	exit 1
fi
