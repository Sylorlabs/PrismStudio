# Triton

Triton is an experimental, pure-Zag CAD and deterministic simulation environment
for spatial balanced-ternary optical processor designs. It currently provides a
native X11 workbench, CPU reference renderer, voxel design-rule engine, 3D
waveguide router, symbolic/phase-aware simulator, project persistence, undo/redo,
a continuous background optimizer that proposes equivalence-verified
simplifications, and native line/MCP automation.
Flash hardware IR (`.fir`) can be imported as a real routed photonic design and
verified against the compiler-recorded balanced-ternary results.

The workbench is a token-driven dark UI drawn entirely by Triton's own
renderer: a searchable component-card library with category tabs and
drag-into-viewport placement, an inspector with journaled numeric fields
(steppers, precise typing, units, inline validation), a filterable outliner
with lock/visibility toggles and warning badges, a zoomable/scrubbable signal
timeline with pin/hide and 3D cross-highlight, a measure tool, grid/object/
port snapping with pre-commit snap targets, right-click context menus, object
grouping, inline rename, a section view, tooltips, reduced-motion mode, and a
clickable design-warnings list. Side panels render into retained surfaces and
redraw only when their displayed state changes; interaction budgets are
enforced by the `ui-perf` verification gate rather than asserted here.

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

Native agents default to `read,inspect,simulate`. Mutation, save, export, local
execution, and admin operations require an explicit `TRITON_CAPS` grant. The
generated local MCP configuration grants `all` deliberately and identifies its
actor; deployments should narrow that value. Requests and denials are appended
to `.triton/audit.log` (or `TRITON_AUDIT`).

Project mutations use `request <idempotency-key> <expected-revision> <command>`.
`zagctl` creates this envelope automatically using the current revision; set
`TRITON_IDEMPOTENCY` to a stable caller key when retrying. MCP clients use the
advertised `triton_mutate` tool or a specialized mutation tool whose schema
requires `idempotency_key` and `expected_revision`. Successful results include
revision, idempotency key, affected ID, and undo token. Unkeyed mutations are
rejected. MCP component arguments use `component_id` to avoid colliding with the
JSON-RPC request `id`.

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

## Continuous optimizer (Photon Solver)

Triton runs a lightweight background optimizer that continuously searches for
mathematically-equivalent, cheaper ways to compute the same optical result — it
changes how a design computes, never what it computes. Every proposal is verified
output-equivalent against the reference simulation (identical detector trits at
every symbol over a bounded horizon) before it is ever shown, and re-verified
again at apply time.

Two rewrite families are implemented today: dead-path elimination (removing
components that cannot affect any detector) and constant-op collapse (folding a
constant-driven multiply or nand chamber to a negate). The optimizer surfaces a
single Optimizer button whose count updates silently; its panel offers Apply,
Ignore, and Details with the measured cost delta. Auto-apply is a Settings toggle
that is off by default. Applying an optimization — manually or automatically — is
a single undo and is written to the audit log with the rewrite family and measured
gain. The optimizer runs off the interaction path and never mutates a project
while auto-apply is off. Behavior is covered by the `optimizer` and `optimizer-ui`
safe-gate suites.

## Project structure

```text
src/main.zag          native X11, headless, agent, and MCP entry point
src/device_model.zag  versioned physical inputs and provenance classes
src/scene.zag         components, ports, occupancy, and optical graph
src/routing.zag       deterministic 3D waveguide router
src/sim.zag           balanced-ternary symbolic/physical simulation
src/optimizer.zag     continuous equivalence-verified optimizer (Section 20)
src/editops.zag       transactional edits, undo/redo, and project format
src/viewport.zag      CPU 3D reference renderer and picking
src/x11.zag           direct X11 wire-protocol client
src/gpu_rt.zag        opt-in direct AMDGPU research runtime
tools/verify.zag      pure-Zag verification orchestrator
evidence/             master-plan ledger and release evidence index
```

The complete implementation and acceptance contract is in `masterplan.md`.
Unchecked items are incomplete regardless of whether a narrower test passes.
Project format, model evidence, agent/MCP contracts, and recovery behavior are
documented in `docs/FORMATS_AUTOMATION_RECOVERY.md`. Reference PCU reproduction
steps are documented in `docs/REPRODUCE_REFERENCE_PCU.md`. Verified release notes
are in `docs/RELEASE_NOTES.md`.
