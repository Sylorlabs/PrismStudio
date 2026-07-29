#!/usr/bin/env bash
# Launch Zag Photonics Architect (pure Zag, talks to X directly).
set -e
cd "$(dirname "$0")"

ZNC="${ZNC:-../zag/zag-poc/znc}"
needs_build=0
if [ ! -x zagpa ]; then
    needs_build=1
elif find src std -type f -name '*.zag' -newer zagpa -print -quit | grep -q .; then
    needs_build=1
fi

# znc does not overwrite an existing executable. Build beside it and replace
# atomically so a running old process cannot leave future launches stale.
if [ "$needs_build" -eq 1 ]; then
    if [ ! -x "$ZNC" ]; then
        echo "run: stale/missing zagpa and znc not found at $ZNC" >&2
        exit 1
    fi
    echo "run: rebuilding stale zagpa"
    rm -f zagpa.new
    "$ZNC" src/main.zag -o zagpa.new
    mv -f zagpa.new zagpa
fi

ROOT="$(pwd)"
mkdir -p .prismstudio
export PRISMSTUDIO_SESSION="${PRISMSTUDIO_SESSION:-$ROOT/.prismstudio/live.zpa}"
if [ ! -f .cursor/mcp.json ]; then
    ./zagpa --mcp-install "$ROOT" >/dev/null 2>&1 || true
fi

exec ./zagpa