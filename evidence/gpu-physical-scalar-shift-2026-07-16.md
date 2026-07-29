# Quarantined scalar-shift physical attempt — 2026-07-16

## Scope

After CP writes, compute/GFX transport, minimal shader stores, scalar-base
addressing, and TGID delivery passed independently, Zag's compiler-owned fill
kernel replaced its vector offset shift with `s_lshl_b32`. The strict GFX10.1
VM and Prism manifest/metadata tests passed before one user-authorized physical
workgroup was submitted on the shared display RX 5700 XT.

## Result

The one-workgroup attempt failed exact readback and changed the kernel-log
baseline. The kernel reported a `comp_1.1.0` timeout, created an AMDGPU device
coredump, reset the ring successfully, and recovered the device. The persisted
report is `evidence/gpu-fill-scalar-shift.report`; completion remained `0/10000`.

## Consequence

The earlier vector shift is not the sole cause. No physical checklist item is
complete. The next compiler candidate computes the byte offset using two SOP2
scalar additions, avoiding both scalar and vector shift families; it has passed
the full 1,096,401-submission, 86,400-logical-second virtual certification but
has not been physically submitted after this quarantined anomaly.
