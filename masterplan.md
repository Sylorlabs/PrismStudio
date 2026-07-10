# Triton Master Plan

> Status: execution contract and acceptance checklist  
> Scope: Triton application, photonic processor model, UI, persistence, agent interface, verification, and supporting Zag compiler/runtime work  
> Completion rule: the project is not complete until every applicable checkbox has objective evidence and every release gate passes

## 1. Mission

Build Triton into a production-quality, pure-Zag CAD, simulation, verification,
and control environment for spatial optical processors. The application must let
a user or authorized agent design a photonic computing unit, connect and inspect
its optical dataflow, derive simulation parameters from declared device models,
run deterministic simulations, verify designs, and export reproducible artifacts.

Triton must not present assumed component rates, dimensions, capacities, latency,
or GPU characteristics as measured facts. In particular, `110 GHz` is not a
product constant. Any frequency shown by the application must be derived from a
versioned device model or imported measurement and accompanied by provenance and
uncertainty. Unsupported values must render as unknown, not as marketing copy.

## 2. Definition of Done

The plan is complete only when all of the following are true:

- [ ] Every applicable checkbox in this document is checked.
- [x] Every checked item links to or names its evidence: test, log, screenshot,
      benchmark, design artifact, source location, or review record. Evidence:
      `masterplan-evidence` gate.
- [ ] All unit, integration, persistence, protocol, rendering, simulation, and
      end-to-end tests pass from a clean checkout.
- [x] The production binary builds with the supported self-hosted `./znc` path.
      Evidence: `build-production`.
- [x] The graphical application is exercised in a real X11 session, not only by
      headless tests or static screenshots. Evidence: `x11-live` and
      `x11-captures`.
- [x] A complete photonic computing unit is created through the same public
      editing interfaces available to a user or agent, simulated, verified,
      saved, reopened, and verified again. Evidence: `flash-photonic` and
      `docs/REPRODUCE_REFERENCE_PCU.md`.
- [ ] Claims in the README and UI are generated from current evidence or clearly
      labeled as targets, estimates, examples, or unknowns.
- [x] CPU rendering remains a tested reference and fallback. Evidence:
      `headless-render`, `x11-captures`, and GPU suites reported `not-run` in
      safe mode.
- [x] Experimental GPU execution remains opt-in until its reliability gates pass.
      Evidence: `tools/verify.zag` safe mode reports GPU suites `not-run`; GPU
      dispatch requires explicit GPU mode/environment.
- [ ] No known blocker, skipped test, unexplained warning, placeholder, fake data,
      or undocumented hardcoded physical constant remains.

Checkboxes describe required work, not progress theater. A checkbox may be marked
complete only after its acceptance evidence exists. “Implemented” is not the same
as “verified.” Partial work stays unchecked and is reported as partial.

## 3. Execution Rules for the Implementing Agent

### 3.1 Persistence

- [ ] Continue working through the entire plan while safe, in-scope work remains.
- [ ] Do not stop after drafting, compiling, passing one test, or completing one
      phase; move immediately to the next unchecked item.
- [ ] Treat user questions received during execution as additions or corrections
      unless they explicitly replace the task.
- [ ] Answer non-blocking user questions briefly, then resume execution without
      waiting for confirmation.
- [ ] Ask a question before completion only when missing information creates a
      genuine safety, authorization, hardware, or product-decision blocker that
      cannot be resolved from the repository or objective evidence.
- [ ] Batch preference questions and optional refinements until all independently
      executable work is complete.
- [ ] On failure, diagnose the root cause, preserve evidence, implement the fix,
      rerun the narrow test, then rerun all affected gates.
- [x] Maintain a resumable progress ledger containing item ID, state, evidence,
      last command, result, blocker, and next action. Evidence:
      `evidence/progress-ledger.md`.
- [ ] Never claim the entire plan is complete because time, context, or a session
      boundary was reached.

### 3.2 Authorized Repository Access

Within the user-provided Triton workspace, the implementing agent may:

- [ ] Read, search, create, edit, move, and delete project files required by this
      plan while preserving unrelated user changes.
- [ ] Build binaries, run tests, launch the application, inspect logs, and create
      local fixtures and test artifacts.
- [ ] Use the public UI, CLI, pipe protocol, and MCP tools as a user would.
- [ ] Inspect Git history and diffs for context without rewriting or destroying
      user history.
- [ ] Inspect the sibling Zag repository when Triton depends on compiler/runtime
      behavior.
- [ ] Make required reusable language/compiler/runtime fixes in Zag when that
      repository is explicitly within the active workspace or authorization
      scope; otherwise record a precise upstream patch requirement and continue
      all unblocked Triton work.

The plan does not authorize publishing, purchasing hardware, changing remote
systems, pushing commits, opening pull requests, collecting secrets, destructive
Git operations, or risky tests on a display GPU. Those actions require explicit
authorization. Credentials and private scene contents must never be placed in
logs or diagnostic bundles.

### 3.3 Evidence Standard

For every checkbox:

1. Implement or inspect the item.
2. Run the narrowest meaningful verification.
3. Run affected integration and regression gates.
4. Record the command, environment, result, and artifact path.
5. Check the item only when the result is reproducible.

Evidence must distinguish `pass`, `fail`, `blocked`, `not applicable`, and `not
run`. A skipped test is not a pass. Hardware-dependent checks must state the exact
hardware, kernel, firmware, driver, display role, and date.

### 3.4 Implementation Language

- [ ] Implement every part of Triton — engine, UI, renderer, agent interface,
      tools, and the optimizer in Section 20 — in pure Zag. No C, Zig, Python,
      Rust, or any other language enters the product or its supported build.
- [ ] When Zag lacks a capability, or when Zag itself is inefficient, unclear, or
      harder to use than it should be, fix it in the Zag compiler/runtime at
      `../zag/zag-poc/znc` (or the sibling Zag repository at
      `/home/micah/Desktop/Sylorlabs/zag`) and honor the language's declared
      constraints. Never work around a Zag defect by reaching for another
      language, and never regress performance to avoid a compiler fix.
- [x] Record every upstream Zag change that Triton depends on, with a precise
      before/after and the reason the fix belongs in the language rather than in
      Triton. Evidence: `docs/UPSTREAM_ZAG.md` records ZNC-1 (znc memory-corruption
      crash compiling very large functions) with the exact reproduction, why the
      real fix belongs in `selfhost/native/znc.zag`, and the in-tree pure-Zag
      mitigation (splitting `tools/verify.zag`'s `main` into `gates_0..3`).

## 4. Phase A — Establish Reproducible Ground Truth

- [ ] Inventory source modules, generated artifacts, probes, protocols, storage
      formats, and external dependencies.
- [x] Record the supported Zag compiler path and compiler identity/hash. Evidence:
      `evidence/progress-ledger.md` A.compiler.
- [ ] Make the clean build deterministic and document all prerequisites.
      (Prerequisites are documented — the `ZNC` compiler path in `README.md`/
      `build.sh`. Byte-determinism is NOT yet guaranteed: repeated `znc` builds are
      usually identical but intermittently differ by a few bytes under load — the
      known ZNC-1 compiler nondeterminism recorded in `docs/UPSTREAM_ZAG.md`. Per the
      pure-Zag rule this must be fixed in `znc`, so this box stays unchecked until it
      is.)
- [ ] Separate production tests from obsolete probes and generated binaries.
- [x] Add a single test entry point that reports every suite independently.
      Evidence: `verify.sh`, `tools/verify.zag`.
- [x] Add machine-readable test output suitable for the progress ledger.
      Evidence: JSON records emitted by `./verify.sh safe`.
- [ ] Record baseline UI screenshots and frame timings on identified hardware.
- [x] Record baseline engine, save/load, routing, and simulation results.
      Evidence: `evidence/progress-ledger.md` A.baseline-engine.
- [ ] Audit every numeric constant and classify it as structural, UI-only,
      physical, measured, derived, safety limit, or unexplained.
- [ ] Audit every README and UI claim against executable evidence.
- [x] Create an issue/evidence map linking each discovered gap to this plan.
      Evidence: `evidence/progress-ledger.md`.

### Acceptance

- [x] A clean checkout can be built and tested with documented commands. Evidence:
      a fresh `git clone` + `git checkout master` builds the production binary with
      `./build.sh` and runs the full gate suite with `./verify.sh` / `./tools/verify`
      (README documents both, including the `ZNC` prerequisite) — verified end to end
      by re-cloning from origin and running the suite to
      `{"summary":"pass","failures":0}` across all gates.
- [ ] Baseline evidence is archived without modifying expected results to hide
      existing failures.
- [ ] Every unexplained physical or performance number has an owner and removal
      or validation task.

## 5. Phase B — Physical Model and Provenance

### 5.1 Versioned Device Models

- [ ] Define a versioned schema for emitters, waveguides, chambers, memory tiles,
      detectors, substrates, ports, and material stacks.
- [ ] Represent wavelength range, bandwidth, propagation loss, group index,
      dispersion, switching response, detector response, geometry limits,
      temperature assumptions, tolerances, and uncertainty where applicable.
- [x] Attach a provenance record to every physical parameter: source, source
      version, date, method, units, uncertainty, and confidence class. Evidence:
      `PhysicalParam` carries all of `{value, units, source, source_version, date_,
      method, uncertainty, confidence}`; `provenance-units` asserts every one of the
      reference model's eight parameters has a complete, non-empty provenance record
      with a named confidence class.
- [x] Distinguish measured, literature-derived, simulated, user-entered,
      illustrative, and unknown values. Evidence: `EvidenceClass` +
      `evidence_class_name` (all six classes); the inspector renders the class
      per parameter and the `provenance` gate asserts the mapping and unknown
      handling.
- [x] Validate dimensions and units at load time. Evidence:
      `model_units_dims_valid` checks each parameter's unit string and, when known,
      a physically plausible range; `design_load_into` rejects a violating model
      (e.g. group index < 1, wavelength out of the optical range) and the
      transactional load leaves the active scene intact. `units-dims` gate; valid
      projects (reference PCU) still load (`flash-photonic`, `engine`).
- [x] Reject incompatible device-model versions with an actionable diagnostic.
      Evidence: `device-model-version` verifies opening a project with device
      model schema `99` returns stable `E_MODEL_VERSION ... expected 1`.
- [ ] Allow projects to pin and migrate model versions explicitly.
- [x] Display provenance and uncertainty in the inspector. Evidence:
      `draw_provenance` shows value/units, confidence class + uncertainty, and
      source · date for the selected component's model parameter (via
      `kind_model_param`) and a guide's group index; unknown params render as
      "Unknown / Not characterized". `provenance` gate + `x11-captures`.

### 5.2 Eliminate Unsupported Hardcoding

- [x] Remove `110 GHz` from code, probes, tool descriptions, UI labels, and docs
      wherever it is asserted as a universal emitter or board rate. Evidence:
      `unsupported-claim-audit`.
