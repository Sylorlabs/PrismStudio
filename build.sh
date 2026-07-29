#!/usr/bin/env bash
# Build PrismStudio — 100% Zag, zero C.
set -e
cd "$(dirname "$0")"

ZNC="${ZNC:-../zag/zag-poc/znc}"
if [ ! -x "$ZNC" ]; then
    echo "build: znc not found at $ZNC (set ZNC=/path/to/znc)" >&2
    exit 1
fi

echo "== compiler-owned gfx1010 kernel bundle (software-only) =="
"$ZNC" examples/gpu_fill_kernel.zag --target amdgpu-gfx1010 \
    -o examples/gpu_fill_kernel.zgk
"$ZNC" examples/gpu_depth_kernel.zag --target amdgpu-gfx1010 \
    -o examples/gpu_depth_kernel.zgk
"$ZNC" examples/gpu_blend_kernel.zag --target amdgpu-gfx1010 \
    -o examples/gpu_blend_kernel.zgk

echo "== zagpa (Zag -> native ELF, no cc/ld/libc) =="
rm -f zagpa.new
"$ZNC" src/main.zag -o zagpa.new
mv -f zagpa.new zagpa
# Generate the local MCP config only when absent: it embeds absolute paths and
# a capability grant, so a build must never clobber a deliberate local choice.
# Delete mcp-config.json to regenerate (default grant: read,inspect,simulate;
# widen deliberately with PRISMSTUDIO_CAPS=all in the install environment).
if [ ! -f mcp-config.json ]; then
    ./zagpa --mcp-install "$(pwd)"
fi

echo "== agent multi-place + route regression =="
PRISMSTUDIO_CAPS=all ./zagpa --agent examples/agent_demo.tcmd >/dev/null

echo "== engine tests =="
rm -f probe/engine_test.new
"$ZNC" probe/engine_test.zag -o probe/engine_test.new
mv -f probe/engine_test.new probe/engine_test
./probe/engine_test

echo "== X11 pixel packing regression =="
rm -f probe/x11_pixel_pack_test.new
"$ZNC" probe/x11_pixel_pack_test.zag -o probe/x11_pixel_pack_test.new
mv -f probe/x11_pixel_pack_test.new probe/x11_pixel_pack_test
./probe/x11_pixel_pack_test

# GPU access is never part of the default build. Even a buffer-allocation probe
# touches the display adapter and therefore belongs behind an explicit opt-in.
if [ "${PRISMSTUDIO_GPU_MEMORY_TEST:-0}" = "1" ]; then
    echo "== GPU memory probe (opt-in; no command submission) =="
    rm -f probe/gpu_test.new
    "$ZNC" probe/gpu_test.zag -o probe/gpu_test.new
    mv -f probe/gpu_test.new probe/gpu_test
    ./probe/gpu_test
else
    echo "== GPU memory probe: NOT RUN (set PRISMSTUDIO_GPU_MEMORY_TEST=1) =="
fi

# The default proves a distinct VF/IOMMU/FLR reset domain. An informed user may
# instead choose one bounded shared-display run with the exact acknowledgement
# token below. That option is never described as contained or certified.
if [ "${PRISMSTUDIO_GPU_DISPATCH:-0}" = "1" ]; then
    GPU_SYSFS_ROOT="${PRISM_GPU_SYSFS_ROOT:-/sys/class/drm/renderD128/device}"
    GPU_ISOLATION_REPORT=/tmp/prism_gpu_isolation_report
    "$ZNC" ../zag/zag-poc/examples/gpu_isolation_report.zag \
        -o "$GPU_ISOLATION_REPORT"
    if ! "$GPU_ISOLATION_REPORT" "$GPU_SYSFS_ROOT"; then
        if [ "${PRISM_GPU_SHARED_DISPLAY_OVERRIDE:-}" != "I_ACCEPT_DISPLAY_RESET_OR_SYSTEM_HANG" ]; then
            echo "GPU dispatch default-refused: no proved VF/IOMMU/FLR reset domain" >&2
            echo "Explicit bounded override: PRISM_GPU_SHARED_DISPLAY_OVERRIDE=I_ACCEPT_DISPLAY_RESET_OR_SYSTEM_HANG" >&2
            exit 2
        fi
        echo "WARNING: user-authorized shared-display dispatch; reset/system-hang risk is not contained" >&2
    fi

    echo "== GPU command submission (ctx + VM map + PM4 IB + fence) =="
    rm -f probe/gpu_submit_test.new
    "$ZNC" probe/gpu_submit_test.zag -o probe/gpu_submit_test.new
    mv -f probe/gpu_submit_test.new probe/gpu_submit_test
    ./probe/gpu_submit_test

    echo "== GPU compute: pure-Zag RDNA1 shader on the shader cores =="
    rm -f probe/gpu_compute_test.new
    "$ZNC" probe/gpu_compute_test.zag -o probe/gpu_compute_test.new
    mv -f probe/gpu_compute_test.new probe/gpu_compute_test
    ./probe/gpu_compute_test
else
    echo "== (GPU dispatch tests skipped; set PRISMSTUDIO_GPU_DISPATCH=1 to run) =="
fi

echo "== headless render smoke =="
./zagpa --smoke probe/smoke_app.bmp

if [ -n "$DISPLAY" ]; then
    echo "== X11 wire-protocol round-trip selftest =="
    ./zagpa --x11-selftest
else
    echo "== X11 selftest: NOT RUN (DISPLAY is unset) =="
    if [ "${PRISMSTUDIO_REQUIRE_X11:-0}" = "1" ]; then
        exit 1
    fi
fi

echo "== agent smoke =="
printf 'ping\ndemo\nlist\nquit\n' | PRISMSTUDIO_CAPS=all ./zagpa --agent >/dev/null

echo "build ok. run:  ./run.sh   agent:  ./zagpa --agent   mcp:  ./zagpa --mcp"
