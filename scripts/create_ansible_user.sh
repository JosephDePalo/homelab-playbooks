#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <public_key_file>"
    exit 1
fi

PUBLIC_KEY=$(cat "$1")
HOME_DIR="/home/ansible"
TGT_USER="ansible"

useradd -d $HOME_DIR -s /bin/bash $TGT_USER
echo "$TGT_USER ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/$TGT_USER

mkdir -p "$HOME_DIR/.ssh"
chmod 700 "$HOME_DIR/.ssh"
chown $TGT_USER:$TGT_USER "$HOME_DIR"
chown $TGT_USER:$TGT_USER "$HOME_DIR/.ssh"

touch "$HOME_DIR/.ssh/authorized_keys"
chmod 600 "$HOME_DIR/.ssh/authorized_keys"
chown $TGT_USER:$TGT_USER "$HOME_DIR/.ssh/authorized_keys"

if ! grep -Fxq "$PUBLIC_KEY" "$HOME_DIR/.ssh/authorized_keys"; then
    echo "$PUBLIC_KEY" >>"$HOME_DIR/.ssh/authorized_keys"
fi
