# PrismStudio 1.0 Release Evidence Index

Date: 2026-07-13. Scope: CPU/X11 1.0. Experimental AMDGPU and GPU raster
promotion are reported separately and are not silently counted as release proof.

Current aggregate result: `./verify.sh safe` ran the complete safe surface and
reported `failures:0`, including the former `outline` compiler-crash reproducer,
live X11 self-tests, and identified X11 captures. Real GPU
memory/submit/compute suites were intentionally `not-run` because this machine
does not provide a separate non-display certification device.

## Checkbox-to-evidence mapping

`masterplan.md` is the canonical item-level index: every checked checkbox must
carry an `Evidence:` clause before the next checkbox, enforced by the
`masterplan-evidence` gate. The table below groups those item-level references
into the release surfaces used for the final decision.

| Checklist surface | Evidence |
|---|---|
| Ground truth, inventory, numbers, claims | `inventory-audit`, `probe-manifest-audit`, `docs/NUMERIC_CONSTANT_AUDIT.md`, `docs/CLAIMS_AUDIT.md`, `evidence/baseline-2026-07-13.md` |
| Physical model and reference substrate | `model-schema-migration`, `provenance-units`, `reference-tamper` |
| Project compatibility and route preservation | `engine`, `persistence`, `session-conflict`, `agent-revision-conflict` |
| Reference PCU construction and verification | `flash-photonic`, `reference-tamper`, `deterministic-trace`, maintained exports |
| Visible UI inspection and edit lifecycle | `reference-pcu-ui`, `ui-interactions`, `recovery-ui`, `x11-live`, `x11-captures` |
| CPU rendering, performance, and soak | `render-golden`, `frame-diff`, `ui-perf`, `soak`, `bench`, `evidence/soak-samples.csv` |
| Automation, permissions, conflicts, recovery | agent/MCP gate families, `crash-recovery`, `recovery-ui`, `session-conflict` |
| Photon Solver verified families | `optimizer`, `optimizer-verify`, `optimizer-report`, `optimizer-schedule`, `optimizer-soak` |
| GPU software safety boundary | `gpu-uapi`, `gpu-query`, `gpu-safety`, `gpu-backend-choice`, `gpu-kernel-manifest`, `gpu-isa-vgpu`, `gpu-isa-display`, `gpu-isa-raster`, `gpu-vgpu`, `gpu-virtual-certification`, `gpu-raster-shadow`, `gpu-raster-pipeline`, `gpu-compiler-direct-isa` |
| Product compatibility status | `evidence/compatibility-report.md`, generated `evidence/bench-report.md` |

## Experimental status and exact blockers

| Item | Status | Resolution required |
|---|---|---|
| Deterministic `znc` output | resolved upstream and verified | Exact-width byte operations and frame high-water hardening landed in sibling Zag; fixed-point bootstrap, 16 concurrent reproducer compiles, the guard-page regression, and full Prism safe gate pass. See `docs/UPSTREAM_ZAG.md`. |
| Native `amdgpu-gfx1010` code and metadata | resolved upstream and integrated | Self-hosted `znc` emits deterministic validated `ZGK1` bundles; production fill consumes compiler metadata. Actual silicon execution remains unrun. |
| Display-safe GFX10.1 execution | resolved upstream and integrated | Zag's strict virtual command processor decodes ZGK1 instructions plus PrismStudio's real PM4 register stream, executes bounded virtual GPU memory, rejects reserved bits/register/VA violations, and archives virtual framebuffers. `zagpa --gpu-virtual-display` exposes the backend without DRM. This is executable software evidence, not silicon certification. |
| AMDGPU synchronization/BO/fence/syncobj/VM/cache substrate | implemented, software-validated | BO lists, user fences, syncobj timelines, ordered VA maps, memory-sync IB flags, and CPU/device ownership fences pass `gpu-uapi`; hardware validation remains unrun. |
| Full compiler-owned GPU raster pipeline | partial software substrate | `gpu-raster-pipeline` proves bounded tiled clear/geometry/depth/clipping/compositing/presentation, per-tile fences, randomized CPU-oracle equality, atomic double buffering, and one million software tile dispatches. Compiler-emitted raster kernels and real submission remain incomplete. |
| Destructive and long GPU certification | blocked by hardware | Provide a separate non-display supported GPU; the RX 5700 XT is the sole display GPU and `/dev/dri` is unavailable in this run. |
| Five Photon Solver rewrite families | implemented, software-validated | `optimizer` and `optimizer-families` prove CSE, factoring, route consolidation, placement balancing, and constant-source strength reduction through exact trace/cost/validity checks and transactional undo/redo. |
| Incremental optimizer region work queue | implemented, software-validated | Changed IDs plus one-hop neighbors constrain candidate scans; family, affected-component, and placement-direction cursors resume across idle slices and persist across reopen (`optimizer-schedule`). |
| Strict intra-family optimizer deadline | implemented, software-validated | Structural discovery is separated from proof; the exact oracle retains its candidate and both simulators across bounded symbol/deadline slices and a v4 campaign plus proof checkpoint restores the exact symbol after reopen. A maintained 384-component reference PCU campaign completed 2,304 slices; preflight runs observed at most 5 ms and the final safe run measured 4 ms against the 8 ms limit (`optimizer-schedule`). |
| Battery/thermal scheduler backoff | implemented | Linux battery capacity/status and thermal-zone inputs suppress speculative work; forced-pressure, interaction, and active-simulation regressions pass. |

No blocked or incomplete item above is represented as completed in
`masterplan.md`.
