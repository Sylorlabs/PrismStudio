# Upstream Zag / znc requirements

PrismStudio builds against the sibling self-hosted Zag compiler at
`../zag/zag-poc/znc` (source: `selfhost/native/znc.zag`). This file records
compiler/runtime behaviour PrismStudio depends on, per master plan §3.2/§3.4.

## ZNC-1/ZNC-2 — resolved: exact-width byte memory operations

**Original symptoms (2026-07-09 through 2026-07-13):** sustained compiler use
could make an unchanged source either compile or SIGSEGV, and rare outputs
differed by a few bytes. The decisive full-suite recurrence was `znc` crashing
while compiling `probe/outline_test.zag`.

**Root cause (2026-07-13):** an `strace -ff` capture showed `znc` receiving the
correct source/output arguments and faulting exactly at an mmap page boundary.
Zag's x86 native backend implemented a byte load as an eight-byte load plus mask,
and a byte store as an eight-byte read/modify/write. Accessing the final byte of
an allocation could therefore touch the protected or unmapped following page.
Heap layout made the defect appear nondeterministic; splitting functions merely
changed that layout and was never a valid language fix.

**Upstream fix:** the sibling Zag compiler now has first-class `K_LOAD8` and
`K_STORE8` instructions, x86 encodings for exact-width `movzx` byte loads and
byte stores (including the required REX cases), and native lowering/runtime
helpers that use them for string, slice, argv/environment, copy, compare, and
index operations. A separate defensive fix patches each native function's stack
frame from the actual lowering high-water mark so the pre-scan is an estimate,
not a correctness boundary. All changes are pure Zag; PrismStudio contains no
compiler workaround and no C fallback.

**Regression evidence:** a pure-Zag guard-page test places the final byte at the
end of an mmap and protects the next page. The old compiler's result exited 139;
the fixed compiler reads/writes the byte and exits 42. The native suite includes
that test and passes 132/132. Sixteen concurrent compiles of the former outline
reproducer produced zero compile/run failures and one unique SHA-256. Zag's
stage-2/stage-3 self-hosted fixed point is byte-identical at
`9a449bc5f5572964cc21035f0e4acb376f1f0aeb73246cfb844effa487c33a8b`.
Two fresh production `src/main.zag` compiles were also byte-identical at
`aae7646fc3e7f3df0d5388735d250edcd14ecc59722fc3909a9d9c7137c57cb6`.
Finally, `./verify.sh safe` completed the entire PrismStudio surface with
`failures:0`, including `outline`; hardware GPU suites remained explicitly
`not-run`.

## ZNC-3 — resolved: deterministic GFX10.1 kernel bundles

**Original gap (2026-07-13):** the self-hosted compiler's AMD path stopped at
generic ROCDL MLIR and emitted no directly consumable GFX10.1 code or resource
metadata.

**Upstream fix:** `znc --target amdgpu-gfx1010` accepts deliberately narrow,
bounded `[]i32` fill, depth-write, and depth-tested packed-RGB blend profiles and emits deterministic versioned `ZGK1`
bundle. Its metadata includes architecture, entry offset, user/system SGPRs,
VGPRs, LDS, scratch, wave size, local workgroup, RSRC1/RSRC2, code size, and code
hash. The compiler owns both instruction encoding and an independent decoder/
validator; bundle emission refuses disagreement. Unsupported AST forms, loops,
unsafe pointers, host effects, address-space ambiguity, and instruction mutation
fail closed.

**Integration and evidence:** `build.sh` compiles all three kernel sources;
`gpu_kernel_load` validates each bundle and fixed review manifest; PM4 dispatch
consumes compiler metadata. Production compute/raster and virtual campaigns no
longer import handwritten opcodes. Zag also owns a
strict virtual GFX10.1 command processor (`std/gfx1010_vm.zag`): it decodes the
complete 7/15/59-instruction profiles and PrismStudio's real PM4 register
stream, checks resource metadata/reserved bits/virtual addresses, and executes
against bounded virtual GPU memory. `gpu-isa-raster` proves tiled clear,
geometry, signed depth, clipping, and alpha compositing match an independent CPU
oracle, including 64 seeded randomized scenes, incomplete-frame retention, and
mismatch fallback/evidence. A separate varied campaign retires one million ISA
workgroups / seven million decoded instructions through 1,000 explicit
CPU-to-device-to-CPU ownership transfers and monotonic fences. Zag's
`native-gpu`, `gfx1010-vm`, native, AArch64, bootstrap,
and source-authority gates pass. Actual silicon execution and raster promotion
remain hardware-gated and are not implied by these software results.

