#!/usr/bin/env bash
set -eu

username=$1
password_hash=$(nix-shell -p mkpasswd --command "mkpasswd -m sha-512")

function print_keys {
	curl --silent "https://api.github.com/users/${username}/keys" | \
		nix-shell --packages jq --command "jq '.[] | .key'"
}

function write_user_configuration {
	cat <<EOF

{ config, pkgs, ... }:

{
  imports = [ ];

  users.extraUsers.${username} =
    { isNormalUser = true;
      home = "/home/${username}";
      description = "NixOS managed user ${username}";
      extraGroups = [ "wheel" ];
      hashedPassword = "${password_hash}";
      openssh.authorizedKeys.keys = [
EOF

	print_keys

	cat <<EOF
      ];
    };
}
EOF

}

USERFILE='/mnt/etc/nixos/user-configuration.nix'

write_user_configuration > $USERFILE


