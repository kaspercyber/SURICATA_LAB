# Screenshot Evidence

Save screenshots from your own lab runs in this directory. Suggested names:

1. `01-topology.png` — VM network adapters/topology (avoid exposing unrelated personal information).
2. `02-interface-addresses.png` — `ip -br address` on the sensor.
3. `03-suricata-validation.png` — successful `sudo suricata -T -c /etc/suricata/suricata.yaml`.
4. `04-custom-rule.png` — `local.rules` containing SID 1000001.
5. `05-suricata-running.png` — Suricata running on the selected interface.
6. `06-netcat-connection.png` — listener and client connection.
7. `07-fast-log-alert.png` — actual custom alert in `fast.log`.
8. `08-eve-json-alert.png` — filtered event in `eve.json` using `jq`.
9. `09-verification-checklist.png` — completed checklist or report summary.

Only add screenshots you personally captured. Do not use synthetic sample logs as proof of a real run. Crop terminal images neatly, use readable font sizes, and redact passwords, tokens, public IPs, personal file paths, or unrelated private data.
