# Master Plan Progress Ledger

Environment snapshot (2026-07-07): Triton starting commit `1e83207`; Zag
starting commit `807c03d`; compiler SHA-256
`713f3b60dfa07a6e8f2683a06de854ec40de495469a4b9cf0f3a03c40ba5eed6`;
Linux `7.0.11-76070011-generic`; x86-64; X11 `:0`; PowerColor Radeon RX 5700 XT
is the only GPU and drives the display.

| Item | State | Change / evidence | Last result | Next |
|---|---|---|---|---|
| A.inventory | pass | `rg --files`; source/probe/tool inventory recorded during baseline | 69 Zag/Python modules plus scripts/docs identified | Keep updated in evidence index |
| A.compiler | pass | `../zag/zag-poc/znc`, sibling Git commit `807c03d`, SHA above | Supported self-hosted compiler identified | Re-record at release |
| A.single-test-entry | pass | `verify.sh`, `tools/verify.zag` | Pure-Zag orchestrator emits JSON result records | Run safe gate |
| A.baseline-engine | pass | `./verify.sh safe`; `probe/engine_test.zag` | 61 assertions passed after replacing a stale user-specific temp path | Expand persistence fault coverage |
| A.gpu-default-safety | pass | `build.sh`, `tools/verify.zag` | GPU memory and dispatch probes are explicit modes; default does not touch DRM | Keep GPU opt-in |
| B.versioned-model | pass | `src/device_model.zag`; `probe/engine_test.zag` | Schema v1 carries units, source, method, date, uncertainty, confidence, and known state | Expand per-component bindings |
| B.derived-timing | pass | `changing device model changes derived timing without source edit` | Runtime model-rate change altered compiled symbol clock | Add dimensional property coverage |
| B.incomplete-model | pass | `incomplete model cannot silently advance verified simulation` | Missing group index sets `model_ok=false` and blocks stepping | Expose complete diagnostics in agent/UI |
| B.model-roundtrip | pass | `roundtrip: device model version pinned`; `physical model values preserved` | Project format v2 preserved schema and physical inputs | Add corruption/migration fixtures |
| B.claim-cleanup | pass | `README.md`; `tools/verify.zag` unsupported-claim audit | README separates illustrative, simulated, measured, and unknown evidence | Extend audit allowlist and generated evidence |
| E.native-automation | pass | native `--agent`, `--mcp`, `zagctl`; legacy Python client removed | Supported automation path is compiled Zag | Add capability enforcement |
| E.flash-fir-import | pass | `flash import`; `src/flash_ir.zag`; `./verify.sh safe` | Flash FIR v1 maps to production components/routes without executing host code | Add UI import dialog and trace panel |
| C.massive-flash-pcu | pass | `../flash/examples/photonic_massive.flash`; `flash-photonic` gate | 64 ops became 384 components including 64 memory tiles and 192 routed guides; zero detector mismatches | Extend all-vector oracle coverage |
| D.flash-ternary-ops | pass | chamber lattice ops 2/3/5/7; constant-trit emitters | Flash neg/add/mul/nand semantics and exhaustive truth tables pass | Add larger composed-network oracle |
| D.simulation-modes | pass | `SimMode.Functional`, `SimMode.Physical`; `simulation-properties` | Functional behavior is independent of missing physical data; physical mode rejects it | Add deterministic trace capture |
| D.property-oracle | pass | `probe/simulation_property_test.zag`; `simulation-properties` | Exhaustive Flash truth tables, explicit invalid states, delay linearity/rate monotonicity all pass | Add graph differential/metamorphic suites |
| D.deterministic-trace | pass | `trace`; `examples/flash_photonic_massive.trace.txt`; `deterministic-trace` | Two fresh 32-symbol massive-PCU traces match each other and the golden bytes | Add trace viewer and breakpoints |
| D.incremental-differential | pass | `simulation-properties`; independent save/reload/full compile | Every node history and guide ring matches incremental recomputation before/after 24 further symbols | Add translation/equivalent-route metamorphic cases |
| G.flash-roundtrip | pass | `examples/flash_photonic_massive.zpa`, save/reopen verify | Canonical project matches a fresh public-interface reconstruction byte-for-byte | Keep comparison in the safe gate |
| G.deterministic-exports | pass | `examples/flash_photonic_massive.{bom,netlist,models,report}.txt`; `flash-photonic` | Regenerated project and all four exports compare byte-for-byte with maintained artifacts | Add render pixel-diff gate |
| G.atomic-save | pass | `atomic_write_file`; engine failure injection | temp write, file fsync, close, rename; failed rename retained destination and removed temp | Add parent-directory fsync and crash-stage matrix |
| G.corruption | pass | project v2 checksum; `corrupt project checksum rejected` | Modified project byte rejected before scene mutation | Add recovery journal UX |
| E.capability-default | pass | `src/capability.zag`; `agent-capability-denial` | default read/inspect/simulate; unauthorized placement leaves project hash unchanged | Add scoped/expiring grants |
| E.path-confinement | pass | `TRITON_PROJECT_ROOT`; `agent-path-confinement` | Outside-root and lexical parent traversal writes rejected with stable error; no file created | Add symlink-safe descriptor-relative access |
| E.revision-precondition | pass | `TRITON_EXPECT_REV`; `agent-revision-conflict` | Stale client leaves project bytes/revision unchanged; refresh then succeeds | Add atomic cross-process commit lock |
| E.idempotency | partial | `TRITON_IDEMPOTENCY`; persistent `.idem`; `agent-idempotency` | Successful replay is byte/revision inert; malformed keys rejected | Require keys on every public mutation and expose in MCP schema |
| K.resource-limits | partial | `src/limits.zag`; `bounded-inputs` | Agent request/script, project/FIR bytes, project lines, trace steps, image dimensions/pixels bounded | Add graph-depth, route-search, and trace-history ceilings |
| K.transactional-load | pass | temporary-scene parse/swap; engine hostile fixtures | Invalid kind/coordinate loads fail and preserve the active scene | Add hostile guide and randomized parser corpus |
| E.audit-log | partial | append-only request/denial records with actor and required capability | command results/affected IDs/undo tokens not yet recorded | Complete mutation result records |
| F.x11-live-baseline | pass | `./verify.sh safe`; `--x11-selftest` on `DISPLAY=:0` | Motion, modifier, key, button, WM_DELETE, and PutImage round trip passed | Add resize/focus/reopen coverage |
| F.x11-interleaving | pass | `X11.synth_seen`; live selftest | Synthetic proof no longer flakes when real pointer events interleave | Add resize/focus synthetic cases |
| F.x11-resize-focus-reopen | pass | `x11-live` | Real ConfigureWindow/ConfigureNotify, FocusIn, close, and reopen passed | Add long UI soak |
| F.x11-multisize-capture | pass | `x11-captures`; 1024x640 and 1440x900 | Both live X11 windows presented and emitted deterministic CPU captures | Archive reference-PCU captures |
| F.layout-persistence | pass | `ui-preferences` | left/right/bottom splits round-trip separately from project data | Add invalid preference fuzz cases |
| I.render-discovery | pass | `gpu_open`; `--gpu-info` | Scans DRM render minors and accepts only a successful AMDGPU info query; found minor 128 | Query full firmware/IP/memory tuple |
| I.display-gpu-certification | blocked | `lspci`, `/dev/dri`; masterplan 12.1 | Only RX 5700 XT is also the display GPU; destructive reset/fault certification requires a non-display GPU | Complete all bounded non-destructive work; do not fake certification |

Unchecked items in `masterplan.md` remain `not-run` unless this ledger or a
linked dated report gives a more specific state.
