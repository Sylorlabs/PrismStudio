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

## 4. Phase A — Establish Reproducible Ground Truth

- [ ] Inventory source modules, generated artifacts, probes, protocols, storage
      formats, and external dependencies.
- [x] Record the supported Zag compiler path and compiler identity/hash. Evidence:
      `evidence/progress-ledger.md` A.compiler.
- [ ] Make the clean build deterministic and document all prerequisites.
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

- [ ] A clean checkout can be built and tested with documented commands.
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
- [ ] Attach a provenance record to every physical parameter: source, source
      version, date, method, units, uncertainty, and confidence class.
- [ ] Distinguish measured, literature-derived, simulated, user-entered,
      illustrative, and unknown values.
- [ ] Validate dimensions and units at load time.
- [ ] Reject incompatible device-model versions with an actionable diagnostic.
- [ ] Allow projects to pin and migrate model versions explicitly.
- [ ] Display provenance and uncertainty in the inspector.

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
- [ ] Replace unexplained component-count and delay caps with named, documented,
      configurable safety limits and tests.
- [ ] Query GPU properties rather than embedding render-node, clock, CU, family,
      or memory assumptions.
- [ ] Remove hardcoded frame-time and component-count claims from documentation;
      publish benchmark results with environment and timestamp instead.
- [x] Add a repository test that rejects banned unsupported claims and suspicious
      physical literals outside approved model fixtures. Evidence:
      `unsupported-claim-audit`.
- [ ] Render missing evidence as `Unknown` or `Not characterized`.

### Acceptance

- [x] Changing the device model changes derived timing without a source edit.
      Evidence: engine assertion of the same name.
- [ ] Unit-conversion and dimensional-analysis tests cover every derivation.
- [ ] No user-visible physical or performance claim lacks provenance.
- [x] The application can represent an incompletely characterized device without
      inventing a value. Evidence:
      `incomplete model cannot silently advance verified simulation`.

## 6. Phase C — Photonic Computing Unit Design

The implementing agent must build a complete reference PCU using production
interfaces. It may not satisfy this requirement by inserting a private fixture
directly into memory.

### 6.1 Design Database

- [ ] Define stable IDs and typed records for boards, layers, components, ports,
      nets, waveguide segments, constraints, model bindings, and annotations.
- [ ] Enforce occupancy, placement, orientation, port compatibility, minimum bend
      radius, clearance, layer transition, fan-in, fan-out, and boundary rules.
- [ ] Make every edit transactional and undoable.
- [x] Make save/load round trips lossless and deterministic. Evidence: engine
      round-trip assertions and byte-identical massive Flash save/reopen.
- [ ] Add schema versioning, migration, corruption detection, and recovery.
- [ ] Preserve unknown future fields where feasible.
- [x] Add canonical project hashing for reproducibility. Evidence: project v2
      content hash and corruption test in `probe/engine_test.zag`.

### 6.2 Routing and Timing

- [ ] Route in true 3D with explicit layers and vertical transitions.
- [ ] Make routing cost terms named, configurable, and inspectable.
- [ ] Detect collisions, illegal crossings, disconnected ports, loops, and
      unreachable routes.
- [x] Compute optical path length from geometry. Evidence: `scene_add_guide`.
- [x] Derive propagation delay from the selected physical model. Evidence:
      `guide_delay_fs_for`, `guide_delay_symbols_for_model`.
- [ ] Report timing paths, bottlenecks, margins, and uncertainty.
- [ ] Add deterministic routing seeds and replayable failures.
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

- [ ] Specify balanced-ternary values, unknown/high-impedance/error states, phase
      conventions, sampling rules, and tie-breaking precisely.
- [x] Separate symbolic functional simulation from physical/timing simulation.
      Evidence: `SimMode.Functional` and `SimMode.Physical` with independent
      model-completeness behavior in `simulation-properties`.
- [ ] Define deterministic scheduling independent of map iteration order.
- [ ] Handle feedback, latency, initialization, convergence, and oscillation.
- [ ] Support reproducible stepping, pause, reset, breakpoint, and trace capture.
- [ ] Detect invalid inputs, model gaps, numerical instability, and overflow.
- [ ] Bound memory and execution for hostile or accidental large designs.
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
- [ ] Report uncertainty instead of manufacturing false precision.

### Acceptance

- [x] Same project, models, seed, and inputs produce byte-identical traces.
      Evidence: two fresh 32-symbol exports compare byte-for-byte with each
      other and the maintained reference-PCU golden trace.
