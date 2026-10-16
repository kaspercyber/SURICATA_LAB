#!/usr/bin/env bash
set -euo pipefail
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <SURICATA_IP>" >&2
  echo "Start a listener on the authorized sensor at TCP/8080 first." >&2
  exit 2
fi
target="$1"
port=8080
if ! command -v nc >/dev/null 2>&1; then
  echo "Netcat missing. Install with: sudo apt install -y netcat-openbsd" >&2
  exit 127
fi
echo "[*] Sending one short lab message to ${target}:${port}"
echo "[*] Authorized lab systems only."
printf '%s\n' 'LAB-TEST-8080' | nc -v -w 3 "$target" "$port"
echo "[+] Netcat command completed."
