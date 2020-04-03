#!/usr/bin/sh

help() {
	>&2 echo "Usage: $0 <target disk> <username> <hostname> [feature...]"
	>&2 echo "feature: work | laptop | swap"
	
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
echo "{username=\"${username}\";conserveMemory=${swap};hostName=\"${hostname}\";laptopFeatures=${laptop};workFeatures=${work};}" > "$root/etc/nixos/dotfiles/settings.nix"

nix-channel --add https://nixos.org/channels/nixos-unstable nixos
# TODO These steps have to be re-run after reboot for them to stick. Why??
nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
nix-channel --update

nixos-install