## ZNC-4 — resolved: native `continue` control flow

**Original gap (2026-07-13):** PrismStudio's affected-region optimizer used the
ordinary `continue;` statement documented by the Zag v1 language specification,
but `znc` tokenized it as an identifier and rejected the program. Rewriting the
loop with flags would have hidden a language defect in the consumer.

**Upstream fix:** Zag now recognizes, parses, clones, semantically walks, and
lowers `continue` as a first-class statement. Both x86-64 and AArch64 native
backends maintain independent innermost-loop continue targets; the AArch64 audit
also closed its missing `break` lowering. Nested-loop regressions prove that each
statement targets the correct loop. The supported compiler rebuilt itself to the
fixed point above with no C, Zig, or consumer workaround.

**Evidence:** Zag native passes 132/132 with `continue nested`, AArch64 passes
99/99 with nested `continue` and `break`, native authority passes 7/7, and the
stage-1/2/3 compiler artifacts are byte-identical. PrismStudio then compiles its
unchanged region-filtering loop and passes `optimizer-families` and
`optimizer-schedule`.

## ZNC-5 — resolved: compiler-owned standard imports

**Original gap (2026-07-14):** a reusable Zag GPU VM could only be consumed by
repository-relative source paths. Importing transitive allocator modules from
different project/stdlib paths also exposed duplicate flat namespaces.

**Upstream fix:** `@import("std:name")` now resolves from the standard library
shipped beside `znc` (or `/usr/local/lib/zag/std` for installed compilers), never
from a project-local shadow directory. Names are restricted and traversal is
rejected. `make install` installs the pure-Zag standard library with the compiler.
The VM API accepts caller-owned bounded memory and therefore carries no allocator
dependency into consumers.

**Evidence:** `test-std-namespace` compiles from an unrelated `/tmp` project and
rejects `std:../escape`; PrismStudio consumes `std:gfx1010_vm`; native authority
passes 7/7 and the stage-1/2/3 compiler fixed point is byte-identical at
`9a449bc5f5572964cc21035f0e4acb376f1f0aeb73246cfb844effa487c33a8b`.

## ZNC-6 — resolved: named checked GFX10.1 instruction encoding

**Original gap (2026-07-14):** the restricted backend correctly kept machine
code out of PrismStudio, but its compiler emitter still assembled the reviewed
fill program from opaque whole-instruction numeric literals.

**Upstream fix:** Zag now constructs its scalar/vector moves, shifts, masks,
integer multiply/add/or, signed comparison/branch, global load/store, wait, and
end instructions through named backend encoders.
VGPR, SGPR, and inline-immediate operands are checked before field placement;
invalid fields fail closed. The semantic validator derives the expected program
through the same named API, while an independent golden freezes the exact bytes.

**Evidence:** the ZGK1 bundle stayed byte-for-byte stable; `gfx1010-vm` and
`native-gpu` pass, native passes 132/132, AArch64 passes 99/99, authority passes
7/7, and the stage-1/2/3 compiler fixed point is byte-identical at
`9a449bc5f5572964cc21035f0e4acb376f1f0aeb73246cfb844effa487c33a8b`.

## ZNC-7 — resolved: decoded raster profiles and parallel-safe target gates

**Original gaps (2026-07-14):** direct ISA covered only fills, so Prism could not
exercise real depth or alpha instructions without hardware. Independently, the
x86 and AArch64 release suites shared `nt_src.zag`, `/tmp/znc_drv`, and result
paths; concurrent execution silently cross-compiled some cases and produced
false failures or potentially false greens.

**Upstream fix:** the compiler recognizes exact reviewed depth-write and
depth-tested `@gpuBlend` ASTs and emits named GFX10.1 instruction sequences. The
independent VM freezes and validates every emitted word, decodes seven user
SGPRs, performs signed depth comparison and fixed-point alpha 0..256, bounds both
buffers, and preserves explicit release/submit/acquire fences. The native target
harnesses now own PID-scoped compiler, binary, log, and target-specific source
paths while keeping source files at the repository root for correct relative
imports.