- [x] Invalid or incomplete models cannot silently produce a “verified” result.
      Evidence: `incomplete model cannot silently advance verified simulation`.
- [ ] Every simulator status shown in the UI maps to a tested engine state.

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
- [ ] Make high-impact actions previewable and ask-before-write by default.
- [ ] Support user-configurable always-allow and deny rules without bypassing
      hard safety limits.
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

- [ ] Provide schema-described operations for create/open/save/close project,
      list/get/place/move/rotate/delete components, connect/disconnect/reroute,
      inspect models, run checks, simulate, trace, render, export, undo, and redo.
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
- [ ] Stream long-running progress and support safe cancellation.
- [ ] Validate MCP, CLI, pipe, and in-process commands through one command layer.
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

- [ ] Test every advertised tool with valid, invalid, unauthorized, conflicting,
      replayed, cancelled, and malformed requests.
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
- [ ] Test crash recovery during a multi-operation transaction.

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
- [ ] Support perspective and orthographic cameras, orbit, pan, zoom, and frame.
- [ ] Render components and waveguides as actual volumes, not flat 2.5D lines.
- [ ] Distinguish ternary/beam orientation by geometry and labels, not color alone.
- [ ] Render intersections, over/under routes, layers, ports, and selected paths.
- [ ] Batch repeated geometry and update only dirty buffers/regions.
- [ ] Keep UI overlays and scene rendering independently invalidated.
- [x] Add deterministic frame capture and pixel-diff tooling. Evidence:
      `frame-diff` renders two fixed-state CPU frames, verifies zero pixel
      delta, mutates one pixel, and verifies the diff count detects it.
- [ ] Add picking tests at viewport edges, occlusion boundaries, and high zoom.

### 9.3 Real UI Testing

- [x] Launch the production binary in a real X11 session. Evidence:
      `x11-live` on `DISPLAY=:0`, recorded in the ledger.
- [x] Exercise mouse, keyboard, resize, window close, focus, and repeated open/close.
      Evidence: live `x11-live` suite.
- [ ] Complete the reference PCU workflow through visible UI controls.
- [ ] Verify screenshots at multiple window sizes and DPI/scaling settings.
      Partial evidence: live 1024x640 and 1440x900 captures pass; DPI/scaling
      variants remain unverified.
- [ ] Inspect layout for clipping, overlap, unreadable contrast, stale state, and
      inconsistent hit targets.
- [ ] Verify error and permission prompts with both keyboard and pointer.
- [ ] Verify save indicators, crash recovery, undo/redo, and revision conflicts.
- [ ] Run a long interactive soak with active simulation and editing.
- [ ] Capture frame-time distributions by workload and identified environment.
- [ ] Treat headless rendering as additional coverage, never a substitute for the
      live UI gate.

## 10. Phase G — Persistence, Recovery, and Export

- [ ] Use atomic save with flush, rename, and recoverable journal semantics.
- [ ] Detect external modifications and resolve conflicts without silent loss.
- [ ] Test truncation, bit corruption, partial writes, disk-full behavior, and
      process termination at every save stage.
- [ ] Add autosave retention and explicit recovery UX.
- [x] Make all exports deterministic and identify project/model/tool versions.
      Evidence: canonical byte comparisons in `flash-photonic`.
- [x] Export human-readable design summaries and machine-readable netlists.
      Evidence: maintained BOM, netlist, models, and report artifacts.
- [ ] Ensure diagnostic bundles exclude sensitive scene contents by default.
- [x] Add round-trip tests for every supported project version. Evidence:
      `engine` covers current `zpa 2` save/load and legacy `zpa 1` load,
      migration to v2, hash-backed reload, and identity preservation.

## 11. Phase H — CPU Renderer as Reference

- [ ] Freeze precise pixel format, depth, clipping, rounding, compositing, and
      tie-breaking behavior.
- [ ] Add golden scenes for every primitive and UI layer.
- [ ] Add randomized scene tests with deterministic seeds.
- [x] Verify bounds and canaries around framebuffer operations. Evidence:
      `fb-bounds` covers clipped point, fill, blend, line, and text operations
      preserving sentinel pixels outside the active clip.
- [ ] Benchmark scene update, rasterization, UI/text, blit, and present separately.
- [ ] Keep benchmark claims in generated reports with hardware/software metadata.
- [ ] Preserve the CPU renderer as permanent fallback and differential oracle.