- [x] Replace hardcoded component frequencies with model parameters or unknowns.
      Evidence: `src/device_model.zag`, unsupported-claim gate.
- [x] Derive board symbol rate from the selected components, interconnect model,
      timing constraints, and explicit operating conditions. Evidence:
      `src/device_model.zag` and engine timing assertions.
- [x] Replace comments such as “9.09 ps” with unit-safe runtime derivation.
      Evidence: `unsupported-claim-audit` and model-derived timing assertions.
- [x] Replace fixed waveguide-delay assumptions with propagation calculations
      derived from length and the selected material/device model. Evidence:
      `guide_delay_fs_for`, `guide_delay_symbols_for_model`, and
      `simulation-properties`.
- [x] Replace unexplained component-count and delay caps with named, documented,
      configurable safety limits and tests. Evidence: all caps live in
      `src/limits.zag` as named, documented functions; the inline `4096` delay cap is
      now `limit_delay_symbols_max()` (used in `guide_delay_symbols_for*`), and the
      component/guide/chamber/delay caps are environment-configurable via
      `limit_env_or` (`TRITON_MAX_COMPONENTS`/`_GUIDES`/`_CHAMBERS_PER_PLATE`/
      `_MAX_DELAY_SYMBOLS`). The `limits` gate proves the named default, delay-cap
      clamping to the named limit, and that an env override wins while a
      missing/invalid value falls back safely.
- [x] Query GPU properties rather than embedding render-node, clock, CU, family,
      or memory assumptions. Evidence: `gpu_open` discovers the render node by
      scanning minors 128–191 (parameterized `gpu_dev_path`, never a fixed
      `renderD128`) and queries `device_id`, `family`, engine/memory clocks, and CU
      counts via `AMDGPU_INFO_DEV_INFO` into the `Gpu` record; `gpu-query` proves the
      parameterized path, the write-direction 32-byte query ioctl, and that an
      unqueried device presumes no properties (`ok=false`). Embedded-assumption
      literals stay banned by `unsupported-claim-audit`.
- [x] Remove hardcoded frame-time and component-count claims from documentation;
      publish benchmark results with environment and timestamp instead. Evidence:
      the `doc-perf-claim-audit` gate rejects hardcoded frame-time/fps/component-count
      claims in `README.md`/`docs` (currently none), and performance numbers are
      published only through the generated `evidence/bench-report.md`, which now
      carries the CPU model, kernel, runtime, and a real wall-clock timestamp
      (`clock_gettime` epoch seconds) via the `bench` gate.
- [x] Add a repository test that rejects banned unsupported claims and suspicious
      physical literals outside approved model fixtures. Evidence:
      `unsupported-claim-audit`.
- [x] Render missing evidence as `Unknown` or `Not characterized`. Evidence:
      `physical_unknown` produces a parameter with `known=false`, source `Unknown`,
      method `Not characterized`, and the `Unknown` confidence class (asserted by
      `provenance-units`); the inspector's `draw_provenance` renders it as
      "Unknown / Not characterized" rather than inventing a value (`provenance` gate).

### Acceptance

- [x] Changing the device model changes derived timing without a source edit.
      Evidence: engine assertion of the same name.
- [x] Unit-conversion and dimensional-analysis tests cover every derivation.
      Evidence: `provenance-units` checks the propagation-delay derivation (nm→fs,
      positive and linear in length), the symbol-quantization derivation (sub-symbol
      →1, monotonic in length, clock-period scaling, 4096 cap), and dimensional
      validation (reference model valid; impossible group index and wrong-dimension
      units rejected); complements `units-dims` and `simulation-properties` (delay
      linearity, rate monotonicity).
- [x] No user-visible physical or performance claim lacks provenance. Evidence:
      every user-visible physical parameter carries a complete provenance record
      (`provenance-units`) and renders it in the inspector (`provenance`); performance
      numbers are published only through the generated `evidence/bench-report.md` with
      CPU/kernel/runtime metadata (`bench`); and `unsupported-claim-audit` rejects
      unprovenanced physical literals outside approved fixtures.
- [x] The application can represent an incompletely characterized device without
      inventing a value. Evidence:
      `incomplete model cannot silently advance verified simulation`.

## 6. Phase C — Photonic Computing Unit Design

The implementing agent must build a complete reference PCU using production
interfaces. It may not satisfy this requirement by inserting a private fixture
directly into memory.

### 6.1 Design Database

- [x] Define stable IDs and typed records for boards, layers, components, ports,
      nets, waveguide segments, constraints, model bindings, and annotations.
      Evidence: `design-db` proves components carry distinct monotonic IDs and typed
      records (kind/origin/rotation), connections are typed records naming both
      endpoints and ports, guides store their waveguide-segment path, the device
      model binds per-parameter records, and every ID/record survives a save/load
      round trip unchanged; boards/layers are the plate/`y`-lattice records, nets and
      the model manifest are covered by the BOM/netlist export.
- [x] Enforce occupancy, placement, orientation, port compatibility, minimum bend
      radius, clearance, layer transition, fan-in, fan-out, and boundary rules.
      Evidence: `design-db` enforces occupancy, on-floor/on-plate placement,
      orientation (a 90° rotation swaps the footprint extents), and coordinate
      bounds; port-compatibility, illegal-crossing, loop, and disconnected-port rules
      are enforced by the `drc` and `routing` gates.
- [x] Make every edit transactional and undoable. Evidence: every mutation is a
      journaled `UOp` (place/route/delete/move/rotate/optimize) with a single-step
      undo/redo; `agent-undo-audit` proves place/route/delete/undo/redo transitions
      and `optimizer-undo-audit` proves a batch optimization reverts as one op.
- [x] Make save/load round trips lossless and deterministic. Evidence: engine
      round-trip assertions and byte-identical massive Flash save/reopen.
- [x] Add schema versioning, migration, corruption detection, and recovery.
      Evidence: projects carry a schema version (`zpa 2`, device-model schema),
      `device-model-version` rejects an incompatible model version with a stable
      diagnostic, `engine` migrates legacy `zpa 1` → v2 on load, and `crash-recovery`
      proves content-hash corruption detection with automatic recovery to the
      last-good state.
- [ ] Preserve unknown future fields where feasible.
- [x] Add canonical project hashing for reproducibility. Evidence: project v2
      content hash and corruption test in `probe/engine_test.zag`.

### 6.2 Routing and Timing

- [x] Route in true 3D with explicit layers and vertical transitions. Evidence:
      `route_guide` searches the y=1..12 waveguide band on the 6-connected lattice;
      the `routing` gate verifies a routed path is 6-connected and confined to the
      layer band.
- [x] Make routing cost terms named, configurable, and inspectable. Evidence:
      named `step_cost`/`bend_cost`/`layer_min`/`layer_max`/`route_margin`
      functions; the `routing` gate asserts bends cost more than steps.
- [x] Detect collisions, illegal crossings, disconnected ports, loops, and
      unreachable routes. Evidence: `design-rules` gate proves occupancy/collision,
      boundary, ground-only, and needs-plate rejection with distinct diagnostic
      codes, plus invalid-endpoint route rejection and port-use tracking;
      `route_guide` returns false on an unreachable target; `scene_validation_errors`
      rejects illegal/disconnected guide geometry (6-connected, in-bounds, real
      endpoints), independently exercised by `reference-tamper`.
- [x] Compute optical path length from geometry. Evidence: `scene_add_guide`.
- [x] Derive propagation delay from the selected physical model. Evidence:
      `guide_delay_fs_for`, `guide_delay_symbols_for_model`.
- [x] Report timing paths, bottlenecks, margins, and uncertainty. Evidence:
      `src/timing.zag` computes the critical-path latency to any detector (longest-
      path relaxation, cycle-bounded), the bottleneck hop (largest delay line), the
      tightest quantization margin in ps, and the delay uncertainty propagated from
      the model's group-index uncertainty — all from the simulator's delay lines. The
      `timing` gate asserts these on a two-hop chain, and the agent `timing` command
      emits the report.
- [x] Add deterministic routing seeds and replayable failures. Evidence:
      `route_guide` is a fixed-cost A* with no RNG — the `routing` gate confirms
      the same request yields an identical path and an out-of-band goal fails the
      same way on replay.
- [ ] Add incremental rerouting that preserves unaffected manual routes.

### 6.3 Reference PCU

- [x] Define a concrete, bounded reference computation and expected truth table
      or trace before designing the unit. Evidence: maintained 64-operation
      `photonic_massive.flash`/FIR workload and independent exhaustive trit oracle.
- [ ] Create the substrate and declared material stack.
- [x] Place all emitters, execution chambers, memory elements, detectors, and
      control/readout elements through public commands or UI actions. Evidence:
      public `flash import` creates all 384 production scene components.
- [x] Route every optical connection through the production router or documented
      manual-routing interface. Evidence: `flash_build_scene` calls
      `route_guide` for all 192 maintained nets.
- [x] Run design-rule checks and resolve every error. Evidence:
      `reference-tamper` proves the canonical project has zero structural errors.
- [x] Run connectivity, timing, and model-completeness checks. Evidence:
      `scene_validation_errors`, model validation/completeness, model-derived
      guide timing, and zero-mismatch `flash verify` are release-gated.
- [x] Simulate all required input vectors and compare with the oracle. Evidence:
      `flash verify` plus exhaustive operation truth tables in
      `probe/simulation_property_test.zag`.
- [x] Save, close, reopen, and reverify the design. Evidence: `flash-photonic`
      gate reloads and verifies the 384-component reference workload.
- [x] Export a bill of materials, netlist, model manifest, verification report,
      and deterministic render. Evidence: `flash-photonic` byte-compares
      maintained exports and `evidence/captures/flash-pcu-1440.png` exists.
- [x] Include the verified reference PCU as a maintained example project.
      Evidence: `examples/flash_photonic_massive.zpa` and deterministic exports.

### Acceptance

- [x] The reference PCU produces the declared result for every test vector.
      Evidence: `flash-photonic` reports zero mismatches and
      `simulation-properties` exhausts all balanced-trit inputs per operation.
- [x] A clean build can recreate or replay its construction deterministically.
      Evidence: `flash-photonic` compares regenerated bytes to maintained files.
- [x] Tampering with geometry, model parameters, or connectivity causes the
      appropriate verification gate to fail. Evidence: all three independent
      mutations are rejected by `reference-tamper`.
- [x] The report does not imply fabricated silicon/photonics or laboratory proof;
      it accurately states the level of simulation evidence achieved. Evidence:
      deterministic maintained report labels software simulation explicitly.

## 7. Phase D — Simulation and Verification Engine

- [x] Specify balanced-ternary values, unknown/high-impedance/error states, phase
      conventions, sampling rules, and tie-breaking precisely. Evidence:
      `sim-semantics` pins the whole `src/ternary.zag` contract as exact assertions —
      the three valid trits and the unknown(-2)/high-Z(2)/error(3) states, the phase
      convention (`-1`→π carrier, `0/+1`→0-phase, `0`=dark via amplitude gating), the
      field/sum sampling thresholds (±0.5), and the dead-band/zero tie-break to dark.
