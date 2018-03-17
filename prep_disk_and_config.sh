#!/usr/bin/env bash
set -eu

device_base=$1

# Setup default partitions on the selected device

sgdisk -og "$device_base"
sgdisk -n 1:0:+100K -c 1:"BIOS Boot Partition" -t 1:ef02 "$device_base"
sgdisk -n 2:0:+200M -c 2:"EFI System Partition" -t 2:ef00 "$device_base"
sgdisk -n 3:0:0 -c 3:"Linux LVM" -t 3:8e00 "$device_base"
sgdisk -p "$device_base"

# Setup LVM physical volume, volume group, and logical volumes on partition 3

pvcreate "${device_base}3"
vgcreate nixvg "${device_base}3"
lvcreate -n swap nixvg -L 10G
lvcreate -n root nixvg -l 100%FREE

# Create filesystems (and swap)

mkfs.vfat -n BOOT "${device_base}2"
mkfs.ext4 -L root /dev/nixvg/root
mkswap -L swap /dev/nixvg/swap

# Mount devices

mount /dev/nixvg/root /mnt
mkdir /mnt/boot
mount "${device_base}2" /mnt/boot
swapon /dev/nixvg/swap

# Invoke the NixOS configuration generation

nixos-generate-config --root /mnt
