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
| C.reference-integrity | pass | `scene_validation_errors`; `reference-tamper` | Canonical PCU has zero structural errors; geometry, model, and connectivity mutations each fail verification | Add timing-margin report |
| D.flash-ternary-ops | pass | chamber lattice ops 2/3/5/7; constant-trit emitters | Flash neg/add/mul/nand semantics and exhaustive truth tables pass | Add larger composed-network oracle |
| D.simulation-modes | pass | `SimMode.Functional`, `SimMode.Physical`; `simulation-properties` | Functional behavior is independent of missing physical data; physical mode rejects it | Add deterministic trace capture |
| D.property-oracle | pass | `probe/simulation_property_test.zag`; `simulation-properties` | Exhaustive Flash truth tables, explicit invalid states, delay linearity/rate monotonicity all pass | Add graph differential/metamorphic suites |
| D.deterministic-trace | pass | `trace`; `examples/flash_photonic_massive.trace.txt`; `deterministic-trace` | Two fresh 32-symbol massive-PCU traces match each other and the golden bytes | Add trace viewer and breakpoints |
| D.incremental-differential | pass | `simulation-properties`; independent save/reload/full compile | Every node history and guide ring matches incremental recomputation before/after 24 further symbols | Add translation/equivalent-route metamorphic cases |
| D.metamorphic | pass | translated networks, alternate shortest route, save/reload in `simulation-properties` | Complete simulator state remains identical across all three transformations | Add randomized transformation seeds |
| G.flash-roundtrip | pass | `examples/flash_photonic_massive.zpa`, save/reopen verify | Canonical project matches a fresh public-interface reconstruction byte-for-byte | Keep comparison in the safe gate |
| G.deterministic-exports | pass | `examples/flash_photonic_massive.{bom,netlist,models,report}.txt`; `flash-photonic` | Regenerated project and all four exports compare byte-for-byte with maintained artifacts | Add render pixel-diff gate |
| G.atomic-save | pass | `atomic_write_file`; engine failure injection | temp write, file fsync, close, rename; failed rename retained destination and removed temp | Add parent-directory fsync and crash-stage matrix |
| G.corruption | pass | project v2 checksum; `corrupt project checksum rejected` | Modified project byte rejected before scene mutation | Add recovery journal UX |
| G.project-version-roundtrip | pass | `engine`; `zpa 1` legacy fixture; `zpa 2` save/load | Current v2 round-trips deterministically; legacy v1 loads, migrates to v2, reloads, and preserves IDs | Add future-version migration fixtures when schemas change |
| E.capability-default | pass | `src/capability.zag`; `agent-capability-denial` | default read/inspect/simulate; unauthorized placement leaves project hash unchanged | Add scoped/expiring grants |
| E.scoped-grants | pass | `TRITON_GRANT`; `agent-scoped-grants` | Optional grant narrowing enforces project, session, operation class, path prefix, and monotonic expiration while preserving coarse `TRITON_CAPS` | Add persisted user-facing grant editor |
| E.path-confinement | pass | `TRITON_PROJECT_ROOT`; `agent-path-confinement` | Outside-root and lexical parent traversal writes rejected with stable error; no file created | Add symlink-safe descriptor-relative access |
| E.revision-precondition | pass | `TRITON_EXPECT_REV`; `agent-revision-conflict` | Stale client leaves project bytes/revision unchanged; refresh then succeeds | Add atomic cross-process commit lock |
| E.idempotency | pass | mandatory CLI `request`; MCP `triton_mutate`; persistent `.idem` | Unkeyed mutation rejected; first result carries transaction metadata; replay is byte/revision inert | Add atomic cross-process key reservation |
| E.protocol-negotiation | pass | native `capabilities`; MCP initialize; `agent-negotiation`, `mcp-protocol` | Grants, revision, limits, Triton protocol, and MCP version are machine-readable; framing is bounded | Add schema coverage for operations not yet first-class |
| E.mcp-specialized-mutations | pass | generated MCP tool schemas; `mcp-specialized-mutations`, `mcp-tool-coverage` | Specialized mutation tools advertise `idempotency_key`/`expected_revision`; MCP covers place/get/delete/can_place/export/trace/Flash import/verify through shared agent dispatch | Add remaining create/close/move/rotate/disconnect/reroute schemas |
| E.tool-invariants | pass | `mcp-invariant-enforcement` | Invalid MCP placement/routing cannot bypass design rules and leave project bytes/revision unchanged | Extend to every future specialized tool |
| E.audit-results | pass | `agent_mutation_ok`; append-only audit; `agent-audit-result` | Actor, validated request, result, revision, affected ID, and undo token verified | Add audit rotation/retention policy |
| E.audit-redaction | pass | `audit_redact`; `audit-redaction` | Actor/request/result audit records scrub secret/password/XAuthority/cookie-looking tokens, preserve required undo-token metadata, and do not emit opened project content | Add configurable redaction patterns and retention policy |
| E.undo-audit | pass | `agent-undo-audit` | Public-agent place, route, delete, undo, and redo mutations change state as expected and audit affected IDs plus undo tokens | Extend to future move/rotate/reroute verbs |
| E.error-contract | pass | normalized `ERR E_* diagnostic`; `agent-error-codes` | Generic and specific machine codes retain human-readable context through CLI/MCP | Publish complete error-code reference |
| K.resource-limits | pass | `src/limits.zag`; `bounded-inputs` | Project/components/guides/path depth, route search, trace history, simulation request, images, FIR/scripts, and agent requests bounded | Keep limits under workload review |
| K.transactional-load | pass | temporary-scene parse/swap; engine hostile fixtures | Invalid kind/coordinate loads fail and preserve the active scene | Add hostile guide and randomized parser corpus |
| K.content-nonexecution | pass | literal shell-shaped project name; `security-regression` | Load/save/export preserve text as data and never create command sentinel | Extend stable hostile corpus |
| K.parser-fuzz | pass | checked-in project/FIR/journal corpus; 32 deterministic byte mutations; MCP boundary corpus | Malformed inputs reject transactionally; accepted mutations reserialize/reload; integer overflow rejected | Grow corpus from future failures |
| L.formats-and-recovery-docs | pass | `README.md`; `docs/FORMATS_AUTOMATION_RECOVERY.md` | Supported workflow, format, units/provenance, agent/MCP, persistence, and limitations documented without overclaiming | Keep synchronized through release gate |
| L.reference-pcu-reproduction | pass | `docs/REPRODUCE_REFERENCE_PCU.md`; `flash-photonic`; `deterministic-trace` | Public agent import, Flash rebuild, canonical project/export comparisons, and trace verification have reproducible commands | Add screenshot/UI reproduction once visible controls exist |
| L.language-audit | pass | `unsupported-claim-audit`; `stale-language-audit`; `src/gpu_rt.zag` comment cleanup | Positive marketing/probe-era phrases and unsupported hardware/performance claims are rejected by the safe gate | Keep exception list narrow and reviewed |
| L.release-notes | pass | `docs/RELEASE_NOTES.md`; safe-gate suite names | Release notes enumerate verified behavior and explicit non-claims without using commit count as evidence | Regenerate or review before release tags |
| R.final-safe-subset | pass | `build-production`; `x11-live`; `x11-captures`; `flash-photonic`; `reference-tamper`; `deterministic-trace` | Final-gate build, X11 launch, agent PCU construction, verification, and output/trace comparison are proven by the safe gate | UI manual workflow, crash recovery, CPU soak, and GPU-safe gates remain unchecked |
| M.checked-evidence | pass | `probe/masterplan_evidence_test.zag`; `masterplan-evidence` | Every checked checkbox in `masterplan.md` has an `Evidence:` reference before the next checkbox | Keep this gate required before checking future items |
| E.audit-log | partial | append-only request/denial records with actor and required capability | command results/affected IDs/undo tokens not yet recorded | Complete mutation result records |
| F.x11-live-baseline | pass | `./verify.sh safe`; `--x11-selftest` on `DISPLAY=:0` | Motion, modifier, key, button, WM_DELETE, and PutImage round trip passed | Add resize/focus/reopen coverage |
| F.x11-interleaving | pass | `X11.synth_seen`; live selftest | Synthetic proof no longer flakes when real pointer events interleave | Add resize/focus synthetic cases |
| F.x11-resize-focus-reopen | pass | `x11-live` | Real ConfigureWindow/ConfigureNotify, FocusIn, close, and reopen passed | Add long UI soak |
| F.x11-multisize-capture | pass | `x11-captures`; 1024x640 and 1440x900 | Both live X11 windows presented and emitted deterministic CPU captures | Archive reference-PCU captures |
| F.layout-persistence | pass | `ui-preferences` | left/right/bottom splits round-trip separately from project data | Add invalid preference fuzz cases |
| F.ui-tokens | pass | `src/ui.zag`; `ui-tokens` | Spacing, typography, shape/elevation, UI state colors, separate beam colors, and text/panel contrast are defined and gated | Add full WCAG-style contrast ratios and usage coverage |
| F.frame-overlay | pass | `draw_frame_timing_overlay`; `frame-overlay` | Viewport renders frame number, previous frame time, simulation symbol, and run state in a tested overlay | Add rolling averages and subsystem timing split |
| H.frame-diff | pass | `probe/frame_diff_test.zag`; `frame-diff` | Fixed-state CPU frame captures are byte-identical and the pixel-diff helper detects a deliberate one-pixel change | Add maintained golden scene image corpus |
| H.fb-bounds | pass | `probe/fb_bounds_test.zag`; `fb-bounds` | Clipped framebuffer point/fill/blend/line/text operations preserve canary pixels outside active clip | Add randomized primitive clipping corpus |
| I.render-discovery | pass | `gpu_open`; `--gpu-info` | Scans DRM render minors and accepts only a successful AMDGPU info query; found minor 128 | Query full firmware/IP/memory tuple |
| I.display-gpu-certification | blocked | `lspci`, `/dev/dri`; masterplan 12.1 | Only RX 5700 XT is also the display GPU; destructive reset/fault certification requires a non-display GPU | Complete all bounded non-destructive work; do not fake certification |

Unchecked items in `masterplan.md` remain `not-run` unless this ledger or a
linked dated report gives a more specific state.
