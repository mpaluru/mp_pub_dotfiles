#!/bin/bash -ex

if [ "$(whoami)" != "root" ]; then
    sudo su -c "`curl -fsSL https://raw.githubusercontent.com/mpaluru/mp_pub_dotfiles/master/install.sh`"
    exit
fi

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
