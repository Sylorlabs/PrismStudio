# Compatibility and Certification Matrix

Generated evidence is authoritative; this table records the current supported
boundary without promoting unrun hardware work.

| Surface | Current status | Evidence / condition |
|---|---|---|
| Linux x86-64 CPU renderer | supported reference | `build-production`, `render-golden`, `frame-diff`, `soak` |
| Raw X11 desktop UI | PrismStudio 1.0 supported | `x11-live`, `x11-captures`; real display required for release gate |
| Project format `zpa 1` | read/migrate | `engine` legacy migration checks |
| Project format `zpa 2` | read/write | `engine`, `persistence`, canonical hash checks |
| Device model schema 1 | read/pinned/migrate | `model-schema-migration` |
| Device model schema 2 | current | `provenance-units`, `units-dims` |
| Native CLI/pipe/agent/MCP | supported | protocol and agent gate families |
| CPU Photon Solver families | dead-path and constant-collapse supported | `optimizer`, `optimizer-verify` |
| Direct AMDGPU GTT memory | live allocation validated | RX 5700 XT queried through `/dev/dri/renderD128`; 1 MiB CPU-visible GEM allocation, mmap, pattern round-trip, free, and unchanged kernel-log tail passed on 2026-07-14 |
| Direct AMDGPU command dispatch | experimental opt-in, not certified | Never part of the PrismStudio 1.0 release gate; no live submission was performed on the sole display GPU |
| GFX10.1 fill compilation | software-validated | Compiler-owned deterministic bundle and metadata; no silicon execution claim |
| RX 5700 XT display-bound tuple | memory-only validated; compute not certified | Device `0x731f`, family 143, IP-discovery GFX/compute `10.1.10`, ring masks GFX `1`/compute `15`, MEC firmware `156`, SDMA firmware `35`, 2 shader engines, 40 queried CUs; hardware-destructive and long-soak campaigns prohibited on the sole display GPU |
| Automatic GPU raster selection | policy implemented, live use disabled | `std:gpu` requires exact device/IP/firmware/kernel/compiler/runtime tuple, complete zero-anomaly physical campaign, retained representative timing samples, and material measured benefit; `--gpu-cert-status` currently denies at reset isolation |

See `evidence/bench-report.md` for current machine-local benchmark measurements.
