# mynix
Scripts for setting up UEFI NixOS on VirtualBox and Hyper-V

# Instructions

First, download the 64-bit minimal live-cd from [NixOS](https://nixos.org/nixos/download.html)

## VirtualBox

1) Create a virtual machine, give it some memory and a hard disk
1) In Settings -> System, Enable EFI boot
1) In Settings -> Storage, Select the live-cd iso in the optical drive

## Boot Machine, Run as root (auto-login from live-cd)

```bash
# Clone this repository
nix-shell -p git --command "git clone https://github.com/johnpmayer/mynix"
cd mynix

# Setup disks, providing the hard disk device as an argument
./prep_disk_and_config.sh /dev/sda

# Setup user from github (no arguments for now, TODO)
./prep_user.sh

# Edit the written configuration (see below)
vi /mnt/etc/nixos/configuration.nix
```

* Add the user-configuration.nix to the imports
* Uncomment openssh daemon to enable

```bash
nixos-install --no-root-passwd
reboot
```
