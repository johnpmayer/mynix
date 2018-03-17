#!/usr/bin/env bash
set -eu

config_file="/mnt/etc/nixos/configuration.nix"

# Ensure that the config created by prep_user.sh is included in the top-level config
sed -i '/hardware-configuration.nix/a \ \ \ \ \ \ ./user-configuration.nix' "$config_file"

# Enable sshd with X11 forwarding
sed -i 's/# services.openssh.enable = true;/services.openssh.enable = true;/' "$config_file"
sed -i '/services.openssh.enable/a \ \ services.openssh.forwardX11 = true;' "$config_file"
   
