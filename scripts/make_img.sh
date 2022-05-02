#!/usr/bin/sh
# create a bootable image
# go into the main directory
cd ..

export CMAKE_BUILD_TYP=debug

mkdir img-build
cd img-build || exit 1


source ../scripts/make_limine.sh || exit 25
sudo -E /bin/sh ../scripts/elevated_helper.sh
