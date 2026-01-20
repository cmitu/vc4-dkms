# kernel source variables, optionally set by `dkms`
KERNEL_VERSION ?=$(shell uname -r)
KERNEL_SOURCE_DIR ?= /lib/modules/$(shell uname -r)/build

TOPDIR = $(shell pwd)
RPI_COMMIT = $(shell zgrep -m1 commit "/usr/share/doc/linux-image-$(KERNEL_VERSION)/changelog.Debian.gz" | cut -d: -f2)
SHELL := /usr/bin/bash

# vc4 module config options
CONFIG_DEBUG_FS = n
CONFIG_DRM_VC4_KUNIT_TEST = n

# local patches
PATCHES := $(shell find "$(TOPDIR)/patches" -name '*.diff')

# quiet/verbose flag
ifneq ($(V),1)
   Q := @
endif

.PHONY: $(PATCHES)

all:	apply_patches modules

apply_patches: patch_series patch_trace

# apply the patches from the 'patches' folder
patch_series: $(PATCHES)

$(PATCHES):
	@echo PATCH $(notdir $@)
	$(Q)patch -p1 --silent --forward < $@


# patch the out-of-tree trace include location
patch_trace:
	@echo Patching TRACE_INCLUDE_PATH in vc4_trace.h
	$(Q)sed -i "s:#define TRACE_INCLUDE_PATH.*:#define TRACE_INCLUDE_PATH $(TOPDIR)/src:" "$(TOPDIR)/src/vc4_trace.h"

# compile the module (used by DKMS)
modules:
	$(Q)$(MAKE) -C "$(KERNEL_SOURCE_DIR)" M="$(TOPDIR)/src" $@

# cleanup the sources and patch results (used by DKMS)
clean:
	$(Q)$(MAKE) -C "$(KERNEL_SOURCE_DIR)" M="$(TOPDIR)/src" clean
	$(Q)rm -f "$(TOPDIR)/src/"*.rej
	$(Q)rm -f "$(TOPDIR)/src/"*.orig

# re-generate the `src` folder contents
sources: refresh_sources patch_trace clean

# refresh source files based on the running kernel's Git commit
refresh_sources:
ifeq ($(RPI_COMMIT),)
	$(error Cannot determine kernel's git commit hash !)
else
	$(Q)$(SHELL) "$(TOPDIR)/download.sh" $(RPI_COMMIT)
endif

