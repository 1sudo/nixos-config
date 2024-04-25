#!/bin/bash

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

is_symlink() {
    [ -L "$1" ]
}

remove_or_unlink() {
    local dir=$1
    if is_symlink "$dir"; then
        unlink "$dir"
    else
        rm -rf "$dir"
    fi
}

remove_or_unlink "$HOME/.config/sway"
remove_or_unlink "$HOME/.config/terminator"

ln -s "$SCRIPT_DIR/config/sway" "$HOME/.config"
ln -s "$SCRIPT_DIR/config/terminator" "$HOME/.config"

read -p "Copy bashrc? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  cp "$SCRIPT_DIR/config/bashrc" "$HOME/.bashrc"
fi
