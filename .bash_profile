
if [ "$(whoami)" != "root" ]; then
    echo "Logging into root account ..."
    sudo -s
fi
