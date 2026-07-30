# Numeric Constant Audit

This registry classifies numeric literals by owning module. It is the review
boundary for `src/*.zag`: a new source module or a new physical/performance
literal requires an entry here and provenance or generated measurement evidence.

Categories are: **structural** (format, index, algebra, or geometry), **UI-only**
(layout or visual token), **physical** (must come from `DeviceModel`), **measured**
(generated evidence only), **derived** (computed from model/geometry), **safety
limit** (named and bounded), and **protocol/ABI** (versioned external contract).

| Source | Allowed constant categories | Owner / resolution rule |
|---|---|---|
| `agent.zag` | structural, protocol/ABI, safety limit | Automation contract; stable codes and bounded parsing |
| `app.zag` | structural, UI-only | Application lifecycle and interaction cadence |
| `builder.zag` | structural, derived, safety limit | Density-sweep synthesis; physical values come from DeviceModel; spans/passes bounded by limits.zag |
| `capability.zag` | structural, protocol/ABI, safety limit | Security capability bitset and grant policy |
| `commands.zag` | structural, protocol/ABI | Stable command-id registry; no physical or performance literals |
| `components.zag` | structural, UI-only | Component topology and default voxel footprints; no physical rate claims |
| `demo.zag` | structural, illustrative physical | Demo fixture only; physical values inherit the illustrative model label |
| `device_model.zag` | physical, derived, safety limit | Physical-model owner; every value carries units, source, method, uncertainty, and confidence |
| `editops.zag` | structural, protocol/ABI, derived | Project/journal formats and model serialization scales |
| `export.zag` | structural, protocol/ABI, derived | Deterministic export formatting and model-derived values |
| `fb.zag` | structural, UI-only, safety limit | Pixel arithmetic, clipping, and bounded image dimensions |
| `flash_ir.zag` | structural, protocol/ABI, safety limit | Flash FIR grammar/version and bounded import |
| `fontatlas.zag` | UI-only, structural | Glyph atlas packing geometry; no physical or performance literals |
| `fontdata.zag` | UI-only, structural | Checked-in bitmap glyph data; never physical evidence |
| `gpu_backend.zag` | structural, protocol/ABI, safety policy | Stable backend choice and refusal codes; live hardware identity is queried and physical access remains separately gated |
| `gpu_compute.zag` | protocol/ABI, safety limit | Experimental reviewed dispatch construction; no performance claims |
| `gpu_isa_display.zag` | structural, protocol/ABI, safety limit | Virtual addresses, framebuffer bounds, queue ownership, and compiler-owned PM4/ISA contracts |
| `gpu_isa_raster.zag` | structural, protocol/ABI, safety limit | Reviewed fill/depth/blend bundle addresses, fixed-point alpha range, bounded tiles/spans, canaries, and CPU-authoritative promotion/fallback |
| `gpu_raster.zag` | structural, safety limit | Bounded tile batches, fence sequencing, and CPU-authoritative promotion policy |
| `gpu_virtual_cert.zag` | structural, protocol/ABI, safety limit | Explicit virtual campaign thresholds, deterministic logical clock, bounded VM memory, and non-promotable evidence classification |
| `gpu_rt.zag` | protocol/ABI, safety limit, queried hardware | Linux DRM/AMDGPU UAPI encodings and bounded timeouts; device properties are queried |
| `io_chunks.zag` | structural, protocol/ABI, derived | Chunk/project encoding and model-derived guide length |
| `ioline.zag` | structural, safety limit | Bounded line/token parsing |
| `limits.zag` | safety limit | Central owner for configurable resource ceilings |
| `main.zag` | structural, protocol/ABI, safety limit | CLI mode selection and Linux entry contracts |
| `math3d.zag` | structural | Dimensionless vector/matrix algebra constants |
| `mcp.zag` | protocol/ABI, safety limit | MCP framing/version/schema and request ceilings |
| `optimizer.zag` | structural, derived, safety limit | Exact structural cost model and bounded scheduler settings; timing gains require benchmark evidence |
| `process_stack.zag` | structural, derived | Physical process-stack layer heights; values come from DeviceModel |
| `rdna.zag` | protocol/ABI | Reviewed RDNA1 instruction encodings; never inferred on hardware |
| `routing.zag` | structural, safety limit, derived | Named route costs and model/geometry-derived path results |
| `scene.zag` | structural, safety limit | IDs, voxel topology, occupancy, and bounded world coordinates |
| `session.zag` | structural, protocol/ABI, safety limit | Revision, atomic persistence, autosave retention, and timestamps |
| `sim.zag` | structural, physical, derived, safety limit | Balanced-ternary states and model-derived clock/delay |
| `sim_region.zag` | structural, safety limit | Incremental graph patching and bounded history |
| `strutil.zag` | structural | String-builder arithmetic; no physical or performance literals |
| `ternary.zag` | structural | Closed balanced-ternary algebra |
| `tiles.zag` | structural, UI-only | Render tile geometry and dirty-region bookkeeping |
| `timing.zag` | derived, physical | Geometry/model-derived timing and uncertainty propagation |
| `ui.zag` | UI-only, structural | Design tokens, widget states, typography, and hit targets |
| `uilayer.zag` | UI-only, structural | Overlay/layer composition |
| `viewport.zag` | UI-only, structural, derived | Projection/raster math and world-derived geometry |
| `voxel.zag` | structural | Integer lattice algebra and keys |
| `workspace.zag` | UI-only, structural, derived | Product layout and model-derived displayed values |
| `workspace_menu.zag` | UI-only, structural | Menu/palette/status layout; no physical or performance literals |
| `workspace_opt.zag` | UI-only, structural, derived | Optimizer/builder panel layout; model-derived displayed values |
| `workspace_settings.zag` | UI-only, structural | Modal/settings layout; no physical or performance literals |
| `world.zag` | structural, safety limit | Sparse 32-cubed chunk indexing and bounded queries |
| `x11.zag` | protocol/ABI, UI-only, safety limit | X11 wire protocol, event constants, and bounded presentation |