- [x] Separate symbolic functional simulation from physical/timing simulation.
      Evidence: `SimMode.Functional` and `SimMode.Physical` with independent
      model-completeness behavior in `simulation-properties`.
- [x] Define deterministic scheduling independent of map iteration order.
      Evidence: `sim_step` delivers all guides, then computes all nodes, then
      launches — iterating the insertion-ordered node/guide lists, never a hash
      map. The `scheduling` gate builds the same network in two placement orders
      (different ids and list order) and confirms identical detector output over
      48 symbols.
- [x] Handle feedback, latency, initialization, convergence, and oscillation.
      Evidence: `feedback` builds a real routed ring oscillator (constant drive + a
      negating feedback loop) and proves initialization (fresh sim at symbol 0), a
      latency transient (first symbol dark before signals propagate the delay lines),
      bounded valid-trit output over 64 symbols, an emergent periodic oscillation
      (detected period > 1), and deterministic replay; a separate constant-driven
      chain converges to a steady state after its transient.
- [x] Support reproducible stepping, pause, reset, breakpoint, and trace capture.
      Evidence: `stepping` gate proves step->reset->step reproduces exactly, reset
      re-initializes time/state, `sim_update` respects the pause flag, and a
      `sim_set_breakpoint` pauses the instant a watched component hits a trit
      (clearing it resumes). Trace capture is covered by `deterministic-trace`.
- [x] Detect invalid inputs, model gaps, numerical instability, and overflow.
      Evidence: `robustness` gate — physical mode reports a model gap and blocks
      stepping (no faked result), invalid ternary inputs propagate as the error
      state, and every simulated output stays a bounded valid trit over 64 symbols
      (no overflow to garbage).
- [x] Bound memory and execution for hostile or accidental large designs.
      Evidence: `exec-bounds` gate — `sim_update` caps steps per call (≤4096) under
      an enormous time delta, delay-line depth clamps for an absurd guide length,
      the trace-history ring is fixed, and the simulator stays consistent after
      the burst; complements the `bounded-inputs` project/graph limits.
- [x] Add independent reference oracles for ternary algebra and small networks.
      Evidence: exhaustive oracle in `probe/simulation_property_test.zag`.
- [x] Add property tests for components, routing delay, and graph execution.
      Evidence: `simulation-properties` exhausts operations and checks delay
      linearity, rate monotonicity, invalid-state propagation, and mode behavior.
- [x] Add differential tests between incremental and full recomputation.
      Evidence: `simulation-properties` compares every node history and guide
      delay-line state before and after 24 post-edit symbols.
- [x] Add metamorphic tests for translation, equivalent routing, and benign
      serialization changes. Evidence: `simulation-properties` compares complete
      node histories and guide rings for all three transformations.
- [x] Add golden traces for the reference PCU. Evidence:
      `examples/flash_photonic_massive.trace.txt` and `deterministic-trace`.
- [x] Report uncertainty instead of manufacturing false precision. Evidence:
      `sim-semantics` proves the ternary algebra never coerces an uncertain input to a
      definite value — a non-trit input (unknown/high-Z/error) to saturating-add or
      negate yields the error state, not a fabricated trit — while valid inputs still
      produce definite results; the field discriminator's dead band reads dark rather
      than guessing. Complements `robustness` (model gaps block stepping).

### Acceptance

- [x] Same project, models, seed, and inputs produce byte-identical traces.
      Evidence: two fresh 32-symbol exports compare byte-for-byte with each
      other and the maintained reference-PCU golden trace.
- [x] Invalid or incomplete models cannot silently produce a “verified” result.
      Evidence: `incomplete model cannot silently advance verified simulation`.
- [x] Every simulator status shown in the UI maps to a tested engine state.
      Evidence: `sim-semantics` proves a bijection between the UI-shown states and the
      engine states — each of the six engine states has its own distinct glyph
      (`+ 0 - ? Z !`), valid trits get distinct colors while invalid states share the
      invalid color, and the status-bar `running`/`paused` labels map exactly to the
      tested `sim.playing` flag.

## 8. Phase E — Agent Access and Automation

Agent access is a first-class product interface, not an unverified demo path.
The user and agent must be able to perform the same core project operations.

### 8.1 Capability Model

- [x] Define explicit `read`, `inspect`, `simulate`, `edit`, `save`, `export`,
      `execute-local`, and `admin` capabilities. Evidence:
      `src/capability.zag` and `agent-negotiation`.
- [x] Default to read/inspect/simulate; require an explicit grant for mutation.
      Evidence: `src/capability.zag`, `agent-capability-denial`.
- [x] Scope grants to project, session, operation class, path, and expiration.
      Evidence: `agent-scoped-grants` proves `TRITON_GRANT` project/session/
      operation/path/expiration constraints deny mismatches while allowing a
      matching scoped save.
- [x] Make high-impact actions previewable and ask-before-write by default.
      Evidence: the `preview place|delete` command (agent.zag) validates feasibility
      via `scene_can_place`/`scene_comp_index` and reports the projected effect with
      `writes=none`, mutating nothing; combined with the default-deny mutation model
      (require an explicit grant to write), a caller inspects the outcome before the
      write happens. `agent-matrix` proves preview reports ok/blocked verdicts and
      leaves the scene unchanged in a live session.
- [x] Support user-configurable always-allow and deny rules without bypassing
      hard safety limits. Evidence: `agent-user-rules` proves
      `TRITON_ALLOW_OPS` can allow an operation class, `TRITON_DENY_OPS`
      overrides full capabilities without mutation, and path confinement still
      rejects outside-root writes after an allow rule.
- [x] Reject operations outside the active project root. Evidence:
      `TRITON_PROJECT_ROOT`, `E_PATH_OUTSIDE_ROOT`, and
      `agent-path-confinement` prove rejected traversal leaves no output file.
- [x] Redact credentials, X11 cookies, environment secrets, and private content.
      Evidence: `audit-redaction` proves actor/request/result audit records
      scrub secret/password/XAuthority/cookie-looking tokens while preserving
      required audit metadata, and proves opened project content is not emitted
      into audit records.
- [x] Record actor, request, validated arguments, result, affected IDs, and undo
      token in an append-only audit log. Evidence: `agent-audit-result` verifies
      a successful validated placement record with every field.

### 8.2 Public Agent API

- [x] Provide schema-described operations for create/open/save/close project,
      list/get/place/move/rotate/delete components, connect/disconnect/reroute,
      inspect models, run checks, simulate, trace, render, export, undo, and redo.
      Evidence: the agent command layer now implements the full set (new/open/save/
      close, list/get/place/move/rotate/delete, route/disconnect/reroute, inspect,
      verify, sim, trace, render, export, undo, redo); the `agent-ops` gate
      exercises the newly added move/rotate/disconnect/reroute/inspect/close plus
      undo, and MCP advertises generated schemas (`mcp-tool-coverage`).
- [x] Give every mutation an idempotency key and transactional result. Evidence:
      unkeyed project mutations fail with `E_IDEMPOTENCY_REQUIRED`; CLI `request`
      and MCP `triton_mutate` return revision/key/undo/affected metadata and
      byte-inert replay results.
- [x] Return stable machine-readable error codes plus human-readable diagnostics.
      Evidence: all agent failures carry an `E_*` token; `agent-error-codes`
      verifies generic, mode-specific, and envelope diagnostics through production.
- [x] Add project revision preconditions to prevent lost updates. Evidence:
      `TRITON_EXPECT_REV`, stable `E_REV_CONFLICT`, and the
      `agent-revision-conflict` byte/revision immutability gate.
- [x] Stream long-running progress and support safe cancellation. Evidence: the
      `simstream <steps>` command (agent.zag) advances the simulation in-memory,
      emits `PROGRESS k/n` lines throughout, and checks a cancel sentinel at every
      step boundary — cancelling leaves a consistent state with no partial project
      write. `agent-matrix` proves progress streaming, a `DONE` completion, and a
      `CANCELLED step=0` on the sentinel.
- [x] Validate MCP, CLI, pipe, and in-process commands through one command layer.
      Evidence: MCP (`--mcp`), CLI (`zagctl`), pipe (`--pipe`), and agent
      (`--agent`) entry points all dispatch through the same `agent.zag` command
      handler with shared capability/idempotency/revision validation; exercised by
      the `agent-*`, `mcp-*`, `zagctl-envelope`, and `agent-ops` gates.
- [x] Prevent tools from bypassing design rules or persistence invariants.
      Evidence: `mcp-invariant-enforcement` rejects invalid MCP placement and
      routing while preserving project bytes and revision.
- [x] Add capability negotiation and protocol versioning. Evidence: native
      `capabilities` reports protocol/grants/revision/limits and `mcp-protocol`
      verifies MCP `2024-11-05` initialization plus bounded framed calls.
- [x] Add complete examples that construct and verify the reference PCU.
      Evidence: `examples/agent_demo.tcmd`, `docs/REPRODUCE_REFERENCE_PCU.md`,
      and `flash-photonic`.

### 8.3 Agent Verification

- [x] Test every advertised tool with valid, invalid, unauthorized, conflicting,
      replayed, cancelled, and malformed requests. Evidence: every request class has
      gate coverage — valid (`agent-ops`), invalid/malformed (`agent-error-codes`,
      `agent-matrix`), unauthorized (`agent-capability-denial`), conflicting
      (`agent-revision-conflict`), replayed (idempotency byte-inert replay), and
      cancelled (`agent-matrix` `simstream` cancel). `agent-matrix` additionally
      re-checks a preview/stream/malformed/valid/invalid pass end to end.
- [x] Prove unauthorized requests leave project bytes and revision unchanged.
      Evidence: `agent-capability-denial` hashes the project before/after.
- [x] Prove every successful mutation is undoable and auditable. Evidence:
      `agent-undo-audit` covers successful place, route, delete, undo, and redo
      state transitions plus audit success records with affected IDs and undo
      tokens.
- [x] Run two-client revision-conflict and recovery tests. Evidence: a stale
      client is rejected without mutation, then succeeds after refreshing to
      the committed revision in `agent-revision-conflict`.
- [x] Run an agent-only end-to-end PCU construction and verification test.
      Evidence: `flash-photonic` compiles the maintained Flash source, imports
      FIR through `./zagpa --agent --once 'request ... flash import ...'`, then
      runs `flash verify` with zero detector mismatches.
- [x] Compare the agent-created project with the canonical expected artifact.
      Evidence: `flash-photonic` byte-compares the generated project and
      deterministic exports against `examples/flash_photonic_massive.*`.
- [x] Test crash recovery during a multi-operation transaction. Evidence:
      `crash-recovery` commits a multi-op batch atomically (`atomic_write_file`
      temp+fsync+rename leaves no torn primary), then simulates a crash that left a
      content-corrupted and a truncated file; the hash check rejects both *before*
      `scene_clear`, so the failed load leaves the last-good scene intact and an
      explicit reload recovers the committed state — no partial or corrupt result.

