#!/usr/bin/sh
# create a bootable image
# go into the main directory
cd ..
echo $(pwd)

export CMAKE_BUILD_TYP=debug

mkdir -p img-build/iso_root

#source scripts/make_limine.sh || exit 25
(
  cd vendor/
  git clone https://github.com/limine-bootloader/limine.git limine-bin --branch=v3.0-branch-binary --depth=1
  make -j -C limine-bin
)
LIMINE_PATH="$(pwd)/vendor/limine-bin"

cd img-build || exit 1

cp -v "../cmake-build-${CMAKE_BUILD_TYP}/merlin.sys" ../config/limine.cfg "${LIMINE_PATH}/limine.sys" iso_root/
cp -v "${LIMINE_PATH}/limine-cd.bin" "${LIMINE_PATH}/limine-cd-efi.bin" iso_root/

xorriso -as mkisofs -b limine-cd.bin \
  -no-emul-boot -boot-load-size 4 -boot-info-table \
  --efi-boot limine-cd-efi.bin \
  -efi-boot-part --efi-boot-image --protective-msdos-label \
  iso_root -o merlin.iso

"${LIMINE_PATH}/limine-deploy" merlin.iso
