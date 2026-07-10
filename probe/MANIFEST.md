# Probe manifest

Classifies every `probe/*.zag`, separating **production tests** (run by the safe
`./tools/verify` suite) from hardware-only, benchmark, compiler, and **obsolete**
probes, and from generated artifacts (Master plan §4.2). Generated binaries are
never tracked in git (`.gitignore`); only `.zag` sources and this manifest live
in `probe/`. The `probe-manifest-audit` gate fails if any probe is unclassified.

## Production tests — gated by `tools/verify.zag` (71)

- `agent.zag`
- `ast.zag`
- `bounds_test.zag`
- `boxselect_test.zag`
- `camera_test.zag`
- `components.zag`
- `copypaste_test.zag`
- `crash_recovery_test.zag`
- `demo.zag`
- `design_db_test.zag`
- `dpi_test.zag`
- `drc_test.zag`
- `engine_test.zag`
- `fb.zag`
- `fb_bounds_test.zag`
- `feedback_test.zag`
- `frame_diff_test.zag`
- `frame_overlay_test.zag`
- `gizmo_test.zag`
- `gpu_kernel_test.zag`
- `gpu_query_test.zag`
- `gpu_safety_test.zag`
- `gpu_uapi_test.zag`
- `gpu_vgpu_test.zag`
- `inspector_test.zag`
- `json.zag`
- `lifecycle_test.zag`
- `limits_test.zag`
- `list.zag`
- `main.zag`
- `masterplan_evidence_test.zag`
- `opt_report_test.zag`
- `opt_schedule_test.zag`
- `opt_ui_test.zag`
- `opt_verify_test.zag`
- `optimizer_test.zag`
- `ortho_test.zag`
- `outline_test.zag`
- `palette_test.zag`
- `parser_corpus_test.zag`
- `persistence_test.zag`
- `picking_test.zag`
- `protocol_parser_test.zag`
- `provenance_test.zag`
- `provenance_units_test.zag`
- `reference_tamper_test.zag`
- `render_golden_test.zag`
- `render_test.zag`
- `robustness_test.zag`
- `routing.zag`
- `routing_test.zag`
- `rt.zag`
- `scene.zag`
- `scheduling_test.zag`
- `security_regression_test.zag`
- `session_conflict_test.zag`
- `shortcuts_test.zag`
- `sim.zag`
- `sim_semantics_test.zag`
- `simulation_property_test.zag`
- `soak_test.zag`
- `stepping_test.zag`
- `timing_test.zag`
- `ui.zag`
- `ui_prefs_test.zag`
- `ui_tokens_test.zag`
- `units_test.zag`
- `world.zag`
- `x11.zag`
- `x11_pixel_pack_test.zag`
- `znc.zag`

## Hardware-only — require a real (ideally non-display) GPU; excluded from the safe suite (6)

- `gpu_compute_test.zag`
- `gpu_fill_test.zag`
- `gpu_parallel_test.zag`
- `gpu_submit_test.zag`
- `gpu_test.zag`
- `gpu_wg_test.zag`

## Dev benchmarks — timing tools, not pass/fail gates (superseded by `tools/bench.zag`) (2)

- `perf_test.zag`
- `scale_test.zag`

## Compiler probes — exercise a `znc` language feature, not Triton (1)

- `break_test.zag`

## Obsolete — early debug/exploration scratch; kept for history, not run and not production (24)

- `agent_place2.zag`
- `agent_twoline.zag`
- `app.zag`
- `components_only.zag`
- `hashmap.zag`
- `hm_dbg.zag`
- `io_chunks.zag`
- `lex.zag`
- `move_dbg.zag`
- `opt_ui_shot.zag`
- `probe3.zag`
- `probe4.zag`
- `route_dbg.zag`
- `rsz2.zag`
- `scene_only.zag`
- `ternary.zag`
- `tiles.zag`
- `transport.zag`
- `viewport.zag`
- `voxel_only.zag`
- `workspace.zag`
- `world_only.zag`
- `world_smoke.zag`
- `x11_paint.zag`