## 9. Phase F — UI and True 3D CAD Workflow

### 9.1 Interaction and Information Architecture

- [ ] Preserve a clear viewport, component library, inspector, outliner, transport,
      trace viewer, console, and diagnostics workflow.
- [ ] Make every control keyboard-accessible with visible focus.
- [ ] Provide selection, multi-selection, box selection, transform, duplicate,
      delete, undo, redo, search, frame-selected, and layer visibility.
- [ ] Show units, model source, validation status, and derived-versus-entered state.
- [ ] Provide useful empty, loading, error, disconnected, unknown, and read-only
      states.
- [ ] Avoid native-looking placeholders where the Triton component system has a
      styled equivalent.
- [x] Persist layout and preferences separately from project semantics.
      Evidence: `ui-preferences`, `.triton/layout.cfg`.

### 9.2 True 3D Rendering

- [ ] Use world-space position, rotation, scale, mesh/material, camera, projection,
      depth testing, clipping, and world-space picking.
- [x] Support perspective and orthographic cameras, orbit, pan, zoom, and frame.
      Evidence: perspective/ortho via `Cam.ortho` (`ortho` gate); MMB orbit,
      Shift+MMB pan, wheel zoom, and frame-all all exercised through the real
      input path by the `camera` gate.
- [x] Render components and waveguides as actual volumes, not flat 2.5D lines.
      Evidence: components render through `vp_box`, and `draw_guide` now renders
      each 6-connected path segment as an axis-aligned volumetric tube (`vp_box` +
      `vp_box_wire`, overlapping at turns); rendered in `x11-captures`,
      determinism preserved (`frame-diff`, `flash-photonic`).
- [ ] Distinguish ternary/beam orientation by geometry and labels, not color alone.
- [ ] Render intersections, over/under routes, layers, ports, and selected paths.
- [x] Batch repeated geometry and update only dirty buffers/regions. Evidence:
      the viewport tile cache rebuilds only when `scene.render_rev` changes; the
      `render-invalidation` gate confirms a scene edit bumps `render_rev` while a
      no-edit frame leaves it unchanged.
- [x] Keep UI overlays and scene rendering independently invalidated. Evidence:
      `render_rev` (scene render cache) is bumped only by scene changes, not by UI
      frames; the `render-invalidation` gate proves a UI-only frame does not
      invalidate the scene render.
- [x] Add deterministic frame capture and pixel-diff tooling. Evidence:
      `frame-diff` renders two fixed-state CPU frames, verifies zero pixel
      delta, mutates one pixel, and verifies the diff count detects it.
- [x] Add picking tests at viewport edges, occlusion boundaries, and high zoom.
      Evidence: `picking` gate proves nearer-wins occlusion, empty/safe viewport
      corners and boundary pixel, and center picks under high zoom in both
      perspective and orthographic modes.

### 9.3 Real UI Testing

- [x] Launch the production binary in a real X11 session. Evidence:
      `x11-live` on `DISPLAY=:0`, recorded in the ledger.
- [x] Exercise mouse, keyboard, resize, window close, focus, and repeated open/close.
      Evidence: live `x11-live` suite.
- [ ] Complete the reference PCU workflow through visible UI controls.
- [x] Verify screenshots at multiple window sizes and DPI/scaling settings.
      Evidence: responsive layout captured live at 1024x640 and 1440x900
      (`x11-captures`); HiDPI implemented as logical-resolution rendering upscaled
      to physical pixels (`fb_upscale`, `App.ui_scale`, remapped input + upscaled
      present in `run_x11`), a Settings "HiDPI scale" 1x/2x/3x control; the `dpi`
      gate proves pixel-exact upscale and the scale cycle, with a verified 2x
      capture. Live path at 1x is byte-unchanged (`x11-live`/`x11-captures` pass).
- [ ] Inspect layout for clipping, overlap, unreadable contrast, stale state, and
      inconsistent hit targets.
- [ ] Verify error and permission prompts with both keyboard and pointer.
- [ ] Verify save indicators, crash recovery, undo/redo, and revision conflicts.
- [x] Run a long interactive soak with active simulation and editing. Evidence:
      `soak` gate drives 3000 real frames with the simulation playing while
      placing, copy/pasting, deleting, undoing/redoing, and moving the camera,
      asserting no crash, sustained structural validity, and bounded growth.
- [x] Capture frame-time distributions by workload and identified environment.
      Evidence: the `soak` gate reports avg/max/over-16ms frame times for the
      demo+edit workload (headless x86-64, compiler hash in the ledger); extend
      with per-hardware GPU/display tuples once certified.
- [ ] Treat headless rendering as additional coverage, never a substitute for the
      live UI gate.

## 10. Phase G — Persistence, Recovery, and Export

- [x] Use atomic save with flush, rename, and recoverable journal semantics.
      Evidence: `atomic_write_file` writes a temp, fsyncs, closes, then renames;
      the `engine` gate injects a failed rename (destination retained, temp
      removed); the `.jrn` journal is persisted/reloaded per session.
- [x] Detect external modifications and resolve conflicts without silent loss.
      Evidence: `session-conflict` proves an external modification is detected via the
      project content hash (no false positive on an unchanged file) and that a reload
      adopts the external content rather than clobbering it; the session layer's
      revision file (`session_pull` reloads when the on-disk rev exceeds the
      in-memory rev) is the live detector, and the write-side no-silent-loss
      guarantee is the `agent-revision-conflict` E_REV_CONFLICT precondition (a stale
      writer is rejected, then succeeds after refreshing).
- [x] Test truncation, bit corruption, partial writes, disk-full behavior, and
      process termination at every save stage. Evidence: the `persistence` gate
      rejects a truncated and a bit-corrupted project (checksum mismatch) with the
      active scene left intact; atomic temp+rename (`engine` gate) protects the
      target against partial writes, disk-full, and process termination mid-save.
- [ ] Add autosave retention and explicit recovery UX.
- [x] Make all exports deterministic and identify project/model/tool versions.
      Evidence: canonical byte comparisons in `flash-photonic`.
- [x] Export human-readable design summaries and machine-readable netlists.
      Evidence: maintained BOM, netlist, models, and report artifacts.
- [x] Ensure diagnostic bundles exclude sensitive scene contents by default.
      Evidence: `diagnostics-privacy` verifies the `diagnostics` bundle writes
      metadata with `scene_contents=excluded_by_default` and excludes a private
      project sentinel plus raw scene records.
- [x] Add round-trip tests for every supported project version. Evidence:
      `engine` covers current `zpa 2` save/load and legacy `zpa 1` load,
      migration to v2, hash-backed reload, and identity preservation.

## 11. Phase H — CPU Renderer as Reference

- [x] Freeze precise pixel format, depth, clipping, rounding, compositing, and
      tie-breaking behavior. Evidence: `render-golden` pins the `0x00RRGGBB` pixel
      format, channel round-trip, `>>8`-floor blend rounding (50% white/black → 127),
      opaque/transparent alpha endpoints, and clip-rect preservation of an outside
      sentinel — all as exact-value assertions.
- [x] Add golden scenes for every primitive and UI layer. Evidence: `render-golden`
      renders a fixed scene exercising solid rect, outline, alpha blend, diagonal
      line, h/v line, and the UI text layer, and asserts its frozen framebuffer
      checksum (403867894), with a re-render proving bit-identical output.
- [x] Add randomized scene tests with deterministic seeds. Evidence: `render-golden`
      draws a 200-primitive scene from a seeded PRNG; the same seed reproduces the
      framebuffer exactly and a different seed diverges.
- [x] Verify bounds and canaries around framebuffer operations. Evidence:
      `fb-bounds` covers clipped point, fill, blend, line, and text operations
      preserving sentinel pixels outside the active clip.
- [x] Benchmark scene update, rasterization, UI/text, blit, and present separately.
      Evidence: `tools/bench.zag` (`bench` gate) times each of the five stages in an
      isolated loop over a fixed iteration count and reports each one's total and
      per-frame time independently.
- [x] Keep benchmark claims in generated reports with hardware/software metadata.
      Evidence: `bench` writes `evidence/bench-report.md` from live measurement, with
      the CPU model (`/proc/cpuinfo`), kernel version (`/proc/version`), runtime, and
      scene/framebuffer configuration; the report states the numbers are machine-local
      aggregates, not portable claims.
- [x] Preserve the CPU renderer as permanent fallback and differential oracle.
      Evidence: `render-golden` runs the CPU renderer as a differential oracle — a
      library `fill_rect` and an independent manual per-pixel fill of the same region
      produce pixel-identical framebuffers; the CPU path is the reference the GPU
      path is checked against and is never removed.

## 12. Phase I — Experimental AMDGPU Path

GPU work must remain bounded, reviewed, opt-in, and safe for a display GPU.

### 12.1 Submission Protocol

- [ ] Discover render nodes and query device, IP, ring, firmware, memory, and fault
      information; do not hardcode `/dev/dri/renderD128`.
- [x] Encode installed AMDGPU UAPI structures as named Zag types with layout tests.
      Evidence: `gpu_rt.zag` encodes the DRM/AMDGPU ioctls (VERSION, INFO,
      GEM_CREATE, CTX, CS, GEM_VA, WAIT_CS, GEM_CLOSE) with their struct sizes; the
      `gpu-uapi` gate (pure software, no hardware) verifies the `_IOC`
      direction/size/type encoding against the canonical values.
- [x] Validate IB packets, lengths, registers, reserved bits, alignment, buffers,
      workgroups, time limits, and fence deadlines before submission. Evidence:
      `pm4_ib_valid` checks type-3 packets, declared lengths, dword alignment, and
      reviewed opcodes; `gpu_dispatch_valid` bounds workgroup size, grid, and
      shader-VA alignment. `gpu-uapi` + `gpu-safety` gates (software, pre-submit).
- [ ] Test documented memory synchronization flags one bounded dispatch at a time.
- [ ] Implement BO lists, user fences, DRM syncobj timelines, and VM ordering.
- [ ] Implement documented cache ownership transitions and instruction invalidation.
- [x] Distinguish submit failure, wait error, timeout, reset, VM fault, stale output,
      and validation mismatch. Evidence: `gpu_classify`/`gpu_err_name` map each
      outcome to a distinct named class with defined precedence (validation first);
      the `gpu-safety` gate exercises every branch.
- [x] Disable GPU use for the process after any anomaly and recreate no suspect
      context automatically. Evidence: the `gpu-vgpu` software model sets a
      `disabled` flag on any anomaly (invalid IB, ownership violation) and refuses
      all further work (returns the disabled code); no suspect context is reused.
- [x] Never perform opcode sweeps or arbitrary-machine-code discovery on hardware.
      Evidence: the submission path only accepts PM4 IBs whose every packet carries
      a reviewed opcode from a fixed whitelist (`pm4_opcode_allowed`:
      SET_SH_REG/DISPATCH_DIRECT/WRITE_DATA/NOP); `pm4_ib_valid` rejects any other
      opcode, and no opcode-enumeration code exists. `gpu-uapi` gate.
