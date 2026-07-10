#!/bin/sh
# probe_manifest_audit.sh — every probe source is classified in probe/MANIFEST.md
# (production vs hardware/bench/compiler/obsolete), and no generated binaries are
# tracked under probe/ (Masterplan Section 4.2: separate production tests from
# obsolete probes and generated binaries).
set -e
fail() { echo "probe-manifest-audit: FAIL: $1" >&2; exit 1; }

# no tracked non-source files under probe/ (only .zag + .md)
if git ls-files probe/ | grep -qvE '\.(zag|md)$'; then
  git ls-files probe/ | grep -vE '\.(zag|md)$'
  fail "generated/binary files are tracked under probe/"
fi

# every probe source is listed in the manifest
for f in probe/*.zag; do
  base=$(basename "$f")
  grep -q "\`$base\`" probe/MANIFEST.md || fail "$base is not classified in probe/MANIFEST.md"
done
echo "probe-manifest-audit: ALL CLASSIFIED"
