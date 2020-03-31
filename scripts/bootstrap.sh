#!/usr/bin/sh

help() {
	>&2 echo "Usage: $0 <target disk> <username> <hostname> <swap|noswap>"
	exit 1
}

if [ "$#" -ne 4 ] ; then
	help
fi

set -euxo pipefail

targetDisk=$1
username=$2
hostname=$3
swap=$4
rootDiskNum=1
bootDiskNum=2
swapStart="100%"
conserveMemory="false"

root="/mnt"
dotfilesRepo="https://github.com/boblehest/dotfiles.git"

if [ "$swap" == "swap" ] ; then
	swapDiskNum=2
	bootDiskNum=3
	swapStart="-8GB"
	conserveMemory="true"
elif [ "$swap" != "noswap" ] ; then
	help
fi


wipefs -a "${targetDisk}"
parted "${targetDisk}" -- mklabel gpt
parted "${targetDisk}" -- mkpart primary 512MiB "${swapStart}"
if [[ -v swapDiskNum ]] ; then
	parted "${targetDisk}" -- mkpart primary linux-swap "${swapStart}" 100%
fi
parted "${targetDisk}" -- mkpart ESP fat32 1MiB 512MiB
parted "${targetDisk}" -- set "$bootDiskNum" boot on

mkfs.ext4 -L nixos "${targetDisk}${rootDiskNum}"
if [[ -v swapDiskNum ]] ; then
	mkswap -L swap "${targetDisk}${swapDiskNum}"
	swapon "${targetDisk}${swapDiskNum}"
fi
mkfs.fat -F 32 -n boot "${targetDisk}${bootDiskNum}"

mount /dev/disk/by-label/nixos "$root"
mkdir -p "$root/boot"
mount /dev/disk/by-label/boot "$root/boot"
nixos-generate-config --root "$root"
rm "$root/etc/nixos/configuration.nix"

nix-env -iA nixos.git
git clone "$dotfilesRepo" "$root/etc/nixos/dotfiles"
cp "$root/etc/nixos/dotfiles/scripts/shim.nix" "$root/etc/nixos/configuration.nix"
echo "{username=\"${username}\";conserveMemory=${conserveMemory};hostName=\"${hostname}\";laptopFeatures=false;workFeatures=false;}" > "$root/etc/nixos/dotfiles/settings.nix"

nix-channel --add https://nixos.org/channels/nixos-unstable nixos
nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
nix-channel --update

nixos-install
