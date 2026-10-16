#!/usr/bin/env bash
set -euo pipefail
out="${1:-evidence/command-output.txt}"
mkdir -p "$(dirname "$out")"
{
  echo "=== Capture timestamp ==="
  date -Is
  echo
  echo "=== Host ==="
  hostname
  echo
  echo "=== Interfaces ==="
  ip -br address
  echo
  echo "=== Routes ==="
  ip route
  echo
  echo "=== Suricata version ==="
  suricata --build-info 2>&1 | head -n 18 || true
  echo
  echo "=== Reminder ==="
  echo "This is command-line evidence, not a screenshot. Review and redact before sharing."
} > "$out"
echo "Wrote $out. Review it for sensitive details before committing."
