#!/usr/bin/env bash

commit=$1
tag="rpi-6.12.y"

# fetch by commit, if given, otherwise fetch by branch/tag
if [ -z "$commit" ]; then
    echo Fetching original sources by tag/branch: $tag
    base_url="https://raw.githubusercontent.com/raspberrypi/linux/${tag}/drivers/gpu/drm/vc4"
else
    echo Fetching original sources by commit: $commit
    base_url="https://raw.githubusercontent.com/raspberrypi/linux/${commit}/drivers/gpu/drm/vc4"
fi

declare -a files=(
    Kconfig
    Makefile
    vc4_bo.c
    vc4_crtc.c
    vc4_debugfs.c
    vc4_dpi.c
    vc4_drv.h vc4_drv.c
    vc4_dsi.c
    vc4_fence.c
    vc4_firmware_kms.c
    vc4_gem.c
    vc4_hdmi.h vc4_hdmi.c
    vc4_hdmi_phy.c
    vc4_hdmi_regs.h
    vc4_hvs.c
    vc4_irq.c
    vc4_kms.c
    vc4_packet.h
    vc4_perfmon.c
    vc4_plane.c
    vc4_qpu_defines.h
    vc4_regs.h
    vc4_render_cl.c
    vc4_trace.h
    vc4_trace_points.c
    vc4_txp.c
    vc4_v3d.c
    vc4_validate.c
    vc4_validate_shaders.c
    vc4_vec.c
    vc4_trace.h
    vc_image_types.h
)

for file in ${files[@]}; do
    echo -n CURL $file 
    curl --silent -N --output-dir src -O "${base_url}/$file" && echo " OK"
done
