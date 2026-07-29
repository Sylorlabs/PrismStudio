# PrismStudio Formats, Automation, and Recovery

This document describes implemented behavior. `masterplan.md` remains the
acceptance contract; unchecked work there is not implied complete here.

## Project format

The canonical project is UTF-8 line-oriented `zpa 2` data written by
`design_save` in `src/editops.zag`:

- `zpa 2` identifies the container schema.
- `m` stores the project-pinned device-model schema (`1` or `2`), a known-value
  bit mask, and fixed-point physical parameters. Schema 2 adds wavelength bounds,
  bandwidth, loss, dispersion, response time, geometry/process limits,
  temperature, tolerance, substrate, port, memory, and material-stack inputs.
- `c` stores stable component ID, typed kind, integer lattice origin, quarter
  rotation, visibility, emitter preset, wavelength, chamber operation, and name.
- `g` stores stable guide ID, typed endpoint component/port IDs, and every routed
  3D lattice point. Length is derived from point count and model pitch.
- `h` stores the canonical content hash of all preceding bytes.

The loader accepts legacy `zpa 1` and current `zpa 2`, rejects other container
versions, rejects device-model schemas outside `1..2`, verifies the v2 hash, and
parses into a temporary scene. The active scene is replaced only after complete
type, coordinate, occupancy, support, endpoint, port, path-continuity, layer,
and resource-limit validation. Future unknown fields are not yet preserved.

## Device model and evidence

`src/device_model.zag` defines current schema `2` and retains schema `1` for
explicitly pinned legacy projects. Eight versioned device-type descriptors cover
emitters, waveguides, chambers, memory tiles, detectors, substrates, ports, and
material stacks. Each runtime `PhysicalParam` carries:

- value and units;
- known/unknown state;
- source, source version, and date;
- method;
- uncertainty;
- evidence class.

Evidence classes are Measured, Literature-derived, Simulated, User-entered,
Illustrative, and Unknown. The bundled model is explicitly Illustrative. Missing
required physical values prevent physical verification; functional simulation
can still run without inventing them.

Project v2 currently persists numeric model inputs and their known mask. The
full textual provenance record comes from the selected schema/model definition;
arbitrary per-project provenance strings are not yet serialized. Derived timing
uses GHz, ps, nm, and fs conversions in `src/sim.zag`; exported manifests retain
units, source metadata, uncertainty, and evidence class.

Migration is explicit through the Physical Model & Provenance UI or
`model migrate 2`. Existing v1 values are preserved; fields added by v2 remain
Unknown until evidence is supplied. `model status` reports the pin, current
schema, completeness, and every device-type descriptor.

## Agent protocol

The native line protocol is `prismstudio-agent-1`. One command produces one `OK` or
`ERR E_CODE diagnostic` response. `capabilities` returns protocol version,
effective grant bits, revision, request limit, mutation metadata mechanism, and
whether project-root confinement is active.

`ui list` renders the current frame and returns `ui_schema 1` followed by every
visible element's stable ID, role, exact bounds, enabled/active/focused state,
and label. `ui screenshot <path>` captures that state. `ui activate <id>` routes
through the real pointer target and requires admin capability plus the normal
idempotency/revision envelope. The MCP equivalents have explicit JSON schemas.

Project mutations use:

```text
request <idempotency-key> <expected-revision|current> <command>
```

Keys contain 1-64 ASCII letters, digits, `.`, `-`, or `_`. A successful mutation
returns revision, key, affected ID, and undo token. A repeated committed key
returns its original revision without executing again. A stale revision returns
`E_REV_CONFLICT` without changing project bytes or revision. Unkeyed mutations
return `E_IDEMPOTENCY_REQUIRED`.

The maintained command set is reported by `help`; it covers project creation,
open/save, component placement/deletion, routing, inspection, undo/redo,
functional/physical simulation, trace/render/export, Flash FIR import and
verification, and local verification commands. `zagctl` adds mutation envelopes
automatically. Set `PRISMSTUDIO_IDEMPOTENCY` to reuse a caller key across retries.

## Capabilities and confinement

The bit capabilities are `read`, `inspect`, `simulate`, `edit`, `save`,
`export`, `execute-local`, and `admin`. The default is read/inspect/simulate.
`PRISMSTUDIO_CAPS` must explicitly grant other classes. `PRISMSTUDIO_PROJECT_ROOT`, when
set, confines open/save/render/export/import paths and rejects lexical parent
traversal with `E_PATH_OUTSIDE_ROOT`.

The MCP server uses Content-Length framing capped by `src/limits.zag`, negotiates
MCP protocol `2024-11-05`, and advertises `prismstudio_mutate` plus specialized
tools for placement, routing, deletion, inspection, export, trace, and Flash
import/verification. Specialized mutation tools require `idempotency_key` and
`expected_revision`; component-targeting tools use `component_id` so arguments
cannot collide with the JSON-RPC request `id`. MCP, CLI, scripts, and `zagctl`
converge on the same native agent dispatcher.

## Audit and recovery files

For a session path `<project>.zpa`:

- `<project>.zpa.rev` is the monotonic committed revision.
- `<project>.zpa.jrn` is journal schema `1` with bounded undo/redo operations.
- `<project>.zpa.idem` maps committed idempotency keys to revisions.
- `.prismstudio/audit.log`, or `PRISMSTUDIO_AUDIT`, is append-only request/denial/success
  evidence with actor, capability class, validated request, result, revision,
  affected ID, and undo token.

Project and journal writes use a sibling `.tmp`, complete-write loops, file
`fsync`, close, and atomic rename. Failed writes remove the temporary file and
do not replace the destination. Project hashes detect content corruption;
journal load failure clears the journal rather than applying partial history.

Parent-directory `fsync`, crash injection at every persistence stage, atomic
cross-process revision locking, unknown-field preservation, and automated
journal reconstruction remain unchecked master-plan work. No stronger recovery
claim should be made until those gates exist.

## Verification

Run `./verify.sh safe`. It emits one JSON record per suite. `release` additionally
requires accessible real X11. GPU suites are separate opt-in modes and are not
part of safe verification.
