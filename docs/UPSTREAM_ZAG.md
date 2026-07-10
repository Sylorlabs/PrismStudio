# Upstream Zag / znc requirements

Triton builds against the sibling self-hosted Zag compiler at
`../zag/zag-poc/znc` (source: `selfhost/native/znc.zag`). This file records
compiler/runtime behaviour Triton depends on, per master plan §3.2/§3.4.

## ZNC-1 — znc crashes compiling a very large single function

**Observed (2026-07-09):** `znc tools/verify.zag` intermittently but often
SIGSEGVs (exit 139, core dumped) once the verification orchestrator's single
`main()` grows large (~70+ sequential statements, each with long string
literals). The crash is nondeterministic across process invocations (seen 0/12
then 12/12 on byte-identical input), which points to memory corruption inside the
compiler — an out-of-bounds write or uninitialised read whose effect depends on
allocation/heap layout — rather than a clean, reported limit.

It is **not** a stack-size limit: compiling under `ulimit -s` up to 1 GB still
crashes, and `ulimit -s unlimited` does not help (it can disable the kernel's
stack auto-grow and is a false lead).

**Mitigation (in-tree, 100% Zag):** `tools/verify.zag` splits its gate list into
several smaller functions (`gates_0..3`) called from a slim `main()`. This keeps
each function well under the size that triggers the crash and compiles reliably
(8/8). No other language is involved.

**Proper upstream fix (required in `selfhost/native/znc.zag`):** find and fix the
memory-safety bug in the compiler's function/statement-list handling — most
likely a fixed-size buffer or index that is written past its bounds when a
function body or its literal/symbol tables grow large. Add a bounds check (or
grow the buffer) so an arbitrarily large function compiles or fails cleanly with
a diagnostic instead of corrupting memory. Until then, keep generated/large Zag
functions modest in size.
