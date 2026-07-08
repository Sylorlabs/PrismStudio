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
- [ ] Every checked item links to or names its evidence: test, log, screenshot,
      benchmark, design artifact, source location, or review record.
- [ ] All unit, integration, persistence, protocol, rendering, simulation, and
      end-to-end tests pass from a clean checkout.
- [ ] The production binary builds with the supported self-hosted `./znc` path.
- [ ] The graphical application is exercised in a real X11 session, not only by
      headless tests or static screenshots.
- [ ] A complete photonic computing unit is created through the same public
      editing interfaces available to a user or agent, simulated, verified,
      saved, reopened, and verified again.
- [ ] Claims in the README and UI are generated from current evidence or clearly
      labeled as targets, estimates, examples, or unknowns.
- [ ] CPU rendering remains a tested reference and fallback.
- [ ] Experimental GPU execution remains opt-in until its reliability gates pass.
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
- [ ] Maintain a resumable progress ledger containing item ID, state, evidence,
      last command, result, blocker, and next action.
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
- [ ] Record the supported Zag compiler path and compiler identity/hash.
- [ ] Make the clean build deterministic and document all prerequisites.
- [ ] Separate production tests from obsolete probes and generated binaries.
- [ ] Add a single test entry point that reports every suite independently.
- [ ] Add machine-readable test output suitable for the progress ledger.
- [ ] Record baseline UI screenshots and frame timings on identified hardware.
- [ ] Record baseline engine, save/load, routing, and simulation results.
- [ ] Audit every numeric constant and classify it as structural, UI-only,
      physical, measured, derived, safety limit, or unexplained.
- [ ] Audit every README and UI claim against executable evidence.
- [ ] Create an issue/evidence map linking each discovered gap to this plan.

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

- [ ] Remove `110 GHz` from code, probes, tool descriptions, UI labels, and docs
      wherever it is asserted as a universal emitter or board rate.
- [ ] Replace hardcoded component frequencies with model parameters or unknowns.
- [ ] Derive board symbol rate from the selected components, interconnect model,
      timing constraints, and explicit operating conditions.
- [ ] Replace comments such as “9.09 ps” with unit-safe runtime derivation.
- [ ] Replace fixed waveguide-delay assumptions with propagation calculations
      derived from length and the selected material/device model.
- [ ] Replace unexplained component-count and delay caps with named, documented,
      configurable safety limits and tests.
- [ ] Query GPU properties rather than embedding render-node, clock, CU, family,
      or memory assumptions.
- [ ] Remove hardcoded frame-time and component-count claims from documentation;
      publish benchmark results with environment and timestamp instead.
- [ ] Add a repository test that rejects banned unsupported claims and suspicious
      physical literals outside approved model fixtures.
- [ ] Render missing evidence as `Unknown` or `Not characterized`.

### Acceptance

- [ ] Changing the device model changes derived timing without a source edit.
- [ ] Unit-conversion and dimensional-analysis tests cover every derivation.
- [ ] No user-visible physical or performance claim lacks provenance.
- [ ] The application can represent an incompletely characterized device without
      inventing a value.

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
- [ ] Make save/load round trips lossless and deterministic.
- [ ] Add schema versioning, migration, corruption detection, and recovery.
- [ ] Preserve unknown future fields where feasible.
- [ ] Add canonical project hashing for reproducibility.

### 6.2 Routing and Timing

- [ ] Route in true 3D with explicit layers and vertical transitions.
- [ ] Make routing cost terms named, configurable, and inspectable.
- [ ] Detect collisions, illegal crossings, disconnected ports, loops, and
      unreachable routes.
- [ ] Compute optical path length from geometry.
- [ ] Derive propagation delay from the selected physical model.
- [ ] Report timing paths, bottlenecks, margins, and uncertainty.
- [ ] Add deterministic routing seeds and replayable failures.
- [ ] Add incremental rerouting that preserves unaffected manual routes.

### 6.3 Reference PCU

- [ ] Define a concrete, bounded reference computation and expected truth table
      or trace before designing the unit.
- [ ] Create the substrate and declared material stack.
- [ ] Place all emitters, execution chambers, memory elements, detectors, and
      control/readout elements through public commands or UI actions.