## 12. Phase I — Experimental AMDGPU Path

GPU work must remain bounded, reviewed, opt-in, and safe for a display GPU.

### 12.1 Submission Protocol

- [ ] Discover render nodes and query device, IP, ring, firmware, memory, and fault
      information; do not hardcode `/dev/dri/renderD128`.
- [ ] Encode installed AMDGPU UAPI structures as named Zag types with layout tests.
- [ ] Validate IB packets, lengths, registers, reserved bits, alignment, buffers,
      workgroups, time limits, and fence deadlines before submission.
- [ ] Test documented memory synchronization flags one bounded dispatch at a time.
- [ ] Implement BO lists, user fences, DRM syncobj timelines, and VM ordering.
- [ ] Implement documented cache ownership transitions and instruction invalidation.
- [ ] Distinguish submit failure, wait error, timeout, reset, VM fault, stale output,
      and validation mismatch.
- [ ] Disable GPU use for the process after any anomaly and recreate no suspect
      context automatically.
- [ ] Never perform opcode sweeps or arbitrary-machine-code discovery on hardware.
- [ ] Permit only reviewed, hash-verified kernels from a fixed manifest.
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

- [ ] Add deterministic workloads, canaries, checksums, sequence numbers, recorded
      seeds, cache-sensitive patterns, and resumable campaign state.
- [ ] Capture kernel-log deltas and exact certification tuples.
- [ ] Pass 10,000 bounded sequential fills with zero faults.
- [ ] Pass 10,000 CPU-to-GPU-to-CPU ownership transfers with zero stale reads.
- [ ] Pass an eight-hour soak and a 24-hour soak.
- [ ] Pass one million varied dispatches with zero mismatch, timeout, reset, fault,
      leak, or crash.
- [ ] Invalidate certification after relevant GPU, firmware, kernel, compiler, or
      runtime changes until compatibility gates pass again.
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
- [ ] Run leak and handle-lifetime tests across edit/open/close cycles.
- [ ] Establish workload-based performance budgets from measured baselines.
- [ ] Fail regressions statistically and retain raw benchmark samples.
- [ ] Never optimize by weakening validation, determinism, or the CPU oracle.

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

* [ ] Show exact coordinates for selected objects.
* [ ] Show exact dimensions for parts and beams.
* [ ] Show beam state clearly:

  * [ ] Off
  * [ ] Positive
  * [ ] Negative
  * [ ] invalid/conflicting
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

* [ ] Smooth orbit camera.
* [ ] Smooth pan.
* [ ] Smooth zoom.
* [ ] Focus selected object.
* [ ] Frame all objects.
* [ ] Reset view.
* [ ] Top/front/side/isometric camera shortcuts.
* [ ] Perspective and orthographic modes.
* [ ] Clickable 3D orientation gizmo.
* [ ] Grid fades by distance.
* [ ] Selected objects get clear outlines.
* [ ] Hovered objects get subtle outlines.
* [ ] Hidden/occluded selected objects get ghost outlines.
* [ ] Beam paths remain readable through dense scenes.
* [ ] Add x/y/z axis colors.
* [ ] Add world origin marker.
* [ ] Add clipping/section view later for dense engines.

No fake flat UI for 3D objects. Selection, snapping, and editing should all understand true 3D.

---

## 3.6 Pro-grade tool interactions

* [ ] Add command palette:

  * [ ] `Ctrl+P` or `Ctrl+K`
  * [ ] search commands
  * [ ] create parts
  * [ ] toggle overlays
  * [ ] jump to object
* [ ] Add proper shortcuts:

  * [ ] select
  * [ ] route
  * [ ] move
  * [ ] rotate
  * [ ] duplicate
  * [ ] delete
  * [ ] frame selected
  * [ ] run simulation
  * [ ] pause simulation
* [ ] Add undo/redo for every edit.
* [ ] Add multi-select.
* [ ] Add box select.
* [ ] Add object grouping.
* [ ] Add copy/paste.
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

* [ ] Show selected object name/type.
* [ ] Show transform:

  * [ ] position x/y/z
  * [ ] rotation
  * [ ] scale/dimensions
* [ ] Show engine-specific properties:

  * [ ] beam state
  * [ ] port states
  * [ ] material/model
  * [ ] timing delay
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
* [ ] Visibility toggle.
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
* [ ] A user can inspect exact coordinates and beam state.
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
