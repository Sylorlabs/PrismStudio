# Upstream znc compiler work

Triton is written entirely in Zag and compiled by `znc` (the self-hosted native
compiler in `../zag/zag-poc`). Building it surfaced real gaps and bugs in `znc`
itself. Per the project rule — **fix Zag capability gaps in the compiler, never
work around them in the app** — each was fixed upstream. Every change below
preserves the self-hosting fixpoint (`znc` compiles itself to a byte-identical
binary) and passes the differential x86/arm64 suite.

## Real heap allocator (`selfhost/native/ncodegen.zag`, `elf.zag`)

The native runtime's `_zag_free` was a documented no-op and `_zag_malloc` was a
bump allocator over an mmap arena — fine for short-lived compiles, a leak for a
long-running interactive app that places/removes thousands of components and
auto-saves on a loop.

Replaced with a real allocator:

- **Segregated free lists** (size classes 16 B … 512 KiB) carved from 1 MiB
  mmap arenas, with an 8-byte size header per block so `realloc`/`free` know the
  class. Large requests get a dedicated mmap; `free` returns small blocks to
  their class list and `munmap`s large ones.
- A third **writable BSS `PT_LOAD` segment** (added to the 2-segment ELF writer,
  now `HDRS3`/3 program headers) holds the allocator's free-list heads and arena
  cursor at a fixed virtual address.
- `_zag_realloc` now allocates + copies + frees the old block instead of
  leaking it; `new(T)` and slice-result allocations route through the header'd
  allocator so `delete()` can reclaim them.
- New `_zag_str_free(slice)` extern frees a heap string's data buffer (used by
  triton for `Comp.name_` and transient `_zag_str_concat` results).
- Fixed a latent bug: `_zag_getenv` was missing from the runtime allocation
  dependency closure.

Word-at-a-time `_zag_memcpy` (was one byte per loop with a push/pop-heavy
store-byte call per byte) — memcpy is on the hot path of every tile-cache blit.

## Hex integer literals (`lex.zag`, `ncodegen.zag`, `acodegen.zag`)

`znc` had no `0x…` literals, so ioctl encodings had to be hand-converted to
decimal — and a single mistyped digit silently becomes a *different* ioctl
(`-ENOTTY`), which is exactly the bug that first cost time in `src/gpu_rt.zag`.
Added `0x`/`0X` hex lexing plus base-16 parsing in both the x86 and arm64 int
literal paths (kept in lockstep so the differential suite stays green).

## Where the GPU runtime lives

`src/gpu_rt.zag` and `src/rdna.zag` are the whole GPU stack — no libdrm, no
Mesa, no LLVM, no C — driving the kernel's `amdgpu` DRM device through the
`_zag_raw_syscall` intrinsic:

- **device**: open `/dev/dri/renderD128`, `DRM_IOCTL_VERSION` +
  `AMDGPU_INFO_DEV_INFO` query, GEM buffer alloc + mmap.
- **submission**: GPU context (`AMDGPU_CTX`), GPU virtual-address mapping
  (`AMDGPU_GEM_VA`), command-buffer submission (`AMDGPU_CS`) with PM4 packets,
  fence wait (`AMDGPU_WAIT_CS`, bounded timeout so a bad submit can't wedge).
- **ISA**: `src/rdna.zag` is a hand-written RDNA1 (GFX10.1) machine-code emitter
  — each instruction assembled from its microcode field layout, and each opcode
  confirmed against known inputs on live hardware one dispatch at a time (this
  matters: a blind opcode sweep once hung the GPU and crashed the desktop —
  never do that on the display adapter). `probe/gpu_compute_test` /
  `gpu_parallel_test` verify what the shader cores wrote.

- **Reliability**: single small dispatches are correct and reliable; large grids
  (thousands of workgroups) are intermittently unreliable with this minimal
  submission (stale reads / fence timeouts) because it doesn't replicate the
  cache-management and sync a real driver emits. GPU compute is therefore
  experimental and opt-in (`TRITON_GPU_DISPATCH=1`), never on the render path,
  and the interactive app stays on the (fast, un-hangable) CPU rasterizer.

The ioctl encodings were built from the `_IOC(dir,type,nr,size)` components
(not pre-baked decimals) and the register offsets / struct layouts taken from
the stable uapi headers — the same "read the spec, encode it ourselves"
approach used everywhere else in the runtime.
