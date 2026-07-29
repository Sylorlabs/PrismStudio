# Quarantined physical AMDGPU attempt — 2026-07-16

## Scope

One explicitly user-authorized, bounded physical fill was attempted on the
single display-bound RX 5700 XT through the pure-Zag certification runner. The
runner used one workgroup, a four-byte logical output, exact readback, fence
ordering, and before/after kernel-log hashing. This is **not** isolated
certification evidence.

## Result

The attempt quarantined immediately and made no campaign progress:

| Field | Value |
| --- | --- |
| isolation | `shared-device-no-fault-isolation` |
| policy decision | `28` — user-authorized bounded request; shared display fault domain is not contained |
| completed | `0 / 10000` |
| readback | failed |
| kernel-log baseline | changed |
| mismatch count | `1` |
| timeout/reset/fault counters | `0 / 0 / 0` in runner state |

The kernel journal recorded `ring comp_1.3.1 timeout`, identified the
`prism-gpu-certi` process, then reset the compute ring successfully and reported
the device wedged but recovered. No further physical submissions may be made
from this campaign state.

## Consequence

The physical AMDGPU checklist remains open. This result is a source-level
command-stream/runtime investigation target, but it is not evidence that any
other language is involved: the submission path is implemented in pure Zag.
Future diagnosis must use the compiler-owned virtual GFX10.1 device, PM4/ABI
inspection, and reset-isolated non-display hardware for any repeat physical
attempt.
