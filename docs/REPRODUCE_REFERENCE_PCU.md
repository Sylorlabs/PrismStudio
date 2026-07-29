# Reproducing the reference photonic computing unit

This guide reproduces the maintained reference PCU from the Flash source and
verifies the generated PrismStudio project against the checked-in canonical
artifacts. It proves deterministic software construction and simulation; it is
not fabricated-hardware or laboratory validation.

## Prerequisites

- Run from the PrismStudio repository root.
- Keep the sibling repositories in their expected layout:
  - `../zag/zag-poc/znc`
  - `../flash`
- Use the supported safe path first. GPU dispatch is not part of this
  reproduction.

## One-command release-gate reproduction

```sh
./verify.sh safe
```

The relevant proof record is:

```json
{"suite":"flash-photonic","state":"pass","exit_code":0}
```

That suite performs the complete reference-PCU reproduction:

1. Copies the sibling Flash tree to `/tmp/prismstudio_flash_source`.
2. Rebuilds `examples/photonic_massive.flash` with Flash's `flashc`.
3. Confirms the rebuilt FIR is byte-identical to
   `../flash/examples/photonic_massive.fir`.
4. Imports the FIR through the public PrismStudio agent mutation envelope:

   ```sh
   PRISMSTUDIO_CAPS=all \
   PRISMSTUDIO_SESSION=/tmp/prismstudio_flash_gate.zpa \
   ./zagpa --agent --once \
     'request flash-import current flash import /tmp/prismstudio_flash_source/examples/photonic_massive.fir'
   ```

5. Verifies the active design with `flash verify`.
6. Byte-compares `/tmp/prismstudio_flash_gate.zpa` to
   `examples/flash_photonic_massive.zpa`.
7. Exports BOM, netlist, model manifest, and report, then byte-compares them to:
   - `examples/flash_photonic_massive.bom.txt`
   - `examples/flash_photonic_massive.netlist.txt`
   - `examples/flash_photonic_massive.models.txt`
   - `examples/flash_photonic_massive.report.txt`

Expected import summary:

```text
ops=64 components=384 verification_failures=0
```

Expected verify summary:

```text
Flash photonic execution verified
```

## Manual step-by-step reproduction

```sh
rm -rf /tmp/prismstudio_flash_source
cp -a ../flash /tmp/prismstudio_flash_source
(cd /tmp/prismstudio_flash_source && ./flashc examples/photonic_massive.flash --target ppu32 >/dev/null)
cmp /tmp/prismstudio_flash_source/examples/photonic_massive.fir ../flash/examples/photonic_massive.fir

rm -f /tmp/prismstudio_flash_gate.zpa* /tmp/prismstudio_flash_export.*
PRISMSTUDIO_CAPS=all \
PRISMSTUDIO_SESSION=/tmp/prismstudio_flash_gate.zpa \
./zagpa --agent --once \
  'request flash-import current flash import /tmp/prismstudio_flash_source/examples/photonic_massive.fir'

PRISMSTUDIO_CAPS=all \
PRISMSTUDIO_SESSION=/tmp/prismstudio_flash_gate.zpa \
./zagpa --agent --once 'flash verify'

cmp /tmp/prismstudio_flash_gate.zpa examples/flash_photonic_massive.zpa

PRISMSTUDIO_CAPS=all \
PRISMSTUDIO_SESSION=/tmp/prismstudio_flash_gate.zpa \
./zagpa --agent --once 'export /tmp/prismstudio_flash_export'

cmp /tmp/prismstudio_flash_export.bom.txt examples/flash_photonic_massive.bom.txt
cmp /tmp/prismstudio_flash_export.netlist.txt examples/flash_photonic_massive.netlist.txt
cmp /tmp/prismstudio_flash_export.models.txt examples/flash_photonic_massive.models.txt
cmp /tmp/prismstudio_flash_export.report.txt examples/flash_photonic_massive.report.txt
```

## Artifact meanings

- `examples/flash_photonic_massive.zpa` is the canonical PrismStudio project.
- `examples/flash_photonic_massive.trace.txt` is the deterministic engine trace
  used by the `deterministic-trace` gate.
- `examples/flash_photonic_massive.report.txt` states the software simulation
  evidence level and must not be reworded as hardware proof.
- The command path above is public automation: it uses the same native agent
  dispatcher and mutation envelope that MCP and `zagctl` use.
