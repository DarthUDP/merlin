#!/usr/bin/sh
# these need sudo
# go into the main directory
if [ -f merlin.img ]; then
    rm merlin.img
fi
fallocate -l 64MiB merlin.img
parted -s merlin.img mklabel gpt
parted -s merlin.img mkpart ESP fat32 2048s 100%
parted -s merlin.img set 1 esp on

echo "Limine deploy on img"
"${LIMINE_PATH}/bin/limine-deploy" merlin.img

USED_LOOPBACK=$(losetup -Pf --show merlin.img)

# Format the ESP partition as FAT32.
mkfs.fat -F 32 "${USED_LOOPBACK}p1"

# Mount the partition itself.
mkdir -p img_mount
mount "${USED_LOOPBACK}p1" img_mount

# Copy the relevant files over.
mkdir -p img_mount/EFI/BOOT
cp -v "../cmake-build-${CMAKE_BUILD_TYP}/merlin.sys" ../config/limine.cfg "${LIMINE_PATH}/bin/limine.sys" img_mount/
cp -v "${LIMINE_PATH}/bin/BOOTX64.EFI" img_mount/EFI/BOOT/

# Sync system cache and unmount partition and loopback device.
sync
umount img_mount
losetup -d "${USED_LOOPBACK}"