- [ ] Route every optical connection through the production router or documented
      manual-routing interface.
- [ ] Run design-rule checks and resolve every error.
- [ ] Run connectivity, timing, and model-completeness checks.
- [ ] Simulate all required input vectors and compare with the oracle.
- [ ] Save, close, reopen, and reverify the design.
- [ ] Export a bill of materials, netlist, model manifest, verification report,
      and deterministic render.
- [ ] Include the verified reference PCU as a maintained example project.

### Acceptance

- [ ] The reference PCU produces the declared result for every test vector.
- [ ] A clean build can recreate or replay its construction deterministically.
- [ ] Tampering with geometry, model parameters, or connectivity causes the
      appropriate verification gate to fail.
- [ ] The report does not imply fabricated silicon/photonics or laboratory proof;
      it accurately states the level of simulation evidence achieved.

## 7. Phase D — Simulation and Verification Engine

- [ ] Specify balanced-ternary values, unknown/high-impedance/error states, phase
      conventions, sampling rules, and tie-breaking precisely.
- [ ] Separate symbolic functional simulation from physical/timing simulation.
- [ ] Define deterministic scheduling independent of map iteration order.
- [ ] Handle feedback, latency, initialization, convergence, and oscillation.
- [ ] Support reproducible stepping, pause, reset, breakpoint, and trace capture.
- [ ] Detect invalid inputs, model gaps, numerical instability, and overflow.
- [ ] Bound memory and execution for hostile or accidental large designs.
- [ ] Add independent reference oracles for ternary algebra and small networks.
- [ ] Add property tests for components, routing delay, and graph execution.
- [ ] Add differential tests between incremental and full recomputation.
- [ ] Add metamorphic tests for translation, equivalent routing, and benign
      serialization changes.
- [ ] Add golden traces for the reference PCU.
- [ ] Report uncertainty instead of manufacturing false precision.

### Acceptance

- [ ] Same project, models, seed, and inputs produce byte-identical traces.
- [ ] Invalid or incomplete models cannot silently produce a “verified” result.
- [ ] Every simulator status shown in the UI maps to a tested engine state.

## 8. Phase E — Agent Access and Automation

Agent access is a first-class product interface, not an unverified demo path.
The user and agent must be able to perform the same core project operations.

### 8.1 Capability Model

- [ ] Define explicit `read`, `inspect`, `simulate`, `edit`, `save`, `export`,
      `execute-local`, and `admin` capabilities.
- [ ] Default to read/inspect/simulate; require an explicit grant for mutation.
- [ ] Scope grants to project, session, operation class, path, and expiration.
- [ ] Make high-impact actions previewable and ask-before-write by default.
- [ ] Support user-configurable always-allow and deny rules without bypassing
      hard safety limits.
- [ ] Reject operations outside the active project root.
- [ ] Redact credentials, X11 cookies, environment secrets, and private content.
- [ ] Record actor, request, validated arguments, result, affected IDs, and undo
      token in an append-only audit log.

### 8.2 Public Agent API

- [ ] Provide schema-described operations for create/open/save/close project,
      list/get/place/move/rotate/delete components, connect/disconnect/reroute,
      inspect models, run checks, simulate, trace, render, export, undo, and redo.
- [ ] Give every mutation an idempotency key and transactional result.
- [ ] Return stable machine-readable error codes plus human-readable diagnostics.
- [ ] Add project revision preconditions to prevent lost updates.
- [ ] Stream long-running progress and support safe cancellation.
- [ ] Validate MCP, CLI, pipe, and in-process commands through one command layer.
- [ ] Prevent tools from bypassing design rules or persistence invariants.
- [ ] Add capability negotiation and protocol versioning.
- [ ] Add complete examples that construct and verify the reference PCU.

### 8.3 Agent Verification

- [ ] Test every advertised tool with valid, invalid, unauthorized, conflicting,
      replayed, cancelled, and malformed requests.