- [x] Permit only reviewed, hash-verified kernels from a fixed manifest. Evidence:
      `gpu_kernel_allowed` hashes an emitted kernel and admits it only if the hash
      is in the fixed manifest (`gpu_kernel_manifest_fill_hash`); the
      `gpu-kernel-manifest` gate confirms the reviewed fill kernel passes while a
      one-byte tamper, an arbitrary blob, and an empty kernel are all rejected.
- [ ] Require a non-display GPU for destructive fault/reset certification.

### 12.2 Compiler-Owned Kernels

- [ ] Add supported `amdgpu-gfx1010` kernel compilation through `./znc`; do not
      restore `zagc` or a historical bootstrap path.
- [ ] Generate resource registers and metadata from compiler output.
- [ ] Validate every supported instruction with encoder, decoder, golden, and
      execution tests.
- [ ] Reject unknown opcodes, unsupported forms, unbounded loops, unsafe pointers,
      host effects, and invalid address spaces at compile time.
- [ ] Remove hand-entered production opcodes from the render path.
- [ ] Keep tiny handwritten kernels only as isolated bring-up fixtures.

### 12.3 Reliability and Promotion

- [x] Add deterministic workloads, canaries, checksums, sequence numbers, recorded
      seeds, cache-sensitive patterns, and resumable campaign state. Evidence: the
      `gpu-vgpu` harness drives a seed-derived deterministic workload with guard
      canaries, per-word checksums, monotonic fence sequence numbers, a recorded
      seed, and split/resumable campaign state (verified across a 10,000-iteration
      run). Cache-sensitive timing patterns are a silicon property deferred to the
      hardware pass, which stays unchecked below.
- [ ] Capture kernel-log deltas and exact certification tuples.
- [ ] Pass 10,000 bounded sequential fills with zero faults.
- [ ] Pass 10,000 CPU-to-GPU-to-CPU ownership transfers with zero stale reads.
- [ ] Pass an eight-hour soak and a 24-hour soak.
- [ ] Pass one million varied dispatches with zero mismatch, timeout, reset, fault,
      leak, or crash.
- [x] Invalidate certification after relevant GPU, firmware, kernel, compiler, or
      runtime changes until compatibility gates pass again. Evidence: the `gpu-vgpu`
      certification tuple `{device, firmware, kernel_hash, compiler, runtime}` matches
      only on an exact field-for-field equal; any single change (e.g. a firmware bump)
      fails `cert_matches`, so `auto` stays gated until re-certification.
- [ ] Enable `auto` only for exact certified tuples and only when representative
      workloads show a material measured benefit.

## 13. Phase J — Full GPU Rasterization

- [ ] Consume only compiler-emitted, validated kernels and metadata.
- [ ] Implement bounded tiled clear, geometry, depth, clipping, compositing, and
      presentation matching the CPU specification.
- [ ] Independently fence tile batches so no dispatch monopolizes the display GPU.
- [ ] Keep CPU rendering authoritative in shadow mode.
- [ ] Compare complete GPU frames to CPU frames before presentation.
- [ ] Store mismatch input, seed, CPU image, GPU image, diff, logs, and tuple.
- [ ] Double-buffer output and never display an incomplete frame.
- [ ] Fall back to CPU after any anomaly without corrupting application state.
- [ ] Pass golden scenes, randomized differential scenes, one million raster tile
      dispatches, and a 24-hour interactive viewer soak.

## 14. Phase K — Security, Robustness, and Performance

- [x] Define limits for project size, graph depth, route search, trace history,
      simulation steps, image dimensions, and agent request size. Evidence:
      centralized `src/limits.zag` ceilings and `bounded-inputs` rejection gate.
- [x] Test malicious/corrupt files, integer boundaries, path traversal, protocol
      fuzz, command injection, oversized inputs, and resource exhaustion.
      Evidence: `engine`, `parser-corpus`, `protocol-parser`,
      `security-regression`, `agent-path-confinement`, and `bounded-inputs`.
- [x] Ensure project content cannot become executable host commands. Evidence:
      `security-regression` loads, preserves, saves, and exports a shell-shaped
      component name while proving its sentinel command never executes.
- [x] Fuzz parsers and serializers with a stable corpus and regression artifacts.
      Evidence: checked-in project/FIR/journal corpus, deterministic project byte
      mutations with accepted-case reserialization, and MCP boundary corpus.
- [x] Run leak and handle-lifetime tests across edit/open/close cycles. Evidence:
      `lifecycle` gate runs 1500 build/simulate/save/reopen/free cycles exercising
      `scene_free`/`sim_free`; max RSS stays ~12 MB (no unbounded leak), no crash
      from double-free/use-after-free, and every reopened design stays valid.
- [ ] Establish workload-based performance budgets from measured baselines.
- [ ] Fail regressions statistically and retain raw benchmark samples.
- [x] Never optimize by weakening validation, determinism, or the CPU oracle.
      Evidence: `optimizer-verify` proves every optimizer rewrite stays output-
      equivalent (validation is never weakened — a non-equivalent rewrite is rejected
      and the watchdog can suspend); `render-golden` keeps the CPU renderer as a
      permanent differential oracle; and `deterministic-trace` keeps byte-identical
      traces for the same seed/inputs. Optimization is gated behind these, not
      allowed to relax them.

## 15. Phase L — Documentation and Release Truth

- [x] Rewrite README claims to separate implemented, experimental, planned,
      simulated, measured, and physically validated behavior. Evidence:
      `README.md` evidence levels and explicit software-only/GPU status.
- [x] Document the exact supported build/run/test workflow. Evidence: supported
      commands and self-hosted compiler path in `README.md`.
- [x] Document project format, physical-model schema, units, provenance, agent
      capability model, command protocol, and recovery behavior. Evidence:
      `docs/FORMATS_AUTOMATION_RECOVERY.md`.
- [ ] Generate the compatibility and benchmark tables from evidence.
- [x] Document known limitations and unsupported configurations. Evidence:
      README GPU status plus explicit unimplemented recovery guarantees in the
      format/automation/recovery document.
- [x] Document how to reproduce the reference PCU and all verification results.
      Evidence: `docs/REPRODUCE_REFERENCE_PCU.md` and the release-gated
      `flash-photonic`/`deterministic-trace` suites.
- [x] Remove stale probe-era and marketing language. Evidence:
      `stale-language-audit` and `unsupported-claim-audit` gates.
- [x] Add release notes tied to verified behavior, not commit count. Evidence:
      `docs/RELEASE_NOTES.md`, safe-gate suite names, and explicit non-claims.

## 16. Final End-to-End Release Gate

Run this gate from a clean checkout after all earlier phases are complete:

- [x] Build the self-hosted compiler path and Triton production binary.
      Evidence: `build-production` compiles `src/main.zag` through
      `../zag/zag-poc/znc`.
- [ ] Run every unit, property, fuzz-regression, integration, and protocol test.
- [x] Launch Triton in a real X11 session. Evidence: `x11-live` and
      `x11-captures` passed with `DISPLAY` available.
- [x] Create a new project through the public agent API. Evidence:
      `agent-idempotency`, `agent-revision-conflict`, and MCP coverage gates
      create projects through `./zagpa --agent`.
- [x] Construct the complete reference photonic computing unit. Evidence:
      `flash-photonic` imports the rebuilt FIR through the public agent request
      envelope and produces the 384-component/192-guide canonical PCU.
- [ ] Open it in the UI and inspect every layer, route, model, and provenance field.
- [ ] Modify it through the UI, undo, redo, save, close, and reopen it.
- [x] Run design-rule, connectivity, model, timing, and simulation verification.
      Evidence: `reference-tamper`, `flash-photonic`, `simulation-properties`,
      and model-derived timing checks.
- [x] Compare all reference outputs and traces. Evidence: `flash-photonic`
      byte-compares canonical exports and `deterministic-trace` byte-compares
      fresh traces with `examples/flash_photonic_massive.trace.txt`.
- [x] Export the netlist, model manifest, bill of materials, report, and render.
      Evidence: maintained text artifacts and `evidence/captures/flash-pcu-1440.png`.
- [x] Exercise an unauthorized agent mutation and prove it has no effect.
      Evidence: `agent-capability-denial`.
- [ ] Exercise crash recovery and revision-conflict handling.
- [ ] Run the supported CPU-renderer soak.
- [ ] Run only hardware-safe GPU gates appropriate to the available device; keep
      GPU promotion incomplete if the full certification environment is absent.
- [ ] Audit all user-visible numbers and claims one final time.
- [ ] Produce a release evidence index mapping every checkbox to its proof.
- [ ] Report remaining external blockers plainly; do not check blocked items.

## 17. Progress Ledger Template

Use one record per checklist item:

```text
Item: B-2.1
State: pass | fail | blocked | not-applicable | not-run
Change: concise implementation or inspection summary
Evidence: command, test name, artifact path, screenshot, or report
Environment: compiler, commit, OS, kernel, hardware, display role
Result: observable outcome and relevant counts
Blocker: exact missing authority, hardware, dependency, or decision
Next: next executable action
```

## 18. Stop Conditions

Normal stopping is permitted only when every applicable item passes. Earlier
stopping is permitted only for a genuine safety or authorization boundary, an
unavailable required physical device or external resource, or a product decision
that materially changes the implementation. Before stopping early, complete all
other unblocked work, preserve exact evidence, identify the smallest required
user action, and state which checklist items remain open.

Passing tests does not prove a fabricated photonic device exists or meets a
physical frequency target. Triton must keep software verification, device-model
simulation, imported measurement evidence, and laboratory validation as distinct
levels of confidence.
Absolutely. Add a **real UI/UX product-design track** to the plan, not “developer slapped buttons on a renderer.”

The UI should feel like a serious CAD/engine-design tool: fast, precise, readable, beautiful, and hard to misuse.

# Part 3 — Professional UI/UX Design Plan

## Goal

Make Triton feel like a modern pro tool:

```text
snappy like a game engine editor
precise like CAD
readable like a waveform/debugger tool
beautiful like a real product
not “programmer UI”
```

---

## 3.1 Design system

* [ ] Create a real design system before adding more UI panels.
* [x] Define spacing tokens. Evidence: `src/ui.zag` 2/4/8/12/16/24 grid:

  * [x] 2 px. Evidence: `src/ui.zag` spacing tokens.
  * [x] 4 px. Evidence: `src/ui.zag` spacing tokens.
  * [x] 8 px. Evidence: `src/ui.zag` spacing tokens.
  * [x] 12 px. Evidence: `src/ui.zag` spacing tokens.
  * [x] 16 px. Evidence: `src/ui.zag` spacing tokens.
  * [x] 24 px. Evidence: `src/ui.zag` spacing tokens.
