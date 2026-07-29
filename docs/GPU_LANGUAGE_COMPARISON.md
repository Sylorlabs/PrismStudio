# GPU language and API capability comparison

Snapshot: 2026-07-14. This compares supported, documented behavior—not syntax
preference or hypothetical backends. A check means the capability is available
in the named stack today; “partial” means constrained, implementation-dependent,
or not yet hardware-certified.

| Capability | Zag + Prism | CUDA | HIP | SYCL | Vulkan/SPIR-V | Rust `wgpu` | Zig |
|---|---|---|---|---|---|---|---|
| One language for native CPU and authored GPU kernels | Yes | C++ host/device | C++ host/device | C++ single-source | No; API + shader IR/language | Rust host; WGSL/SPIR-V shaders | Partial; AMDGCN targets exist, no documented single-source GPU model |
| Direct compiler-owned AMD GFX ISA bundle | **Yes, best control; restricted GFX10.1 profiles** | No, NVIDIA stack | Toolchain-owned AMD code object | Backend-dependent | SPIR-V, not vendor ISA | Backend-dependent | Partial target support; not a documented stable GPU-kernel contract |
| Production path requires no C, libc, LLVM, Mesa, or vendor user runtime | **Yes in the current virtual/direct-ISA path** | No | No | Implementation-dependent | No language runtime, but requires Vulkan loader/driver | No; depends on backend/driver crates | CPU targets vary by support tier; GPU path not established here |
| Cross-vendor production GPU execution | No; AMD GFX10.1 only | NVIDIA only | AMD with portability support | Yes, backend-dependent | **Yes, best low-level portability** | **Yes, best safe high-level portability** | Partial/experimental target list |
| Mature production compute ecosystem and libraries | No | **Best for NVIDIA** | **Best for AMD C++ portability** | Strong portable C++ model | Strong low-level compute API | Growing safe Rust ecosystem | No official GPU ecosystem comparable to these |
| Mature hardware raster/presentation API | No; virtual raster preflight only | Compute/interoperability, not a raster API | Compute/interoperability, not a raster API | Compute model, not a raster API | **Best explicit raster/presentation control** | **Best safe portable raster API** | No official raster API |
| Deterministic executable virtual GPU that decodes the exact production ISA | **Yes; unique in this comparison** | No equivalent in core CUDA | No equivalent in core HIP | No equivalent in the specification | Validation layers do not execute vendor ISA | No-op backend does not execute render/compute | No documented equivalent |
| CPU oracle, complete-frame equality, mismatch artifacts, automatic fallback | **Yes for Prism's decoded-ISA raster** | Application responsibility | Application responsibility | Application responsibility | Application responsibility | Application responsibility | Application responsibility |
| Explicit ownership, monotonic fences, fail-closed unknown packets/ISA | **Yes for reviewed profiles** | Runtime/driver synchronization | Runtime/driver synchronization | Event/dependency model | **Yes, broadest standardized explicit control** | Safe abstraction over backend synchronization | Application/backend dependent |
| Built-in evidence-gated auto-promotion with exact tuple invalidation | **Yes; stable reason + next action + counters** | Application responsibility | Application responsibility | Application responsibility | Application responsibility | Application responsibility | No documented equivalent |
| Resumable corruption-checked certification campaign state | **Yes in `std:gpu`** | Application/tool responsibility | Application/tool responsibility | Application/tool responsibility | Application/tool responsibility | Application/tool responsibility | No documented GPU-specific equivalent |
| One-command read-only tuple and refusal diagnostics | **Yes; `--gpu-cert-status`** | Mature vendor tools, different policy | Mature vendor tools, different policy | Backend tools | Validation/vendor tools | Backend tools | General compiler diagnostics only |
| Execution capability separates virtual, memory-only, bounded physical, destructive | **Yes; fail-closed in `std:gpu`** | API/application policy | API/application policy | Backend/application policy | Application policy | Backend/application policy | No documented GPU-specific equivalent |
| Language/API memory safety | Bounds/effect checks, but still young | C++-level | C++-level | C++-level | Explicit API; validation is not memory safety | **Best host API safety** | Strong safety checks in safe modes; manual memory model |
| Hardware fault/reset isolation guaranteed by the language | No | No | No | No | No | No | No |
| Current production hardware certification breadth | Not yet; VM only | **Very broad NVIDIA** | **Broad AMD** | Depends on implementation/device | **Broad multi-vendor** | Broad through native/web backends | GPU support is not comparably certified |

