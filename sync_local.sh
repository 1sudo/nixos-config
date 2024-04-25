#!/bin/sh

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cp /etc/nixos/configuration.nix $SCRIPT_DIR/nix_configs/configuration.nix
rm -rf $SCRIPT_DIR/nix_configs/neovim
cp -R /etc/nixos/neovim $SCRIPT_DIR/nix_configs/