## Physical/performance-number ownership

| Number class | Owner | Required resolution |
|---|---|---|
| Device rates, wavelengths, loss, index, dispersion, response, tolerances | `src/device_model.zag` | Versioned provenance record or `Unknown` |
| Propagation delay, symbol timing, path margin | `src/timing.zag` / `src/sim.zag` | Runtime derivation from project model and geometry |
| DRM ioctls, PM4 registers, RDNA encodings | `src/gpu_rt.zag` / `src/rdna.zag` | Match reviewed Linux/AMD ABI; software layout/golden tests |
| Resource ceilings and timeouts | `src/limits.zag` or named GPU safety functions | Named, documented, configurable where appropriate, regression tested |
| UI dimensions/colors/animation cadence | `src/ui.zag` / `src/workspace.zag` | Design-token or explicit UI-only classification |
| Frame time, throughput, memory, GPU reliability | generated evidence | Environment, timestamp, raw samples, and no portable claim |
| Optimizer improvement | `src/optimizer.zag` | Exact before/after structural delta or benchmark distribution with uncertainty |

## Optimizer scheduler limits

| Constant | Category | Owner / resolution |
|---|---|---|
| 8 ms default pass slice | safety limit | `OptEngine.time_budget_ms`; configurable scheduler deadline, enforced after every oracle symbol and by the pass watchdog |
| 64 MiB default pass memory | safety limit | `OptEngine.memory_budget_bytes`; conservative admission ceiling covering candidate scenes, two simulators, histories, and guide-delay rings |
| 8 oracle symbols per configured millisecond | safety limit | Deterministic cooperative-work quota; the monotonic deadline remains authoritative and is checked after every symbol |
| 32 structural units per configured millisecond | safety limit | Conservative placement-clone admission rule over components, guides, and path points; candidates above it yield/skip instead of entering unbounded routing work |
| 64-symbol equivalence horizon | structural safety limit | Exact retained detector-trace oracle horizon; persisted symbol state prevents recomputation after a yield or reopen |

No unowned physical or performance number is approved. The source inventory gate
and unsupported-claim audits enforce this registry's boundary.