## Who is best at what

- **Zag is currently best at auditable end-to-end control for this one narrow
  target:** pure-language kernel compilation, exact GFX10.1 bytes, independent
  full-word decoding, bounded virtual execution, CPU shadow comparison, evidence
  capture, and fail-closed promotion are one coherent stack.
- **Vulkan/SPIR-V is best for standardized low-level multi-vendor graphics and
  explicit synchronization.** SPIR-V is a portable intermediate language, not a
  promise of identical vendor machine code.
- **`wgpu` is best for a memory-safe, portable Rust graphics API.** Its no-op
  backend can test resource-management code, but officially does not execute
  render or compute passes, so it is not equivalent to Zag's ISA VM.
- **CUDA is best for NVIDIA production compute maturity, libraries, tooling, and
  deployed hardware coverage.** HIP is the closest AMD-oriented C++ compute
  counterpart; SYCL is the strongest standardized single-source C++ portability
  model.
- **Zig is a stronger established general-purpose systems language today.** Its
  official target table lists AMDGCN variants, but the official language and
  platform docs do not define a comparable reviewed kernel profile, strict
  executable GPU VM, or raster promotion contract. Zag leads those narrow GPU
  controls, not overall language maturity.

For this project, Zag is now easier to use at the dangerous boundary than raw
PM4, DRM, or a generic language binding: callers receive a decision record rather
than reconstructing policy from error codes, campaigns checkpoint without a side
language, and `--gpu-cert-status` prints the exact live tuple, refusal reason, and
next admissible action without touching a submission queue. This is a concrete
ergonomics lead for the narrow audited workflow, not a claim that Zag has the
ecosystem or hardware breadth of CUDA, Vulkan, HIP, SYCL, `wgpu`, or Zig.

Zag deliberately refuses to call a userspace deadline, cleaner shader, GPUVM,
or virtual display a reset boundary. `std:gpu` admits exact-ISA virtual execution
on caller-owned host memory and admits GPU-visible memory when the instruction
count is zero. Physical shader execution defaults to independently resettable
hardware; an informed user can explicitly acknowledge shared-display reset or
system-hang risk for a bounded manual run. That override is labeled uncontained
and can never satisfy certification, automatic promotion, or destructive gates.

## The isolation boundary

No programming language can turn a display-bound physical GPU into an
independent reset domain. GPU virtual addresses, queues, contexts, virtual
displays, validation, and watchdogs reduce software mistakes but cannot contain
firmware or whole-device hangs. Zag's advantage is refusing physical submission
unless Linux proves an SR-IOV VF, IOMMU group, and FLR reset support; that policy
prevents an unsupported test, but it does not manufacture hardware isolation.

## Primary references

- [AMD RDNA shader ISA](https://docs.amd.com/v/u/en-US/rdna-shader-instruction-set-architecture)
- [CUDA programming model](https://docs.nvidia.com/cuda/cuda-programming-guide/01-introduction/programming-model.html)
- [HIP programming model](https://rocm.docs.amd.com/projects/HIP/en/docs-7.1.0/understand/programming_model.html)
- [SYCL 2020 specification](https://registry.khronos.org/SYCL/specs/sycl-2020/html/sycl-2020.html)
- [Vulkan specification](https://registry.khronos.org/vulkan/specs/latest/html/vkspec.html)
- [SPIR-V registry and unified specification](https://registry.khronos.org/SPIR-V/)
- [`wgpu` API documentation](https://docs.rs/wgpu/latest/wgpu/)
- [Zig platform support](https://ziglang.org/learn/platform-support/)
- [Zig language reference](https://ziglang.org/documentation/master/)
