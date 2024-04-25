#!/bin/sh

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cp /etc/nixos/configuration.nix $SCRIPT_DIR/configuration.nix