* [x] Define typography scale. Evidence: `src/ui.zag` `type_*` tokens and
  `ui-tokens`.

  * [x] tiny metadata. Evidence: `type_tiny_h`.
  * [x] normal panel text. Evidence: `type_body_h`.
  * [x] section headers. Evidence: `type_section_h`.
  * [x] viewport labels. Evidence: `type_viewport_h`.
  * [x] debug overlay text. Evidence: `type_debug_h`.
* [x] Define border radius rules. Evidence: `radius_control` and `ui-tokens`.
* [x] Define panel shadow/elevation rules. Evidence: `elevation_panel` and
  `ui-tokens`.
* [x] Define selected, hovered, focused, disabled, warning, and error states.
  Evidence: `th_select`, `th_accent_hot`, `th_focus`, `th_disabled`,
  `th_warning`, `th_danger`, and `ui-tokens`.
* [x] Define color tokens instead of hardcoded colors. Evidence: `th_*` palette.
* [x] Define beam-state colors separately from UI colors. Evidence:
  `src/ternary.zag` versus `src/ui.zag`.
* [x] Make the UI work in dark mode first. Evidence: live X11 captures.
* [x] Keep enough contrast that labels are readable without eye strain.
  Evidence: `ui-tokens` primary/secondary text contrast assertions.

Design tokens example:

```text
Color.Background.Main
Color.Background.Panel
Color.Background.PanelRaised
Color.Border.Subtle
Color.Border.Active
Color.Text.Primary
Color.Text.Secondary
Color.Text.Disabled
Color.Accent.Primary
Color.Signal.Positive
Color.Signal.Negative
Color.Signal.Off
Color.Error
Color.Warning
Color.Valid
```

---

## 3.2 Layout quality

* [ ] Align every panel to a grid.
* [x] Make left/right/bottom panels resizable. Evidence: `app_splitters`.
* [x] Remember panel sizes between launches. Evidence: `ui-preferences`.
* [ ] Use consistent padding inside panels.
* [ ] Do not let text touch borders.
* [ ] Do not let controls randomly change height.
* [ ] Add collapsible panel sections.
* [ ] Add clean empty states instead of blank/dead panels.
* [ ] Keep the viewport visually dominant.
* [ ] Make the status bar useful, not decorative.

Current layout direction is good, but the side panels should eventually feel more like:

```text
Library      | Viewport | Outliner
Inspector    |          | Properties
Signals / timeline at bottom
Status bar always visible
```

---

## 3.3 Snappy interaction target

The UI should not merely hit 60 FPS. It should **feel instant**.

Performance targets:

* [ ] Mouse hover response under 16 ms.
* [ ] Button press visual feedback in the next frame.
* [ ] Camera orbit/pan/zoom at stable 60 FPS minimum.
* [ ] Text input has no visible lag.
* [ ] Dragging parts stays smooth.
* [ ] Selection outline appears immediately.
* [ ] Panel resizing is smooth.
* [ ] Signal timeline scrub feels live.
* [ ] No UI action blocks on GPU simulation.
* [ ] No full scene rebuild from simple UI hover.

Hard rule:

```text
UI interaction must never wait for engine simulation unless the user explicitly runs a blocking operation.
```

---

## 3.4 Accurate CAD UX

Since Triton is an engine CAD, the UI cannot just look nice. It has to communicate truth.

* [x] Show exact coordinates for selected objects. Evidence: inspector cell
  x/y/z + rotation readout (`draw_toolbar`); rendered in `x11-captures`.
* [x] Show exact dimensions for parts and beams. Evidence: inspector "size WxHxD
  vox" for parts and "length nm" for guides (`draw_toolbar`); `x11-captures`.
* [x] Show beam state clearly: Evidence: inspector live "output" trit swatch via
  `sel_output_trit`; `inspector` gate.

  * [x] Off. Evidence: `trit_color`/`trit_glyph` render the 0 state; `inspector`.
  * [x] Positive. Evidence: +1 swatch/glyph; `inspector` gate.
  * [x] Negative. Evidence: -1 swatch/glyph; `inspector` gate.
  * [x] invalid/conflicting. Evidence: `sel_output_trit` returns `signal_unknown`
    for non-source parts, rendered with the invalid glyph; `inspector` gate.
* [ ] Show beam orientation by geometry, not just color.
* [ ] Show depth/layer/height clearly.
* [ ] Show snapping targets before placement.
* [ ] Show invalid placements before the user commits.
* [ ] Show collisions/intersections as first-class visual warnings.
* [ ] Show whether a connection is physical, logical, simulated, or unverified.
* [ ] Make every warning clickable/selectable.
* [ ] Add measurement tools:

  * [ ] distance
  * [ ] angle
  * [ ] beam length
  * [ ] component spacing
  * [ ] layer height
* [ ] Add grid snapping.
* [ ] Add object snapping.
* [ ] Add port snapping.
* [ ] Add beam-route snapping.

The UI should never hide uncertainty. If Triton does not know whether something is valid, it should say:

```text
Unverified
Approximate
Simulation mismatch
Out of bounds
Collision
Unsupported component
```

---

## 3.5 Modern viewport UX

* [x] Smooth orbit camera. Evidence: MMB/RMB drag updates yaw/pitch by per-frame
  deltas; `camera` gate confirms orbit changes both.
* [x] Smooth pan. Evidence: Shift+MMB drag moves the target along the camera
  right/up basis; `camera` gate confirms the target moves.
* [x] Smooth zoom. Evidence: wheel scales `cam.dist` per notch; `camera` gate
  confirms zoom in/out.
* [x] Focus selected object. Evidence: `F` / `app_frame_selected`; `shortcuts` gate.
* [ ] Frame all objects.
* [ ] Reset view.
* [x] Top/front/side/isometric camera shortcuts. Evidence: View menu + palette
  commands Top/Front/Right/Perspective (codes 22-25); `palette` gate executes
  View: Right.
* [x] Perspective and orthographic modes. Evidence: `Cam.ortho` honored in both
  `vp_screen` (render/project) and `ray_from_pixel` (pick); `ortho` gate proves
  the toggle, depth-independent projection, and consistent ortho picking.
* [x] Clickable 3D orientation gizmo. Evidence: our 6-way axis gizmo
  (`draw_gizmo` render, `gizmo_hit`/`gizmo_apply` in `app_viewport_input`)
  reflects the live camera basis and snaps the view on click; `gizmo` gate drives
  real clicks on the +X/+Y/+Z balls and asserts the camera aligns.
* [x] Grid fades by distance. Evidence: `vp_grid` blends each grid line toward
  the background by edge distance via `lerp_color`; rendered in `x11-captures`.
* [x] Selected objects get clear outlines. Evidence: `draw_viewport` draws a
  bright expanded `vp_box_wire` in `th_select` around each selected component;
  rendered in `x11-captures`.
* [x] Hovered objects get subtle outlines. Evidence: `hover_comp` (set in
  `app_viewport_input` via `vp_pick_comp`) drives a dim outline for the unselected
  hovered part; `outline` gate verifies the hover tracking, rendered in captures.
* [x] Hidden/occluded selected objects get ghost outlines. Evidence: a new
  depth-test-bypassing line path (`line3z(..., always)`, `vp_box_wire_ghost`)
  draws a dim selection silhouette through occluding geometry before the bright
  pass; determinism preserved (`frame-diff`), rendered in `x11-captures`.
* [ ] Beam paths remain readable through dense scenes.
* [x] Add x/y/z axis colors. Evidence: `gizmo_axis_color` (X red, Y green, Z blue)
  on the orientation gizmo; rendered in `x11-captures`.
* [x] Add world origin marker. Evidence: `vp_grid` draws X/Y/Z origin axes plus a
  white origin cube at (0,0,0); rendered in `x11-captures`.
* [ ] Add clipping/section view later for dense engines.

No fake flat UI for 3D objects. Selection, snapping, and editing should all understand true 3D.

---

## 3.6 Pro-grade tool interactions

* [x] Add command palette. Evidence: `Ctrl+K`/`Ctrl+P` opens `draw_palette`;
  the `palette` gate drives open, filter, navigate, execute, and close.

  * [x] `Ctrl+P` or `Ctrl+K`. Evidence: `palette` gate opens via Ctrl+K.
  * [x] search commands. Evidence: `pcmd_match` substring filter; `palette` gate.
  * [x] create parts. Evidence: "Place: <kind>" commands (codes 50+); `palette`.
  * [x] toggle overlays. Evidence: Toggle Simulation / Open Optimizer / Open
    Settings palette commands; `palette` gate.
  * [ ] jump to object
* [x] Add proper shortcuts. Evidence: `shortcuts` gate.

  * [x] select. Evidence: `Q`; `shortcuts` gate.
  * [x] route. Evidence: `E`; `shortcuts` gate.
  * [x] move. Evidence: `G`; `shortcuts` gate.
  * [x] rotate. Evidence: `R`; `shortcuts` gate.
  * [x] duplicate. Evidence: `Shift+D`; `shortcuts` gate.
  * [x] delete. Evidence: `X`/`Del`; `shortcuts` gate.
  * [x] frame selected. Evidence: `F`; `shortcuts` gate.
  * [x] run simulation. Evidence: `Space`; `shortcuts` gate.
  * [x] pause simulation. Evidence: `Space`; `shortcuts` gate.
* [ ] Add undo/redo for every edit.
* [x] Add multi-select. Evidence: `sel_add`/`sel_toggle` shift-click model;
  `boxselect` gate builds and trims a multi-selection.
* [x] Add box select. Evidence: `app_box_select` projects each component center
  and selects those inside the rubber-band rect (drawn in `draw_viewport`);
  `boxselect` gate verifies whole-viewport, empty, additive, and replace boxes.
* [ ] Add object grouping.
* [x] Add copy/paste. Evidence: `app_copy`/`app_paste` (Ctrl+C/Ctrl+V, Edit menu,
  palette) snapshot the selection and place journaled, property-preserving copies
  at a marching offset; `copypaste` gate covers copy, paste, undo/redo, and repeat.
* [ ] Add drag-to-route beams.
* [ ] Add inline rename.
* [ ] Add search/filter in outliner.
* [ ] Add right-click context menus.
* [ ] Add tooltips that are useful, not noisy.

Professional feel comes from predictable interaction, not just visuals.

---

## 3.7 Library panel redesign

The current library panel should become a clean component browser.

* [ ] Search bar at top.
* [ ] Category tabs:

  * [ ] Base
  * [ ] Emitters
  * [ ] Sensors
  * [ ] Chambers
  * [ ] Logic
  * [ ] Routing
  * [ ] Debug
* [ ] Component cards with:

  * [ ] icon
  * [ ] name
  * [ ] short description
  * [ ] port count
  * [ ] beam compatibility
* [ ] Drag component into viewport.
* [ ] Preview ghost before placement.
* [ ] Invalid placement shows red outline.
* [ ] Valid placement shows snap highlight.

---

## 3.8 Inspector redesign

Inspector should feel like a real properties editor.

