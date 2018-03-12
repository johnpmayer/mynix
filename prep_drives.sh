#!/bin/bash
sgdisk -og $1
sgdisk -n 1:0:+100K -c 1:"BIOS Boot Partition" -t 1:ef02 $1
sgdisk -n 2:0:+200M -c 2:"EFI System Partition" -t 2:ef00 $1
sgdisk -n 3:0:0 -c 3:"Linux LVM" -t 3:8e00 $1
sgdisk -p $1
