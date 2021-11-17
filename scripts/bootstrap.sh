#!/usr/bin/env bash

help() {
	>&2 echo "Usage: $0 <target disk> <username> <hostname> [feature...]"
	>&2 echo "feature: work | laptop | swap | latex | intelVideo | oldIntel | nvidia"
	
	exit 1
}

numArgs=3

if [ "$#" -lt $numArgs ] ; then
	help
fi

set -euxo pipefail

targetDisk=$1
username=$2
hostname=$3
rootDiskNum=1
bootDiskNum=2
swapStart="100%"

root="/mnt"
dotfilesRepo="https://github.com/boblehest/dotfiles.git"

swap="false"
laptop="false"
work="false"
latex="false"
intelVideo="false"
oldIntel="false" # https://www.reddit.com/r/linux/comments/ihdozd/linux_kernel_58_defaults_to_passive_mode_for/
nvidia="false"

shift $numArgs
while (( "$#" )); do
	case "$1" in
		"swap" )
			swap="true"
			;;
		"laptop" )
			laptop="true"
			;;
		"work" )
			work="true"
			;;
		"latex" )
			latex="true"
			;;
		"intelVideo" )
			intelVideo="true"
			;;
		"oldIntel" )
			oldIntel="true"
			;;
		"nvidia" )
			nvidia="true"
			;;
		* )
			>&2 echo "Error: Unknown feature: $1"
			help
			;;
	esac
	shift
done

if [ "$swap" == "true" ] ; then
	swapDiskNum=2
	bootDiskNum=3
	swapStart="-8GB"
fi


wipefs -a "${targetDisk}"
parted "${targetDisk}" -- mklabel gpt
parted "${targetDisk}" -- mkpart primary 512MiB "${swapStart}"
if [[ -v swapDiskNum ]] ; then
	parted "${targetDisk}" -- mkpart primary linux-swap "${swapStart}" 100%
fi
parted "${targetDisk}" -- mkpart ESP fat32 1MiB 512MiB
parted "${targetDisk}" -- set "$bootDiskNum" boot on

nix-env -iA nixos.jq
readarray -t partNames < <(lsblk -Jpo name "${targetDisk}" | jq -r '.blockdevices[0].children[].name')

mkfs.ext4 -L nixos "${partNames[rootDiskNum-1]}"
if [[ -v swapDiskNum ]] ; then
	mkswap -L swap "${partNames[swapDiskNum-1]}"
	swapon "${partNames[swapDiskNum-1]}"
fi
mkfs.fat -F 32 -n boot "${partNames[bootDiskNum-1]}"

mount /dev/disk/by-label/nixos "$root"
mkdir -p "$root/boot"
mount /dev/disk/by-label/boot "$root/boot"
nixos-generate-config --root "$root"
rm "$root/etc/nixos/configuration.nix"

nix-env -iA nixos.git
git clone "$dotfilesRepo" "$root/etc/nixos/dotfiles"
cp "$root/etc/nixos/dotfiles/scripts/shim.nix" "$root/etc/nixos/configuration.nix"
stateVersion=$(nix eval --raw '(import <nixpkgs/nixos> {})'.config.system.stateVersion)
echo -e "{\n  stateVersion = \"${stateVersion}\";\n  username = \"${username}\";\n  conserveMemory = ${swap};\n  hostName = \"${hostname}\";\n  laptopFeatures = ${laptop};\n  workFeatures = ${work};\n  latex = ${latex};\n  intelVideo = ${intelVideo};\n  oldIntel = ${oldIntel};\n  nvidia = ${nvidia};\n}" > "$root/etc/nixos/dotfiles/settings.nix"

nix-channel --add https://nixos.org/channels/nixos-unstable nixos
nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
nix-channel --update

nixos-install

cp /root/.nix-channels "$root/root/"
