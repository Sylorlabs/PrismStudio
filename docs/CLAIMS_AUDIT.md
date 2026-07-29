# README and UI Claims Audit

Audit date: 2026-07-13. Scope: user-visible claims in `README.md` and the native
workspace. “Pass” means the claim is tied to a reproducible gate or is explicitly
bounded as illustrative, experimental, or unknown.

| Claim surface | Classification | Executable evidence |
|---|---|---|
| Native pure-Zag CAD workbench | implemented | `build-production`, `pure-zag-tree`, `x11-live` |
| 3D layout, routing, picking, and inspection | implemented | `routing`, `picking`, `camera`, `ortho`, `x11-captures` |
| Deterministic balanced-ternary simulation | verified software behavior | `simulation-properties`, `deterministic-trace`, `sim-semantics` |
| Physical parameters retain provenance and unknown values stay unknown | verified data-model behavior | `provenance`, `provenance-units`, `model-schema-migration` |
| Flash FIR import and detector verification | verified software workflow | `flash-photonic`, `reference-tamper`, `reference-pcu-ui` |
| Save, recover, export, undo, and revision conflict handling | implemented and tested | `engine`, `persistence`, `recovery-ui`, `session-conflict`, `agent-revision-conflict` |
| Authorized CLI/MCP automation | implemented and tested | `agent-matrix`, `mcp-tool-coverage`, `agent-capability-denial`, `audit-redaction` |
| Optimizer dead-path and constant-collapse proposals | implemented, equivalence bounded to declared vectors | `optimizer`, `optimizer-verify`, `optimizer-report` |
| Photonic hardware performance | not claimed | README “honest boundary”; device model is illustrative unless replaced by sourced evidence |
| AMDGPU dispatch/raster reliability | experimental, not certified | GPU software gates pass; hardware suites remain `not-run` without a non-display certification GPU |
| Performance numbers | measured locally only | generated `evidence/bench-report.md` and raw samples; `doc-perf-claim-audit` |

The `unsupported-claim-audit`, `stale-language-audit`, and
`doc-perf-claim-audit` gates reject known classes of unsupported wording and
unqualified portable performance numbers.