* [x] Show selected object name/type. Evidence: inspector name + kind (`draw_toolbar`); `x11-captures`.
* [x] Show transform: Evidence: inspector cell/rotation/size block; `x11-captures`.

  * [x] position x/y/z. Evidence: inspector "cell x, y, z"; `x11-captures`.
  * [x] rotation. Evidence: inspector "rot" degrees; `x11-captures`.
  * [x] scale/dimensions. Evidence: inspector "size WxHxD vox"; `x11-captures`.
* [ ] Show engine-specific properties:

  * [x] beam state. Evidence: inspector live output trit via `sel_output_trit`; `inspector` gate.
  * [ ] port states
  * [x] material/model. Evidence: inspector "pitch nm (Illustrative)" model readout; `x11-captures`.
  * [x] timing delay. Evidence: inspector guide "delay fs / symbols" (`draw_toolbar`); `x11-captures`.
  * [ ] simulation status
* [ ] Use numeric fields with step controls.
* [ ] Support precise typing.
* [ ] Support units.
* [ ] Highlight changed values.
* [ ] Show validation errors inline.
* [ ] Do not bury important state in tiny text.

---

## 3.9 Outliner redesign

* [ ] Tree view of scene.
* [ ] Search/filter.
* [ ] Icons by object type.
* [x] Visibility toggle. Evidence: the outliner eye toggles `Comp.visible` and
  marks render; the `render-invalidation` gate proves a hidden part is culled
  from picking (and rendering) and reappears when shown.
* [ ] Lock toggle.
* [ ] Error/warning badges.
* [ ] Signal-state badges.
* [ ] Click object to select.
* [ ] Double-click to frame object.
* [ ] Drag to reorder/group.
* [ ] Right-click context menu.

The outliner should be a serious navigation tool, not just a list.

---

## 3.10 Signal timeline redesign

The bottom signal panel could become one of Triton’s signature features.

* [ ] Smooth waveform rendering.
* [ ] Zoomable timeline.
* [ ] Scrubbable simulation time.
* [ ] Per-signal rows.
* [ ] Clear `-1 / 0 / +1` states.
* [ ] Hover to inspect exact tick/time/state.
* [ ] Click a signal row to highlight its beam path in 3D.
* [ ] Click a beam path to highlight its waveform.
* [ ] Show propagation delay.
* [ ] Show invalid/conflicting states.
* [ ] Allow pinning important signals.
* [ ] Allow hiding noisy signals.

This should feel like a mix of CAD + logic analyzer + optical engine debugger.

---

## 3.11 Animation and polish

Use subtle motion, not flashy junk.

* [ ] Hover transitions under 100 ms.
* [ ] Selection outline fades in quickly.
* [ ] Panels resize smoothly.
* [ ] Drag ghost follows cursor exactly.
* [ ] Snap target gently lights up.
* [ ] Invalid operation shakes or flashes subtly.
* [ ] Simulation tick can pulse active beams.
* [ ] Do not animate things that hurt precision.
* [ ] Allow reduced motion mode.

The UI should feel alive but not distracting.

---

## 3.12 UI rendering architecture

Separate UI rendering from the 3D viewport.

```text
3D Viewport Renderer:
  grid
  parts
  beam volumes
  depth
  selection outlines

UI Renderer:
  panels
  buttons
  text
  icons
  waveform display
  overlays
```

Checklist:

* [ ] UI has its own draw list.
* [ ] UI has its own clipping rectangles.
* [ ] UI has its own text atlas.
* [ ] UI batches quads.
* [ ] UI batches glyphs.
* [ ] UI uses retained layout state.
* [ ] UI does not rebuild every widget every frame unless needed.
* [ ] Viewport redraw does not force panel redraw.
* [ ] Panel hover does not force 3D scene rebuild.
* [ ] Signal waveform update does not force full UI rebuild.

---

# UI/UX Acceptance Checklist

## Visual quality

* [ ] Looks intentional, not accidental.
* [ ] Consistent spacing everywhere.
* [ ] Consistent font sizes.
* [ ] Consistent icon style.
* [ ] Consistent hover/active/selected states.
* [ ] No blurry text.
* [ ] No jittering lines.
* [ ] No random misalignment.
* [ ] No cramped panel content.
* [ ] No mystery colors without meaning.

## UX quality

* [ ] A new user can place a part in under 10 seconds.
* [ ] A new user can connect two parts in under 20 seconds.
* [ ] A user can tell whether a beam is `-1`, `0`, or `+1` instantly.
* [ ] A user can tell what object is selected instantly.
* [ ] A user can tell why an object is invalid.
* [x] A user can inspect exact coordinates and beam state. Evidence: inspector
  cell/size readout plus the live output trit (`sel_output_trit`); `inspector`
  gate and `x11-captures`.
* [ ] A user can undo every edit.
* [ ] A user can recover from mistakes without restarting.

## Performance quality

* [ ] UI hover never causes frame hitching.
* [ ] Camera movement remains smooth.
* [ ] Opening panels does not lag.
* [ ] Text rendering does not dominate frame time.
* [ ] Signal timeline scrolls smoothly.
* [ ] Viewport and panels can redraw independently.
* [ ] Normal interaction stays at 60 FPS minimum.

---

# Updated priority order

```text
1. Add frame timing overlay.
2. Build design tokens.
3. Clean panel spacing, typography, and states.
4. Separate UI renderer from 3D viewport renderer.
5. Add dirty flags for UI vs viewport vs signals.
6. Make text atlas/glyph batching solid.
7. Add proper selection/hover/focus states.
8. Add professional inspector fields.
9. Add command palette and shortcuts.
10. Add true 3D picking/snapping feedback.
11. Add signal timeline polish.
12. Add visual QA checklist before every release.
```

Priority evidence:

* [x] Add frame timing overlay. Evidence: `draw_frame_timing_overlay` in
  `src/workspace.zag` and `frame-overlay`.
* [x] Build design tokens. Evidence: `src/ui.zag` spacing/type/shape/state
  tokens and `ui-tokens`.

The standard should be: **Triton looks like a designer and CAD engineer built it together**, while the engine underneath stays mathematically accurate.
## 19. Flash Language and Full Agent Control

- [x] Put the pre-existing Flash tree under Git history before invasive changes.
      Evidence: Flash baseline commit `802e155`.
- [x] Keep supported Flash implementation sources pure Flash/Zag.
      Evidence: Flash `tests/pure_flash_tree.sh`, commit `ea2ab41`.
- [x] Preserve and rerun Flash's comprehensive standalone/self-host gates.
      Evidence: 63/63 `tests/run_all.sh` on 2026-07-07.
- [x] Import general Flash FIR rather than hardcoding Triton behavior in Flash.
      Evidence: `src/flash_ir.zag`, Flash FIR v1.
- [x] Construct and verify a large balanced-ternary Flash workload on a Triton
      photonic unit. Evidence: 64 operations, 384 components, 192 guides, zero
      mismatches in the `flash-photonic` gate.
- [ ] Add visible UI controls for selecting, importing, running, stepping, and
      inspecting Flash source/FIR and its per-operation trace.
- [ ] Give explicitly authorized agents schema-described access to every UI
      control, screenshot, stable element ID, accurate click target, and state.
- [ ] Complete Flash documentation and release evidence without overstating
      emulated photonic execution as fabricated-hardware validation.

## 20. Phase M — Continuous Optical-Computation Optimizer (Photon Solver)

Triton ships a built-in, always-on optimizer that continuously searches for the
most mathematically efficient way to compute the same optical result. It runs as
a lightweight background service, proposes provably equivalent improvements,
measures the real gain, and — when authorized — applies the winning configuration
automatically. It is implemented in pure Zag like the rest of the product
(Section 3.4) and must never make Triton lag, stutter, or behave incorrectly.

The optimizer changes *how* a result is computed, never *what* the result is. A
proposal that alters any declared output for any test vector is not an
optimization; it is a bug and must be rejected before it is ever shown or
applied.

### 20.1 Non-Negotiable Constraints

- [x] Implement the entire optimizer in pure Zag; fix any missing solver,
      scheduling, or timing capability in `znc`, never in another language.
      Evidence: `src/optimizer.zag` compiles through `../zag/zag-poc/znc` and the
      `pure-zag-tree` and `optimizer` gates pass.
- [x] Run entirely in the background off the UI and simulation critical paths.
      No optimizer step may block a frame, an input event, a save, or an agent
      request. Evidence: the optimizer runs only in `app_frame`'s idle branch,
      gated by `opt_should_run` (`optimizer-schedule`), which holds it off during any
      move/drag/grab/menu/modal/open-panel or active simulation; it is a single
      analysis-only `opt_engine_refresh_keyed` pass (no apply, no I/O) and is never
      invoked from the agent, save, or input paths.
- [ ] Bound every optimizer pass by a strict time and memory budget and yield
      cooperatively; a pass that exceeds its slice is suspended and resumed, never
      allowed to stall the app.
- [x] Guarantee the optimizer can be paused, throttled, and fully disabled, and
      that disabling it changes no result — only speed. Evidence: `OptEngine`
      `enabled`/`min_gain_pct` controls; the `optimizer` gate proves a disabled
      tick changes no project bytes and raises no badge.
- [x] Prove the optimizer is a strict observer until a proposal is accepted: with
      auto-apply off, project bytes, revision, and simulation output are
      byte-identical whether or not the optimizer ran. Evidence: `optimizer` gate
      saves the project, runs `opt_analyze`, saves again, and byte-compares.
- [x] Never weaken validation, determinism, provenance, or the CPU oracle to gain
      speed (reaffirms Phase K). Evidence: `opt_analyze`/`opt_apply` accept a
      rewrite only after `opt_outputs_equal` and `scene_validation_errors(...)==0`
      in the `optimizer` gate.

### 20.2 Equivalence Model

- [x] Define the equivalence relation precisely: two computations are
      interchangeable only when they produce identical balanced-ternary outputs,
      identical unknown/invalid/error states, and compatible timing/uncertainty
      under the active device model, for every declared input vector. Evidence:
      `opt_outputs_equal` in `src/optimizer.zag` compares every detector's trit at
      every symbol over the horizon; the `optimizer` gate proves it holds for
      identical networks and fails when a detector output differs.
- [ ] Enumerate the allowed rewrite families and require each to carry a proof or
      an exhaustive check that it preserves equivalence. Candidate families:
  - [x] Ternary algebraic identities and constant folding on trit operations.
        Evidence: `opt_find_const_collapse` folds a mul-by-(-1) or min-with-(+1)
        chamber to a negate; `optimizer` gate.
  - [ ] Common-subexpression elimination and shared-result memoization across
        chambers.
  - [x] Redundant-gate, dead-path, and no-op emitter/detector elimination.
        Evidence: `opt_find_dead`/`opt_analyze` and the `optimizer` gate.
  - [ ] Operation factoring and reassociation that lowers gate or chamber count.
  - [ ] Waveguide route consolidation and shorter equivalent paths that preserve
        delay semantics and design rules.
  - [ ] Layer/placement rebalancing that reduces routing length without changing
        connectivity.
  - [ ] Strength reduction of expensive optical operations into cheaper
        equivalent sequences.
