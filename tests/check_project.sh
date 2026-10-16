#!/usr/bin/env bash
set -euo pipefail
test -s README.md
test -s suricata/rules/local.rules
grep -q 'sid:1000001' suricata/rules/local.rules
grep -q 'flags:S' suricata/rules/local.rules
test -x scripts/generate_test_traffic.sh
echo "Project structure and custom-rule checks passed."
echo "This is a repository sanity check; it does not validate Suricata's installed configuration."
