#!/bin/sh

set -ue

DEVICE='/dev/nvme0n1'
EFI_PARTITION='/dev/nvme0n1p1'
BOOT_PARTITION='/dev/nvme0n1p2'
LVM_PARTITION='/dev/nvme0n1p3'
SWAP_PARTITION='/dev/nvme0n1p4'
VG_NAME='shitpile'

# in megabytes
START_OFFSET=1
EFI_SIZE=512
BOOT_SIZE=1024
SWAP_SIZE=$((1024 * 32))

EFI_START="$((START_OFFSET))"
EFI_END="$((START_OFFSET + EFI_SIZE))"
BOOT_START="$((EFI_END))"
BOOT_END="$((BOOT_START + BOOT_SIZE))"
LVM_START="$((BOOT_END))"

# physical partitioning crap

# create
parted "${DEVICE}" -- mklabel gpt
parted "${DEVICE}" -- mkpart ESP fat32 "${EFI_START}MB" "${EFI_END}MB"
parted "${DEVICE}" -- mkpart primary ext4 "${BOOT_START}MB" "${BOOT_END}MB"
parted "${DEVICE}" -- mkpart primary "${LVM_START}" "-${SWAP_SIZE}MB"
parted "${DEVICE}" -- mkpart primary linux-swap "-${SWAP_SIZE}MB" '100%'
parted "${DEVICE}" -- set 1 esp on

# format
EFI_FILESYSTEM_LABEL='efi'
BOOT_FILESYSTEM_LABEL='boot'
mkfs.fat -F '32' -n "${EFI_FILESYSTEM_LABEL}" "${EFI_PARTITION}"
mkfs.ext4 -L "${BOOT_FILESYSTEM_LABEL}" "${BOOT_PARTITION}"

# lvm crap

# create
ROOT_VOL_NAME='root'
ROOT_VOL_SIZE='70G'
HOME_VOL_NAME='home'
HOME_VOL_SIZE='100%FREE'
pvcreate "${LVM_PARTITION}"
vgcreate "${VG_NAME}" "${LVM_PARTITION}"
lvcreate -L "${ROOT_VOL_SIZE}" -n "${ROOT_VOL_NAME}" "${VG_NAME}"
lvcreate -L "${HOME_VOL_SIZE}" -n "${HOME_VOL_NAME}" "${VG_NAME}"

# format
ROOT_FILESYSTEM_LABEL='nixos-root'
HOME_FILESYSTEM_LABEL='nixos-home'
mkfs.ext4 -L "${ROOT_FILESYSTEM_LABEL}" "/dev/${VG_NAME}/${ROOT_VOL_NAME}"
mkfs.ext4 -L "${HOME_FILESYSTEM_LABEL}" "/dev/${VG_NAME}/${HOME_VOL_NAME}"

# nix install crap

# mount root
mkdir -p '/mnt'
mount "/dev/${VG_NAME}/${ROOT_VOL_NAME}" '/mnt'

# mount boot
mkdir -p '/mnt/boot'
mount "${BOOT_PARTITION}" '/mnt/boot'

# mount efi
mkdir -p '/mnt/boot/efi'
mount "${EFI_PARTITION}" '/mnt/boot'

# mount home
mkdir -p '/mnt/home'
mount "/dev/${VG_NAME}/${HOME_VOL_NAME}" '/mnt/home'

# mount swap
mkswap -L swap "${SWAP_PARTITION}"
swapon "${SWAP_PARTITION}"

# install
nixos-generate-config --root '/mnt'
nixos-install
