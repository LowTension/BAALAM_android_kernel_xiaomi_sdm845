#!/bin/bash

# Basic build function
BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'

#export PATH="${HOME}/android-kernel/proton-clang/bin:${PATH}"

COMPILER=clang

# Speed up build process
#MAKE="./makeparallel"

export USE_CCACHE=1
export KBUILD_BUILD_USER="zonarmr"
export KBUILD_BUILD_HOST="zonarmr"

clean(){
    rm -rf out
    mkdir out
    make O=out mrproper
}

build() {
 make O=out ARCH=arm64 dipper_defconfig
 make -j$(nproc --all) O=out \
    ARCH=arm64 \
    CC=${COMPILER} \
    CROSS_COMPILE=aarch64-linux-gnu- \
    CROSS_COMPILE_ARM32=arm-linux-gnueabi- | tee kernel.log
}

clean
build

BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$cyan Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"