**Evidence:** `gfx1010-vm` passes 22/22; Prism's `gpu-isa-raster` passes its
golden scene, 64 randomized scenes, canaries, monotonic per-tile fences,
incomplete-frame retention, exact color/depth comparison, mismatch capture, and
CPU fallback. `gpu-compiler-direct-isa` proves all three bundles deterministic
without making ROCDL/MLIR part of the production gate. Zag native passes 132/132,
AArch64 99/99, differential 57/57, native authority 7/7, and bootstrap 6/6 at
`feeceec3af7d3d2c9036c5aa4deb5ddb4974e3ec6f031d10c6281ab1dcf15b5e`.

## ZNC-8 — resolved: evidence-first GPU standard library

**Original gap (2026-07-14):** consumers had low-level VM results, tuple structs,
and local campaign loops, but each application still had to invent its own
promotion thresholds, error explanations, checkpoint format, and refusal UI.
That made correct low-level use harder than it needed to be and risked policy
drift between tests and applications.

**Upstream fix:** compiler-owned `std:gpu` now supplies an exact device, GFX and
compute HW-IP, IP-discovery revision, ring-mask, MEC/SDMA firmware, kernel,
compiler, and runtime tuple, complete physical certification and benefit
records, one fail-closed automatic-promotion decision, stable denial codes,
plain-language reason and next-action fields, named VM errors with detailed
counters and hints, and a versioned corruption-checked resumable campaign state.
The API is pure Zag and builds on `std:gfx1010_vm`; it uses no C, Zig, LLVM,
Mesa, vendor runtime, or sidecar scripting language.

**Evidence:** Zag's `test-gpu-std` covers all promotion boundaries, anomaly
quarantine, performance evidence, diagnostics, exact resume, and corrupt-state
rejection. Prism's `gpu-promotion-policy` consumes the installed-style
`@import("std:gpu")` namespace. `zagpa --gpu-cert-status` performs a read-only
live fingerprint and reports the precise current refusal without allocating a
buffer or creating a command queue. The raster gate additionally retires one
million decoded blend/depth dispatches and 59 million instruction executions.
The API also exposes named virtual, memory-only, bounded-physical, and
destructive tiers. A regression proves that watchdog recovery and process-state
cleanup never promote a display GPU into an independent reset domain. Follow-up
regressions prove that either a ring-mask change or an IP-discovery revision
change invalidates the exact certification tuple. Current source authority is
7/7, bootstrap reproducibility is 6/6 at
`4f4a7eee5e11aeee5e24c37c7e80d81a8ec21d267259f9eb6002eec868a12dbd`,
native is 132/132, and AArch64 is 99/99.

The API now also owns a separate `ZagGpuVirtualCertification` contract. It
requires manifest and ownership proof, 10,000 fills/transfers, one million real
VM submissions, 86,400 logical soak ticks, raster differentials, and zero
anomalies. Success uses virtual-only code 100 and the type cannot be passed to
`zag_gpu_auto_decide`, preventing a consumer from accidentally promoting virtual
evidence into a physical-hardware claim.

Zag also owns backend selection as reusable policy rather than a compiler
mandate: `auto`, `cpu`, `virtual`, and `physical` are all first-class choices.
The safe `auto` policy promotes physical execution only for certified,
reset-isolated hardware; explicit CPU and virtual choices require no device
probe. Prism's `gpu-backend-choice` regression proves all four boundaries and
stable refusal codes.

Zag now additionally owns the compiler/runtime/driver boundary in
`std:gpu_platform`. Prism imports that contract directly: its production target
is custom Zag `amdgpu-gfx1010` ZGK1/RDNA1 code over the existing Linux AMDGPU
UAPI. Planned custom Zag SPIR-V/Vulkan, PTX/CUDA-driver, and Intel SPIR-V paths
remain represented but fail closed until their compiler and runtime halves are
implemented. MLIR is differential-only and cannot become a silent production
fallback. Privileged kernel drivers, firmware, display, PCIe, power, interrupt,
and reset handling remain the explicit implementation ceiling.

## ZNC-8 — resolved: generic wrappers in typed call results

**Original symptom (2026-07-15):** adding the backend policy module to the full
PrismStudio import graph made the typed authority report `?i32` versus `?V` for
explicit calls such as `int_get[i32]`, even though the same code lowered and ran
correctly in a smaller graph.

**Upstream fix:** Zag's shared typed front end now substitutes explicit generic
arguments recursively through pointer, optional, error-union, slice, and nested
generic type spellings before checking call parameters and results. The fix is
in Zag source; PrismStudio contains no import-order or cast workaround.

**Evidence:** `run_typed_authority.sh` executes a generic `?V` result specialized
as `?i32`, and the full `src/main.zag` graph compiles with the rebuilt self-hosted
compiler.
