# Quarantined physical AMDGPU v2-contract attempt — 2026-07-16

## Scope

After the compiler-owned ZGK1 v2 PM4 dispatch contract passed the complete
PrismStudio safe gate, strict Zag GFX10.1 VM suite, and virtual certification,
one explicitly user-authorized bounded physical fill was attempted on the
shared display RX 5700 XT. The attempt used one workgroup and exact readback,
fence, and kernel-log checks.

## Result

The attempt quarantined immediately:

| Field | Value |
| --- | --- |
| isolation | `shared-device-no-fault-isolation` |
| decision | `28` — user-authorized bounded shared-display request |
| completed | `0 / 10000` |
| readback | failed |
| kernel-log baseline | changed |
| mismatch count | `1` |

The kernel journal records a `comp_1.2.0` timeout for `prism-gpu-certi`, then a
successful ring reset and `device wedged, but recovered through reset`. The
first physical attempt timed out on `comp_1.3.1`; the repeat after the v2
compiler/runtime contract failed on another compute ring. This makes the
failure reproducible across the two bounded attempts, not a one-off stale
campaign artifact.

## Consequence

Do not submit another physical command stream on this shared display GPU.
The virtual path remains verified; the physical PM4/driver integration requires
an independently resettable GPU and a captured known-good command submission
trace before further silicon certification work.
