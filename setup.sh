#!/bin/bash

nodotfiles=(tmux.conf bash_profile)

setup_dotfile()
{
    if [ "$1" == "" ]; then
        echo "Error: no file specified for setup"
        return 1
    fi

    nodotfile=$1
    dotfile=".${nodotfile}"

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

# Make sure all the nodotfiles are present
for nodotfile in ${nodotfiles[@]}; do
    echo "${nodotfile}"
    if [ ! -f ${nodotfile} ]; then
        echo "Error: ${nodotfile} not found"
        exit 1
    else
        setup_dotfile ${nodotfile}
    fi
done
