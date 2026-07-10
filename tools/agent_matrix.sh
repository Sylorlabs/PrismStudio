#!/bin/sh
# agent_matrix.sh — exercise the agent command layer across request classes
# (Masterplan Section 8.3) with a focus on the preview (ask-before-write) and
# streaming/cancellation paths. Every advertised class is covered here or by a
# sibling gate: valid=agent-ops, unauthorized=agent-capability-denial,
# conflicting=agent-revision-conflict, replayed=idempotency, invalid/malformed=
# agent-error-codes; this gate adds preview + cancelled + malformed for the new
# commands and re-checks a valid/invalid pair end to end.
set -e
Z=./zagpa
TMP=/tmp/triton_agent_matrix
rm -f /tmp/triton_cancel

fail() { echo "agent-matrix: FAIL: $1" >&2; exit 1; }

# ── preview: ask-before-write, no mutation ──────────────────────────────────
# scene-independent: a plate needs only an empty lattice floor (no part under it),
# so a far empty floor cell is always a legal placement regardless of the scene.
$Z --agent --once 'preview place plate 60 0 60' | grep -q 'PREVIEW place ok' || fail "legal preview not ok"
$Z --agent --once 'preview place plate 60 1 60' | grep -q 'PREVIEW place blocked' || fail "illegal preview not blocked (off-floor plate)"
$Z --agent --once 'preview delete 999999' | grep -q 'no-such-id' || fail "missing-id delete preview"
# preview leaves the scene unchanged: the component count is identical before/after
BEFORE=$($Z --agent --once 'list' | grep -c '^C ')
printf 'preview place plate 60 0 60\npreview delete 999999\nlist\n' > "$TMP.tcmd"
AFTER=$($Z --agent "$TMP.tcmd" | grep -c '^C ')
[ "$BEFORE" -eq "$AFTER" ] || fail "preview mutated the scene ($BEFORE -> $AFTER components)"

# ── streaming progress + safe cancellation ──────────────────────────────────
$Z --agent --once 'simstream 20' | grep -q 'DONE steps=20' || fail "simstream did not finish"
P=$($Z --agent --once 'simstream 20' | grep -c 'PROGRESS')
[ "$P" -ge 5 ] || fail "simstream did not stream progress (got $P lines)"
printf x > /tmp/triton_cancel
$Z --agent --once 'simstream 1000' | grep -q 'CANCELLED step=0' || fail "cancel sentinel not honored"
rm -f /tmp/triton_cancel

# ── malformed requests are rejected with stable codes ───────────────────────
$Z --agent --once 'simstream' | grep -q 'E_SIMSTREAM' || fail "malformed simstream not rejected"
$Z --agent --once 'simstream -5' | grep -q 'E_SIMSTREAM' || fail "negative simstream not rejected"
$Z --agent --once 'preview frobnicate' | grep -q 'E_PREVIEW' || fail "unknown preview subcommand not rejected"
$Z --agent --once 'preview place bogus 1 1 1' | grep -q 'E_PREVIEW unknown kind' || fail "invalid kind not rejected"

# ── valid/invalid tool pair end to end ──────────────────────────────────────
$Z --agent --once 'kinds' | grep -q 'chamber' || fail "valid read tool failed"
$Z --agent --once 'get 999999' | grep -qi 'err' || fail "invalid get not rejected"

echo "agent-matrix: ALL PASS"
