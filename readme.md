# Modified vc4 Linux kernel module

This contains the downstream RaspberrryPi Linux kernel version with the following modifications/patches:

 1. A patch to workaround the GPU resetting error reported in https://github.com/raspberrypi/linux/issues/5780
 2. A patch to enable interlaced video modes for the DPI port (see https://github.com/raspberrypi/linux/issues/2668).

Both patches I think originate from Github issues pages, but the versions included here have been picked up from the Recalbox project, which included them in their Linux kernel patches ([here for instance](https://gitlab.com/recalbox/recalbox/-/commit/b05d2c3202c6590ab63846793a7d9a8f26805efd).

## Installation

 This out-of-tree kernel module is supported only for RaspiOS distributions since it uses the Debian packages specific to it.

 The installation of the module is meant to be done via `dkms`. The build steps will download the driver files for the kernel version from Github. The commit hash of the tree from which the driver files are fetched is found from the RaspiOS `linux-image` package changelog file (see the included `Makefile`).

 Install steps

``` sh
 # clone the repo 
 git clone https://github.com/cmitu/vc4-dkms
 # tell DKMS about the module
 sudo dkms add vc4-dkms
 # build and install the module
 sudo dkms install vc4-dkms/0.1
```

  Once installed, the module will be re-built on kernel updates.

## Updates
 
  To update to a new version of the module from this repo, remove the driver with `sudo dkms remove vc4-dkms/0.1` and then repeat the installation steps above.

## Note for kernel versions

  The kernel versions supported are 6.1.x to 6.18.y.

NOTE:
  The installation of a development kernel with `rpi-update` is not supported, but `dkms` wouldn't work anyway unless `rpi-source` is also used to clone the corresponding Linux kernel source/headers.
