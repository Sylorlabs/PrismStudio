# Triton

Triton is an experimental, pure-Zag CAD and deterministic simulation environment
for spatial balanced-ternary optical processor designs. It currently provides a
native X11 workbench, CPU reference renderer, voxel design-rule engine, 3D
waveguide router, symbolic/phase-aware simulator, project persistence, undo/redo,
and native line/MCP automation.
Flash hardware IR (`.fir`) can be imported as a real routed photonic design and
verified against the compiler-recorded balanced-ternary results.

Triton is software for design-model verification. It does not claim that the
illustrative reference device has been fabricated, measured, or laboratory
validated. Physical values shown by the bundled example model are labeled
`Illustrative`; an incomplete model is reported as unknown and cannot produce a
verified simulation.

## Supported build and verification

The supported compiler is the sibling Zag checkout's self-hosted native compiler.
No C compiler, libc, Xlib, Mesa, LLVM, or Python service is used by Triton.

```bash
./build.sh             # production binary plus safe CPU/X11 checks
./verify.sh safe       # all safe suites with JSON result records
./verify.sh release    # requires a real X11 session
./run.sh               # native X11 workbench
./zagctl repl          # native line protocol
./zagctl mcp           # native MCP server
./zagctl flash import ../flash/examples/photonic_massive.fir
```

Set `ZNC=/absolute/path/to/znc` to override the default
`../zag/zag-poc/znc`. The current environment and exact compiler hash used for
release evidence are recorded in `evidence/progress-ledger.md`.

## Evidence levels

- `Illustrative`: bundled reference-model input used to test software behavior.
- `User-entered`: a project value supplied without independent validation.
- `Simulated`: derived by the deterministic software model.
- `Literature-derived`: tied to a cited source and version.
- `Measured`: imported measurement with date, method, uncertainty, and source.
- `Unknown`: unavailable; Triton does not invent a replacement.

Board timing is derived from the selected model's component response parameters,
routed geometry, and material group index. No frequency is a universal Triton
constant.

## Rendering and GPU status

The production viewport uses the CPU renderer as its permanent reference and
fallback. A direct AMDGPU research runtime exists, but it is experimental and
never runs in the default build or viewport. GPU memory access and command
submission are separate explicit verification modes. They are not certified on
the current single-GPU display system, and no GPU performance claim is made.

## Project structure

```text
src/main.zag          native X11, headless, agent, and MCP entry point
src/device_model.zag  versioned physical inputs and provenance classes
src/scene.zag         components, ports, occupancy, and optical graph
src/routing.zag       deterministic 3D waveguide router
src/sim.zag           balanced-ternary symbolic/physical simulation
src/editops.zag       transactional edits, undo/redo, and project format
src/viewport.zag      CPU 3D reference renderer and picking
src/x11.zag           direct X11 wire-protocol client
src/gpu_rt.zag        opt-in direct AMDGPU research runtime
tools/verify.zag      pure-Zag verification orchestrator
evidence/             master-plan ledger and release evidence index
```

The complete implementation and acceptance contract is in `masterplan.md`.
Unchecked items are incomplete regardless of whether a narrower test passes.
