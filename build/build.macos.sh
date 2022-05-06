#!/bin/sh
set -x

make ARCH=arm64 -f Makefile.macos clean all
mv libAprilTag.so arm64.so

make ARCH=x86_64 -f Makefile.macos clean all
mv libAprilTag.so x86_64.so

lipo -create -output AprilTag.bundle arm64.so x86_64.so
