#!/bin/bash

dotfiles=(.tmux.conf)

setup_dotfile()
{
    dotfile=$1

    if [ "${dotfile}" == "" ]; then
        echo "Error: no dotfile specified for setup"
        return 1
    fi

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
    ln -sv ${PWD}/${dotfile} ${HOME}/${dotfile}
}

# Make sure all the dotfiles are present
for dotfile in ${dotfiles[@]}; do
    if [ ! -f ${dotfile} ]; then
        echo "Error: ${dotfile} not found"
        exit 1
    else
        setup_dotfile ${dotfile}
    fi
done
