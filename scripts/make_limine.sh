#!/bin/sh
# builds the bootloader from the vendor tree
# get out of the scripts folder back to the main folder

# We use llvm and NASM for the OS too
export TOOLCHAIN=llvm

# initialize the submodules if not yet done
git submodule init || exit
# cd into the limine subtree
cd vendor/limine || exit 1
# make sure we are in the latest tested version tag
git checkout v3.4.3 || exit 2
# as per the limine readme generate the configs for building
./autogen.sh
# go back to the root and create a directory to build into
cd ../../
mkdir bootloader-build

cd bootloader-build || exit 1
# build the bootloader itself
../vendor/limine/configure
make -j

export PATH=${PATH}:$(pwd)/bin
export LIMINE_PATH=$(pwd)

cd -