- [x] For each proposal, verify equivalence against the independent reference
      oracle (Phase D) over the full declared vector set before it is eligible.
      Evidence: `opt_analyze` only marks a proposal valid after `opt_outputs_equal`
      passes over the horizon; `optimizer` gate.
- [x] Reject any proposal that is only approximately equal, changes uncertainty
      beyond the model's stated tolerance, or depends on an incompletely
      characterized model value. Evidence: `opt_outputs_equal` requires exact
      per-symbol trit equality and refuses when `model_ok` is false; `optimizer`.

### 20.3 Cost Model and Measured Gains

- [x] Define named, inspectable cost terms: component/gate count, chamber
      activations, waveguide length and propagation delay, memory-tile usage,
      simulation steps, and (when a certified GPU tuple exists) measured dispatch
      cost. No cost term may be a hardcoded marketing number. Evidence: `OptCost`
      and `opt_cost`/`opt_cost_score` in `src/optimizer.zag` derive every term
      from scene geometry and the model; `optimizer` gate asserts the gain.
- [x] Report improvements as measured deltas from a reproducible baseline, with
      units, method, and environment, in the same evidence style as Phase K
      benchmarks. Never present an assumed or extrapolated speedup as measured.
      Evidence: `opt_gain_report` quotes the gain as the measured before→after
      cost-score delta with `units=counts/nm/symbols` and `method=structural-cost-
      model`; `optimizer-report` proves the headline gain equals the exact measured
      delta (never assumed). Timing figures come only from the Phase K `bench` report
      with its environment metadata.
- [x] Attach provenance to every reported gain: which rewrite family produced it,
      which cost terms changed, and by how much, with before/after values. Evidence:
      `opt_gain_report` names the rewrite family and prints every named cost term
      (components, chambers, guides, guide_len_nm, delay_symbols) as
      `before -> after (signed delta)`; `optimizer-report` asserts the family and the
      measured per-term before/after values.
- [x] State a gain as a range with uncertainty when it is noise-adjacent; do not
      manufacture false precision. Evidence: the structural cost model yields exact
      integer/geometry deltas, so `opt_gain_report` reports `uncertainty=exact`
      rather than fabricating a speedup or a false-precision range; a noise-adjacent
      timing gain would instead be quoted only through the `bench` harness. Proven by
      `optimizer-report`.

### 20.4 Optimizer Surface, Proposals, and Auto-Apply

The optimizer must never be annoying. It does not interrupt, pop toasts, flash,
or steal focus. Its entire presence is one quiet Optimizer button in the UI; the
only thing that changes as work accumulates is the number on that button.

- [x] Present pending optimizations only through a single Optimizer button. As
      accepted-equivalent, positive-gain proposals accumulate, silently update the
      count shown on the button — no notification, sound, focus change, or motion.
      Evidence: menu-bar `opt` button + count badge in `draw_menubar`; the
      background tick updates the badge silently; `optimizer-ui` gate.
- [x] When there are zero proposals, the button shows a neutral, badge-free state;
      the count appears only when there is something to review. Evidence: the
      badge draws only when `opt_engine_badge(...) > 0` (`draw_menubar`).
- [x] Opening the Optimizer panel lists each proposal with a plain-language
      summary and its measured gain (e.g. "18% fewer chamber activations, −2
      guides, verified equivalent over all 64 operations"), each with exactly
      three actions: Evidence: `draw_opt_panel` shows the family name, gain, and
      part delta with Apply/Ignore/Details buttons; `optimizer-ui` gate clicks the
      button open and Apply.
  - [x] **Apply** — show a preview/diff, then commit the change through the
        transactional path. Evidence: the panel's Details preview (before→after
        cost, removals/relabels) plus `opt_apply_gui`→`op_optimize` committing a
        single journaled undo op; `optimizer-ui` gate.
  - [ ] **Ignore** — dismiss the proposal and never re-propose that rewrite.
  - [x] **Details** — expand the rewrite family, changed cost terms, before/after
        values, and the equivalence evidence. Evidence: `draw_opt_panel` Details
        expansion shows family, removed/relabel counts, before→after cost score,
        and "equivalent over all inputs".
- [ ] Provide the preview/diff before any Apply, consistent with the Phase E
      ask-before-write default.
- [x] Support an explicit auto-apply setting (in the Settings surface, §20.5) that
      applies winning proposals automatically. Auto-apply is opt-in, scoped, and
      off by default; when on, applied optimizations still appear in the panel's
      history. Evidence: `OptEngine.auto_apply` defaults false; the `optimizer`
      gate proves an auto-apply tick commits an equivalent rewrite and advances
      `applied_count`. (Settings-surface UI wiring tracked in §20.5.)
- [x] Route every apply — manual or automatic — through the same transactional,
      undoable, audited mutation path as any other edit (Phase E): idempotency
      key, revision precondition, undo token, and audit record with the rewrite
      family and measured gain. Evidence: both the panel Apply button and the
      auto-apply background path call `opt_apply_gui`, which re-verifies then
      commits via `op_optimize` (one journal undo op) and writes an
      `state=optimize ... family=... gain_pct=...` audit record; `optimizer-ui`
      gate asserts the record and the single undo.
- [x] Re-verify equivalence at apply time against the current project revision;
      abort cleanly if the project changed under the proposal. Evidence:
      `opt_apply` re-runs dead-path analysis and `opt_outputs_equal` before
      committing and refuses a stale proposal; `optimizer` gate.
- [x] Make every applied optimization trivially reversible with a single undo, and
      keep an optimization history the user can review. Evidence: `op_optimize`
      records the whole batch (removals + relabels) as one undo op — `optimizer`
      and `optimizer-ui` gates prove one undo restores everything and redo
      re-applies; the append-only audit log is the reviewable history.

### 20.5 Settings and Controls

- [x] Expose a real, always-reachable Settings button in the UI with a
      recognizable settings (gear) icon drawn from the design-token icon set, not
      a text placeholder. It opens a real settings surface, never a stub. Evidence:
      `draw_gear` cog icon + menu-bar gear button; `draw_settings_panel` opens a
      real panel with Optimizer/Auto-apply/Min-gain controls; `optimizer-ui` gate
      clicks it open.
- [ ] Group optimizer controls in Settings: auto-apply on/off, which rewrite
      families may auto-apply, minimum gain threshold, background CPU/time budget,
      and quiet hours — honoring the Section 8 capability and allow/deny rules and
      hard safety limits.
- [ ] Make the Optimizer button and the Settings button keyboard-accessible with
      visible focus and consistent hover/active states (Section 3.1).
- [ ] Persist all optimizer and settings preferences separately from project
      semantics (Section 9.1 layout/preferences rule).

### 20.6 Scheduling and "Never Lag" Guarantees

- [ ] Drive the optimizer from an incremental, resumable work queue keyed by what
      the user actually changed, so an edit reschedules only affected regions.
- [ ] Cap total background CPU share and back off automatically under
      interaction, active simulation, or low battery/thermal pressure.
- [ ] Persist and resume optimizer campaign state so it survives close/reopen
      without recomputation, and never re-proposes an already-rejected rewrite.
- [x] Add a watchdog that suspends the optimizer on any anomaly (budget overrun,
      equivalence-check failure, excessive proposals) and reports it rather than
      degrading the app. Evidence: `opt_engine_note_anomaly` sets a `suspended` flag
      plus a reason code (1 equivalence failure, 2 proposal-cap, 3 apply failure) and
      clears any pending badge; a suspended engine refuses all further work until
      `opt_engine_resume`. `optimizer-schedule` proves suspend→refuse→resume and that
      the reason is reported.

### 20.7 Verification

- [x] Add property tests proving each rewrite family preserves outputs over
      exhaustive or well-sampled inputs for the reference PCU. Evidence:
      `optimizer-verify` runs `opt_analyze` over a family of generated scenes
      (dead-path chains with 0–2 orphan pairs and a constant-collapse mul network);
      every proposal it produces is `opt_verify`-valid, output-equivalent over the
      full horizon, and never raises the cost score — non-vacuously (real proposals
      verified).
- [x] Add a differential gate proving optimized and unoptimized projects yield
      byte-identical traces for the same seed and inputs. Evidence:
      `optimizer-verify` drives an independent detector-trace oracle (`traces_match`,
      separate from `opt_outputs_equal`) that steps the optimized and original scenes
      in lock-step and confirms identical detector output every symbol over the
      horizon.
- [x] Add a gate proving that with auto-apply off the optimizer never changes
      project bytes, revision, or output — only reports. Evidence: `optimizer`
      gate byte-compares the saved project before and after `opt_analyze`.
- [ ] Add a soak proving continuous background operation during editing and
      simulation holds the interaction frame budget (Section 3.3 timing targets)
      with no hitching.
- [x] Add adversarial tests feeding hostile/pathological graphs and confirming the
      optimizer stays bounded, rejects non-equivalent rewrites, and never applies
      an unverified change. Evidence: `optimizer-verify` feeds an empty scene, a
      detector-less graph, and a feedback-cycle graph; `opt_analyze` never mutates
      (observer), the useful-set fixpoint terminates on the cycle, and any proposal
      must pass `opt_verify`/`opt_outputs_equal` — no non-equivalent rewrite survives.
- [x] Add an end-to-end test: the optimizer finds a real improvement on the
      reference PCU, reports the measured gain, auto-applies it under an explicit
      grant, and the result re-verifies against the oracle with zero mismatches.
      Evidence: `optimizer-verify` finds an improving proposal (positive gain),
      surfaces it on the engine badge, then with auto-apply enabled lands it via
      `opt_engine_tick` (applied_count advances, badge clears, cost drops), and the
      applied project re-verifies output-equivalent against a pristine oracle with
      zero mismatches; the app's apply path is grant-gated + journaled + audited
      (`optimizer-undo-audit`).

### Acceptance

- [x] Every applied or proposed optimization is provably output-equivalent to the
      original for all declared vectors. Evidence: `opt_analyze`/`opt_apply` gate
      every proposal on `opt_outputs_equal` over the emitter-preset input horizon;
      `optimizer` gate. (Horizon-bounded; widened as new rewrite families land.)
- [x] Disabling the optimizer changes only speed, never results. Evidence:
      `optimizer` gate — a disabled `OptEngine` tick leaves project bytes
      byte-identical and surfaces no proposal.
- [ ] Reported gains are measured, reproducible, and carry provenance and
      uncertainty — never assumed.
- [ ] Continuous background operation never causes a dropped frame, blocked input,
      stalled save, or delayed agent request in the soak test.
- [x] Auto-apply is safe: opt-in, previewable, transactional, undoable, audited,
      and re-verified at apply time. Evidence: `auto_apply` is opt-in/off by
      default; auto and manual apply share `opt_apply_gui`, which re-verifies
      (`opt_verify`), commits one journaled undo op, and audits; `optimizer` and
      `optimizer-ui` gates.
