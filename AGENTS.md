# PrismStudio — Agent Working Rules

## Hard Rules

### 1. No hardcoded physical constants
Every physical value must derive from the device model (`DeviceModel` in `device_model.zag`).
- `wavelength_color` must receive min/max from `model.emitter_wavelength_min_nm` / `max_nm`
- `clock_ghz` must derive from `sim_clock_from_nodes()` (already correct)
- `pitch_nm` must come from `model.pitch_nm.value`
- `light_speed_nm_ps()` is an exact SI constant (legitimate — `components.zag`)
- `group_index` must come from `model.group_index.value`
- NEVER commit `1530`, `1565`, `110` or similar naked literals in physical positions.
- Exception: `device_model.zag` is where illustrative defaults live; every other file must fetch from a model instance.

### 2. Fix Zag at the compiler, never work around it in the app
If Zag's compiler (znc) has a bug or missing feature that forces an awkward app-side workaround, fix the compiler in `../zag/zag-poc/selfhost/`.
- The `ncodegen.zag` hidden return-slot clobber bug: struct-returning calls inside struct-returning functions clobber the caller's hidden return slot pointer. Fix in `ncodegen.zag`, never paper over with temp variables.
- Effect analysis for module-qualified calls: `callee_name`/`callee_is_direct_id` in `sema.zag` must peel through `.idx` and `.fld` wrappers. Already fixed in this session.

### 3. No committing binaries
- `probe/*.test`, `probe/*.new`, `probe/*.bin`, `*.o`, ELF binaries, `.zpa` outputs: all must be in `.gitignore` or cleaned before commit.
- Exception: the `znc` seed binary in the zag-poc repo is the bootstrap seed and must remain committed.
- `mcp-config.json` is per-user and must never be committed (already in `.gitignore`).

### 4. No `CAPS=all` default
- `build.sh` must NEVER install or regenerate `mcp-config.json` with `CAPS=all`.
- `session_write_mcp_config` defaults to `read,inspect,simulate`.
- Only widen when `PRISMSTUDIO_CAPS=all` is explicitly exported.

### 5. Math constant precision
- Use `pi()`, `pi_half()`, `two_pi()` from `math3d.zag` — these are full f64 precision.
- Never hand-roll truncated `π` literals like `1.5707963` or `3.14159265`.

### 6. String ownership
- Every `_zag_str_concat`, `_zag_strdup`, `_zag_i64_to_str` result is heap-owned. Each must reach `_zag_str_free` exactly once.
- Chained concat leaks intermediates: use `s2`, `s3`, `s4`, `s5` from `strutil.zag`.
- Use `fmt_i`, `fmt_f1` from `strutil.zag` (not workspace.zag's old duplicates).
- Park frame-scoped strings with `ui_register` via `ui_park()`.
- Always free `insp_err` entries with the helper functions.

## Workflow
1. Understand the full scope before editing.
2. Run `./build.sh` before any commit.
3. If you modify the compiler, run the bootstrap and verify the full build.
4. Check `git status` before committing to catch accidental binary adds.
5. Leave strategic comments where future LLMs might take shortcuts (see existing comments in `strutil.zag`, `math3d.zag`, `commands.zag`).
