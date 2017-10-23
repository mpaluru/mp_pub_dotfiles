
if [ "$(whoami)" != "root" ]; then
    echo "Logging into root account ..."
    sudo su -l
fi
