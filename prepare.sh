#!/usr/bin/env sh

if [ -z "$kernelver" ]; then
  echo "Using DPKG_MAINTSCRIPT_PACKAGE instead of kernelver"
  kernelver=$( echo $DPKG_MAINTSCRIPT_PACKAGE | sed -r 's/linux-(headers|image)-//')
fi

make KERNEL_VERSION=$kernelver sources
make patch_trace
make clean
