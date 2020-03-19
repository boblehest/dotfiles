#!/usr/bin/sh
set -euxo pipefail
username="jlo"
targetDisk=$1
rootDiskNum=1
bootDiskNum=2
root="/mnt"
dotfilesRepo="https://github.com/boblehest/dotfiles.git"

# if swap
# swapDiskNum=2
# bootDiskNum=3

wipefs -a "${targetDisk}"
parted "${targetDisk}" -- mklabel gpt
parted "${targetDisk}" -- mkpart primary 512MiB 100% # -8GB
# parted "${targetDisk}" -- mkpart primary linux-swap -8GB 100%
parted "${targetDisk}" -- mkpart ESP fat32 1MiB 512MiB
parted "${targetDisk}" -- set "$bootDiskNum" boot on

mkfs.ext4 -L nixos "${targetDisk}${rootDiskNum}"
# mkswap -L swap "${targetDisk}${swapDiskNum}"
# swapon "${targetDisk}${swapDiskNum}"
mkfs.fat -F 32 -n boot "${targetDisk}${bootDiskNum}"

mount /dev/disk/by-label/nixos "$root"
mkdir -p "$root/boot"
mount /dev/disk/by-label/boot "$root/boot"
nixos-generate-config --root "$root"
rm "$root/etc/nixos/configuration.nix"

nix-env -iA nixos.git
git clone "$dotfilesRepo" "$root/etc/nixos/dotfiles"
cp "$root/etc/nixos/dotfiles/scripts/shim.nix" "$root/etc/nixos/configuration.nix"

nix-channel --add https://nixos.org/channels/nixos-unstable nixos
nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
nix-channel --update

nixos-install

passwd "$username"
