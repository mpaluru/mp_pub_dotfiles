#!/bin/bash

if [ "$(whoami)" != "root" ]; then
    sudo su -c "`curl -fsSL https://raw.githubusercontent.com/mpaluru/mp_pub_dotfiles/master/install.sh`"
fi

lsb_dist=''

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

# Took this from docker installation script
# perform some very rudimentary platform detection
detect_lsb_dist() {
	if command_exists lsb_release; then
		lsb_dist="$(lsb_release -si)"
	fi
	if [ -z "$lsb_dist" ] && [ -r /etc/lsb-release ]; then
		lsb_dist="$(. /etc/lsb-release && echo "$DISTRIB_ID")"
	fi
	if [ -z "$lsb_dist" ] && [ -r /etc/debian_version ]; then
		lsb_dist='debian'
	fi
	if [ -z "$lsb_dist" ] && [ -r /etc/fedora-release ]; then
		lsb_dist='fedora'
	fi
	if [ -z "$lsb_dist" ] && [ -r /etc/oracle-release ]; then
		lsb_dist='oracleserver'
	fi
	if [ -z "$lsb_dist" ] && [ -r /etc/centos-release ]; then
		lsb_dist='centos'
	fi
	if [ -z "$lsb_dist" ] && [ -r /etc/redhat-release ]; then
		lsb_dist='redhat'
	fi
	if [ -z "$lsb_dist" ] && [ -r /etc/os-release ]; then
		lsb_dist="$(. /etc/os-release && echo "$ID")"
	fi

	lsb_dist="$(echo "$lsb_dist" | tr '[:upper:]' '[:lower:]')"

	# Special case redhatenterpriseserver
	if [ "${lsb_dist}" = "redhatenterpriseserver" ]; then
        	# Set it to redhat, it will be changed to centos below anyways
        	lsb_dist='redhat'
	fi
}

check_prerequisites()
{

    case "$lsb_dist" in
		ubuntu|debian)
            apt-get update && apt-get install -y tmux git
        ;;
        fedora|centos|redhat)
            yum install -y git tmux
        ;;
        *)
            echo "Error: couldn't figure out OS installtion"
            exit 1
        ;;
    esac
}

detect_lsb_dist
echo "detected: ${lsb_dist}"
check_prerequisites

REPO=mp_pub_dotfiles
INSTALL_DIR="${HOME}/.${REPO}"

GIT_REPO_URL=https://github.com/mpaluru/${REPO}.git

if [ ! -d ${INSTALL_DIR} ]; then
    echo "Installing ${REPO} for the first time"
    git clone ${GIT_REPO_URL} ${INSTALL_DIR}
    cd ${INSTALL_DIR}
    ./setup.sh
else
    echo "${REPO} is already installed"
fi
