#!/bin/sh
# inventory_audit.sh — every src/*.zag module is listed in docs/INVENTORY.md
# (Masterplan Section 4.1: inventory source modules, artifacts, probes, protocols,
# storage formats, and external dependencies — kept current).
set -e
fail() { echo "inventory-audit: FAIL: $1" >&2; exit 1; }
for f in src/*.zag; do
  base=$(basename "$f")
  grep -q "\`$base\`" docs/INVENTORY.md || fail "$base is not in docs/INVENTORY.md"
done
# the required inventory sections are present
for sec in "Source modules" "Probes" "Generated artifacts" "Protocols" "Storage formats" "External dependencies"; do
  grep -q "$sec" docs/INVENTORY.md || fail "missing section: $sec"
done
echo "inventory-audit: ALL MODULES INVENTORIED"
