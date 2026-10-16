# Suricata IDS Practical Lab — Portfolio Project

A beginner-friendly, screenshot-documented Suricata Intrusion Detection System (IDS) practical for an authorized, isolated cybersecurity lab.

## Repository contents

```text
.
├── docs/                    # Full manual, screenshot guide, troubleshooting
├── evidence/                # Screenshot checklist and evidence index
├── results/                 # Result template and sample alert (synthetic)
├── scripts/                 # Traffic generator and evidence helper
├── suricata/
│   ├── config/               # Safe configuration reference snippets
│   └── rules/local.rules     # Custom detection rule
├── tests/                    # Rule and project sanity checks
├── .github/workflows/        # Automated repository checks
├── .gitignore
└── README.md
```

## Safety and authorization
Use this project only on computers and networks you own or have explicit permission to test. The included traffic generator sends a short TCP message only to the target IP you explicitly supply. Do not run it against public or third-party systems.

## Objectives
- Identify network interfaces, IP addresses, and routes.
- Install and validate Suricata.
- Load a custom local detection signature.
- Generate TCP/8080 test traffic with Netcat.
- Inspect alerts in `fast.log` and `eve.json` with `grep` and `jq`.
- Capture real screenshots and document results for a portfolio.

## Topology

```text
Client VM (<CLIENT_IP>) ---- isolated lab network ---- Suricata sensor (<SURICATA_IP>)
                                                    capture interface: <INTERFACE>
                                         TCP SYN / connection to port 8080
```

Replace `<CLIENT_IP>`, `<SURICATA_IP>`, and `<INTERFACE>` with your actual values. Do not type the angle brackets literally. Example addresses such as `192.168.56.10` and `192.168.56.20` are only examples; use values that match your own VM network.

## Quick start

### 1. Identify interfaces (sensor and client)
```bash
ip -br address
ip route
```
On the sensor:
```bash
sudo suricata --list-interfaces
sudo tcpdump -D
```
If `suricata --list-interfaces` is not supported, use `ip -br address` and `tcpdump -D` where available. Choose the interface that receives client-to-sensor traffic.

### 2. Install tools
On Ubuntu/Debian sensor:
```bash
sudo apt update
sudo apt install -y suricata jq tcpdump
suricata --build-info
```
On client:
```bash
sudo apt update
sudo apt install -y netcat-openbsd
```

### 3. Install the custom rule
Back up an existing file before editing:
```bash
sudo install -d /etc/suricata/rules
sudo cp -a /etc/suricata/rules/local.rules /etc/suricata/rules/local.rules.bak 2>/dev/null || true
sudo cp suricata/rules/local.rules /etc/suricata/rules/local.rules
```
Make sure `/etc/suricata/suricata.yaml` includes `local.rules` under `rule-files`, and that `default-rule-path` points to the rules directory. Merge the setting into your existing configuration; do not replace the whole YAML file.

Validate:
```bash
sudo suricata -T -c /etc/suricata/suricata.yaml
```
Expected: successful configuration/rule loading. If it fails, check the path, indentation, and rule-files list.

### 4. Start Suricata
Service mode:
```bash
sudo systemctl status suricata --no-pager
sudo systemctl restart suricata
```
If you need to bind to a specific interface, stop the service first to avoid two instances sharing the same logs:
```bash
sudo systemctl stop suricata
sudo suricata -c /etc/suricata/suricata.yaml -i <INTERFACE>
```
Leave foreground mode running. Stop it with Ctrl+C when finished.

### 5. Start a listener and generate traffic
On the sensor:
```bash
nc -lv <SURICATA_IP> 8080
```
On the client, in another terminal:
```bash
nc -v <SURICATA_IP> 8080
```
Type `LAB-TEST-8080`, press Enter, then exit with Ctrl+C. Netcat flags differ between versions; check `nc -h` if needed. Start the listener before connecting for a successful end-to-end test.

Optional helper, from the project directory on the client:
```bash
chmod +x scripts/generate_test_traffic.sh
./scripts/generate_test_traffic.sh <SURICATA_IP>
```

### 6. Analyze alerts
```bash
sudo tail -f /var/log/suricata/fast.log
sudo grep 'LAB TCP 8080' /var/log/suricata/fast.log
sudo tail -n 20 /var/log/suricata/eve.json | jq .
sudo jq 'select(.event_type == "alert" and .alert.signature_id == 1000001)' /var/log/suricata/eve.json
```
Expected: an alert with SID `1000001` and the custom message. The alert appears only if the traffic is visible to Suricata, the rule is loaded, and logging is enabled. Paths vary by distribution.

## Custom rule
```text
alert tcp any any -> any 8080 (msg:"LAB TCP 8080 connection attempt"; flags:S; sid:1000001; rev:1;)
```
This detects TCP SYN packets to destination port 8080. It is an educational rule, not a production security policy.

## Screenshot evidence — required for portfolio
Use `docs/SCREENSHOT_GUIDE.md` and save your own screenshots in `evidence/`. Do not present sample output as evidence from a real run. Suggested captures:
1. VM network settings/topology (hide unrelated personal details).
2. `ip -br address` showing the chosen interface and IP.
3. Successful `suricata -T` validation.
4. The custom rule file.
5. Suricata running on the chosen interface.
6. Netcat listener and client connection.
7. `fast.log` custom alert.
8. `eve.json` filtered with `jq`.
9. Troubleshooting/final verification checklist.

## Troubleshooting
- **No route to host:** check VM network mode, subnet, addresses, routes, and firewall.
- **Connection refused:** start the listener first; check `ss -lntp | grep 8080`.
- **Wrong interface:** use `ip route get <CLIENT_IP>` and `sudo tcpdump -ni <INTERFACE> tcp port 8080`.
- **Missing alerts:** validate config, confirm `local.rules` is loaded, start Suricata before reconnecting, and verify packets arrive on the capture interface.
- **Missing EVE events:** inspect `outputs: eve-log:` in the active YAML configuration and ensure `alert` is enabled.
- **`jq` missing:** `sudo apt install -y jq`.

## Verification checklist
- [ ] Correct sensor/client addresses recorded.
- [ ] Correct interface identified.
- [ ] Suricata installed and configuration test passes.
- [ ] `local.rules` is loaded.
- [ ] Listener is active on TCP/8080.
- [ ] Client traffic is visible at the sensor.
- [ ] SID 1000001 alert found in `fast.log` and/or `eve.json`.
- [ ] Screenshots saved in `evidence/`.
- [ ] Result template completed in `results/RESULTS_TEMPLATE.md`.
- [ ] No real credentials, sensitive unrelated data, or live logs committed accidentally.

## Challenge
Create a second rule for TCP SYN traffic to port 9090 using SID `1000002`. Validate it, generate traffic only in the authorized lab, capture the alert, and document the rule, command, result, and one troubleshooting step.

## Learning note
The repository includes synthetic sample alerts for demonstrating formatting. Replace them in your report with sanitized evidence from your own run.
