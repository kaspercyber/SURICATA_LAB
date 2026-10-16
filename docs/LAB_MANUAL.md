# Suricata IDS Practical Lab Manual

## Purpose
Use Suricata to detect a TCP SYN connection attempt to port 8080 in an authorized isolated lab. This lab covers setup, a custom rule, Netcat traffic, log analysis, screenshot evidence, troubleshooting, and reporting.

## Learning objectives
1. Identify the correct network interface and addresses.
2. Install and validate Suricata.
3. Load and test a local signature.
4. Generate TCP traffic with Netcat.
5. Analyze fast.log and eve.json.
6. Capture clear, authentic screenshots for a portfolio.

## Topology
`Client VM (<CLIENT_IP>) -> isolated lab network -> Suricata sensor (<SURICATA_IP>)`, monitored on `<INTERFACE>`.

## Prerequisites
- Ubuntu/Debian-like Linux VM(s), sudo on sensor.
- Client and sensor connected to the same intended lab network.
- Suricata, jq, tcpdump on sensor; Netcat on client.

## Step 1 — Identify interface
```bash
ip -br address
ip route
sudo suricata --list-interfaces
```
Use the interface through which the test packets arrive. `ip route get <CLIENT_IP>` can help determine the route.

## Step 2 — Install
```bash
sudo apt update
sudo apt install -y suricata jq tcpdump
suricata --build-info
```
Client:
```bash
sudo apt update
sudo apt install -y netcat-openbsd
```

## Step 3 — Add and validate rule
```bash
sudo install -d /etc/suricata/rules
sudo cp suricata/rules/local.rules /etc/suricata/rules/local.rules
sudo suricata -T -c /etc/suricata/suricata.yaml
```
Ensure the active `suricata.yaml` includes `local.rules` in `rule-files`. Merge settings into the existing file; do not overwrite the whole configuration.

Rule:
```text
alert tcp any any -> any 8080 (msg:"LAB TCP 8080 connection attempt"; flags:S; sid:1000001; rev:1;)
```
This alerts on TCP SYN packets to destination port 8080. It is a simple educational signature.

## Step 4 — Start Suricata
```bash
sudo systemctl status suricata --no-pager
sudo systemctl restart suricata
```
If manually choosing an interface, stop the service first:
```bash
sudo systemctl stop suricata
sudo suricata -c /etc/suricata/suricata.yaml -i <INTERFACE>
```
Do not run competing instances against the same log files.

## Step 5 — Listener and client traffic
Sensor:
```bash
nc -lv <SURICATA_IP> 8080
```
Client:
```bash
nc -v <SURICATA_IP> 8080
```
Type `LAB-TEST-8080` and press Enter. Start the listener before connecting. Netcat options differ between versions; check `nc -h` if needed.

## Step 6 — Analyze logs
```bash
sudo grep 'LAB TCP 8080' /var/log/suricata/fast.log
sudo tail -n 20 /var/log/suricata/eve.json | jq .
sudo jq 'select(.event_type == "alert" and .alert.signature_id == 1000001)' /var/log/suricata/eve.json
```
Expected: a custom alert with SID 1000001. Actual IPs and ephemeral ports vary. If no alert appears, confirm the rule is loaded, the correct interface is monitored, and traffic reaches it.

## Step 7 — Screenshot evidence
Follow `SCREENSHOT_GUIDE.md`. Capture actual screenshots of topology, addresses, rule validation, rule text, running sensor, Netcat connection, fast.log alert, EVE JSON, and final checklist. Store them in `evidence/`. The sample logs are synthetic examples and must not be presented as real capture evidence.

## Step 8 — Troubleshooting
- No route to host: check VM network mode, addresses, subnet, routes, and firewall.
- Connection refused: start listener and check `ss -lntp | grep 8080`.
- Wrong interface: check `ip route get <CLIENT_IP>` and `tcpdump -ni <INTERFACE> tcp port 8080`.
- Missing alerts: run `suricata -T`, ensure local.rules is loaded, start Suricata first, then reconnect.
- Missing JSON alerts: ensure EVE alert output is enabled in the active configuration.

## Step 9 — Checklist
- [ ] IPs and interface documented.
- [ ] Configuration test succeeds.
- [ ] Rule loaded.
- [ ] Listener active.
- [ ] Traffic visible at sensor.
- [ ] SID 1000001 appears in fast.log or eve.json.
- [ ] Screenshots captured and saved.
- [ ] Results template completed.
- [ ] Sensitive data redacted.

## Student questions
1. What is the difference between IDS and IPS?
2. Why does interface selection matter?
3. What does `flags:S` match?
4. What are `sid` and `rev`?
5. Why might tcpdump see traffic while Suricata does not alert?
6. Which EVE fields identify the flow?
7. How could you constrain the rule to a specific source?
8. Why is connection success different from detection success?

## Practical challenge
Create a TCP SYN rule for port 9090 with SID 1000002, validate it, generate traffic only in the authorized lab, capture the alert, and record results in `results/RESULTS_TEMPLATE.md`.
