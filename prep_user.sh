#!/bin/bash
set -eu

function print_keys {
	curl --silent https://api.github.com/users/johnpmayer/keys | \
		nix-shell --packages jq --command "jq '.[] | .key'"
}

function write_user_configuration {
	cat <<EOF

{ config, pkgs, ... }:

{
  imports = [ ];

  users.extraUsers.john =
    { isNormalUser = true;
      home = "/home/john";
      description = "John P Mayer, Jr.";
      extraGroups = [ "wheel" ];
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


