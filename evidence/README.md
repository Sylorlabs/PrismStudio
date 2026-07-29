# PrismStudio Release Evidence

This directory is the durable index for `masterplan.md`. A plan item is checked
only when its ledger record names reproducible evidence. Generated captures and
reports belong under dated subdirectories; source-controlled fixtures and tests
remain beside the code they verify.

Identified read-only hardware baselines may be committed as dated reports when
the masterplan and progress ledger name them directly. Such reports must state
whether any command submission ran and must never turn preflight into a hardware
certification claim.

Primary gate: `./verify.sh safe` for CPU/X11 work and `./verify.sh release` for
the release gate. GPU modes are explicit: `gpu-memory` does not submit command
buffers; `gpu-dispatch` does and is never automatic.