- [ ] Prove unauthorized requests leave project bytes and revision unchanged.
- [ ] Prove every successful mutation is undoable and auditable.
- [ ] Run two-client revision-conflict and recovery tests.
- [ ] Run an agent-only end-to-end PCU construction and verification test.
- [ ] Compare the agent-created project with the canonical expected artifact.
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
- [ ] Persist layout and preferences separately from project semantics.

### 9.2 True 3D Rendering

- [ ] Use world-space position, rotation, scale, mesh/material, camera, projection,
      depth testing, clipping, and world-space picking.
- [ ] Support perspective and orthographic cameras, orbit, pan, zoom, and frame.
- [ ] Render components and waveguides as actual volumes, not flat 2.5D lines.
- [ ] Distinguish ternary/beam orientation by geometry and labels, not color alone.
- [ ] Render intersections, over/under routes, layers, ports, and selected paths.
- [ ] Batch repeated geometry and update only dirty buffers/regions.
- [ ] Keep UI overlays and scene rendering independently invalidated.
- [ ] Add deterministic frame capture and pixel-diff tooling.
- [ ] Add picking tests at viewport edges, occlusion boundaries, and high zoom.

### 9.3 Real UI Testing

- [ ] Launch the production binary in a real X11 session.
- [ ] Exercise mouse, keyboard, resize, window close, focus, and repeated open/close.
- [ ] Complete the reference PCU workflow through visible UI controls.
- [ ] Verify screenshots at multiple window sizes and DPI/scaling settings.
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
- [ ] Make all exports deterministic and identify project/model/tool versions.
- [ ] Export human-readable design summaries and machine-readable netlists.
- [ ] Ensure diagnostic bundles exclude sensitive scene contents by default.
- [ ] Add round-trip tests for every supported project version.

## 11. Phase H — CPU Renderer as Reference

- [ ] Freeze precise pixel format, depth, clipping, rounding, compositing, and
      tie-breaking behavior.
- [ ] Add golden scenes for every primitive and UI layer.
- [ ] Add randomized scene tests with deterministic seeds.
- [ ] Verify bounds and canaries around framebuffer operations.
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

- [ ] Define limits for project size, graph depth, route search, trace history,
      simulation steps, image dimensions, and agent request size.
- [ ] Test malicious/corrupt files, integer boundaries, path traversal, protocol
      fuzz, command injection, oversized inputs, and resource exhaustion.
- [ ] Ensure project content cannot become executable host commands.
- [ ] Fuzz parsers and serializers with a stable corpus and regression artifacts.
- [ ] Run leak and handle-lifetime tests across edit/open/close cycles.
- [ ] Establish workload-based performance budgets from measured baselines.
- [ ] Fail regressions statistically and retain raw benchmark samples.
- [ ] Never optimize by weakening validation, determinism, or the CPU oracle.

## 15. Phase L — Documentation and Release Truth

- [ ] Rewrite README claims to separate implemented, experimental, planned,
      simulated, measured, and physically validated behavior.
- [ ] Document the exact supported build/run/test workflow.
- [ ] Document project format, physical-model schema, units, provenance, agent
      capability model, command protocol, and recovery behavior.
- [ ] Generate the compatibility and benchmark tables from evidence.
- [ ] Document known limitations and unsupported configurations.
- [ ] Document how to reproduce the reference PCU and all verification results.
- [ ] Remove stale probe-era and marketing language.
- [ ] Add release notes tied to verified behavior, not commit count.

## 16. Final End-to-End Release Gate

Run this gate from a clean checkout after all earlier phases are complete:

- [ ] Build the self-hosted compiler path and Triton production binary.
- [ ] Run every unit, property, fuzz-regression, integration, and protocol test.
- [ ] Launch Triton in a real X11 session.
- [ ] Create a new project through the public agent API.
- [ ] Construct the complete reference photonic computing unit.
- [ ] Open it in the UI and inspect every layer, route, model, and provenance field.
- [ ] Modify it through the UI, undo, redo, save, close, and reopen it.
- [ ] Run design-rule, connectivity, model, timing, and simulation verification.
- [ ] Compare all reference outputs and traces.
- [ ] Export the netlist, model manifest, bill of materials, report, and render.
- [ ] Exercise an unauthorized agent mutation and prove it has no effect.
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
