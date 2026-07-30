# Repository inventory

A current inventory of PrismStudio's source modules, artifacts, probes, protocols,
storage formats, and external dependencies (Master plan §4.1). The
`inventory-audit` gate fails if a `src/*.zag` module is missing here.

## Source modules (49) — `src/*.zag`

| Module | Role |
|---|---|
| `agent.zag` | headless agent RPC for CLI and MCP wrappers. |
| `app.zag` | application core: state, zones, tools, input, and the command |
| `builder.zag` | Engine Builder / Density Synthesizer (Masterplan §22). |
| `capability.zag` | explicit local-agent grants and append-only request audit. |
| `commands.zag` | stable command-id registry for palette + agent dispatch. |
| `components.zag` | the photonic hardware library. |
| `demo.zag` | reference photonic processor design (shared by GUI + agent). |
| `device_model.zag` | versioned physical assumptions with explicit provenance. |
| `editops.zag` | editing operations above the raw scene: move with waveguide |
| `export.zag` | deterministic human/machine-readable project artifacts. |
| `fb.zag` | software framebuffer for Zag Photonics Architect. |
| `flash_ir.zag` | Flash FIR v1 importer and photonic execution verifier. |
| `fontdata.zag` | 5x9 bitmap font rows (bits 4..0) |
| `fontatlas.zag` | glyph atlas packer: bakes fontdata rows into a cacheable |
| `gpu_backend.zag` | User-selectable auto/CPU/virtual/physical backend policy; explicit CPU/virtual choices do not open or probe DRM. |
| `gpu_compute.zag` | high-level GPU compute operations built on the verified |
| `gpu_isa_display.zag` | Compiler-ISA-executed virtual framebuffer with owned memory, ordered fences, complete-frame presentation, and no DRM access. |
| `gpu_isa_raster.zag` | Strict virtual GFX10.1 tiled raster execution for compiler-emitted clear, depth, clipping, and fixed-point alpha compositing, with CPU shadow fallback. |
| `gpu_raster.zag` | Compiler-bundle-gated tiled raster software model: clear, geometry, depth, clipping, compositing, per-tile fences, shadow comparison, double buffering, fallback, and mismatch input/image/diff/log/tuple evidence. |
| `gpu_virtual_cert.zag` | Host-contained certification runner: 10,000 fills, one million actual VM submissions, exact ownership/fences, 86,400 logical soak ticks, raster differentials, and explicitly non-physical evidence. |
| `gpu_rt.zag` | a pure-Zag AMDGPU runtime. No libc, no libdrm, no Mesa: |
| `io_chunks.zag` | chunked design I/O keyed by world 32³ chunks. |
| `ioline.zag` | buffered stdin reads (chunked, not byte-per-syscall). |
| `limits.zag` | centralized, named, documented resource ceilings for untrusted |
| `main.zag` | photonic CPU designer entry point. 100% Zag, no C anywhere. |
| `math3d.zag` | vectors, orbit camera, projection, and picking rays. |
| `mcp.zag` | native MCP stdio server (JSON-RPC + Content-Length framing). |
| `optimizer.zag` | Continuous Optical-Computation Optimizer (Photon Solver). |
| `process_stack.zag` | physical process-stack layer model (plate, part, guide heights). |
| `rdna.zag` | a hand-written RDNA1 (GFX10.1) machine-code emitter, in pure Zag. |
| `routing.zag` | waveguide routing engine. A* over the free voxel lattice, |
| `scene.zag` | the design database. The scene is stored as (a) a voxel |
| `session.zag` | live shared design: one .zpa for GUI + agent + MCP. |
| `sim.zag` | wave-state simulation. The scene's directed optical graph is |
| `sim_region.zag` | incremental simulation recompile. |
| `strutil.zag` | leak-free string helpers (s2..s6, fmt_i, fmt_f1) for ownership. |
| `ternary.zag` | balanced ternary optical logic. |
| `tiles.zag` | tile-based render cache for the 3D viewport. |
| `timing.zag` | static timing analysis over the routed photonic fabric (Masterplan |
| `ui.zag` | dark workbench theme + minimal immediate-mode widgets over fb.zag. |
| `uilayer.zag` | retained UI panel surfaces: cached pixels + state hashes (Section 3.12). |
| `viewport.zag` | the 3D viewport. Software-rasterized in Zag: |
| `voxel.zag` | integer lattice coordinates for the design grid. |
| `workspace.zag` | panel rendering + per-frame orchestration. |
| `workspace_menu.zag` | menu bar, command palette, status bar, context menu. |
| `workspace_opt.zag` | optimizer proposal panel + builder panel + apply paths. |
| `workspace_settings.zag` | modal dialogs, Flash FIR workspace, model browser, settings. |
| `world.zag` | sparse chunk-based spatial index for million-scale scenes. |
| `x11.zag` | a pure-Zag X11 client. No libc, no Xlib, no C anywhere: |

## Probes

See `probe/MANIFEST.md` — 123 probe sources classified as production (gated),
hardware-only, dev-benchmark, compiler, or obsolete.

## Generated artifacts (never committed; see `.gitignore`)

- `zagpa` — the production binary (`znc src/main.zag`)
- `tools/verify`, `tools/bench.bin` — gate runner and benchmark harness
- `probe/*_test` — compiled probe binaries
- `evidence/bench-report.md` — generated per-stage benchmark report
- project exports — `*.zpa` / `*.bom.txt` / `*.netlist.txt` / `*.models.txt` / `*.report.txt` / `*.trace.txt`

## Protocols

One command layer (`src/agent.zag`) served over four transports:
- **MCP** (`--mcp`, framed JSON-RPC `2024-11-05`), **CLI** (`zagctl`),
  **pipe** (`--pipe`), and **in-process agent** (`--agent`).
- **X11** — raw wire protocol in `src/x11.zag` (no Xlib).

## Storage formats

- `*.zpa` — project design, schema `zpa 2`, content-hash footer (`src/editops.zag`)
- `.prismstudio/live.zpa` / `.rev` / `.bus` / `.jrn` / `.idem` — session state (`src/session.zag`)
- journal (`UOp` records) — transactional undo/redo (`src/editops.zag`)

## External dependencies

- **znc** — the self-hosted Zag compiler at `../zag/zag-poc/znc` (only build dependency)
- **Linux syscalls** — via `_zag_raw_syscall` (no libc)
- **X11 server** — raw protocol over a unix socket (no Xlib/Mesa/LLVM/C)
- Zero C/Zig/Python/third-party libraries (pure-Zag rule).
