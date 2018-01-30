#!/bin/bash

setup_dotfile()
{
    if [ "$1" == "" ]; then
        echo "Error: no file specified for setup"
        return 1
    fi

    nodotfile=$1
    dotfile=$2

    # Setup the dotfile
    if [ -h ${HOME}/${dotfile} ]; then
        echo "A symlink already exists for ${dotfile}, removing it"
        rm ${HOME}/${dotfile}
    else
        if [ -f ${HOME}/${dotfile} ]; then
            echo "File: ${dotfile} already exists, moving to ${dotfile}.backup"
            mv ${HOME}/${dotfile} ${HOME}/${dotfile}.backup
        fi
    fi

    echo "Creating the symlink for ${dotfile}"
    ln -sv ${PWD}/${nodotfile} ${HOME}/${dotfile}
}

setup_dotfile bash_profile .bash_profile

tmux_nodotfile=tmux.1.8.conf
type tmux
if [ $? -eq 0 ]; then
    tmux_nodotfile=$(tmux -V | tr ' ' '.').conf
fi


setup_dotfile ${tmux_nodotfile} .tmux.conf
