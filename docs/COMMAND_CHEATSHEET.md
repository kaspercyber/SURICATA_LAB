# Suricata IDS Command Cheat Sheet

Use only on systems/networks you own or are authorized to test. Replace placeholders without angle brackets.

## Network
```bash
ip -br address
ip route
ip route get <CLIENT_IP>
sudo suricata --list-interfaces
sudo tcpdump -D
```

## Install and validate
```bash
sudo apt update
sudo apt install -y suricata jq tcpdump
sudo suricata -T -c /etc/suricata/suricata.yaml
```
Client:
```bash
sudo apt update
sudo apt install -y netcat-openbsd
```

## Rule
```bash
sudo install -d /etc/suricata/rules
sudo cp suricata/rules/local.rules /etc/suricata/rules/local.rules
sudo suricata -T -c /etc/suricata/suricata.yaml
```

## Run and generate traffic
```bash
sudo systemctl status suricata --no-pager
sudo systemctl restart suricata
sudo systemctl stop suricata
sudo suricata -c /etc/suricata/suricata.yaml -i <INTERFACE>
nc -lv <SURICATA_IP> 8080
nc -v <SURICATA_IP> 8080
```

## Verify packets and alerts
```bash
sudo tcpdump -ni <INTERFACE> tcp port 8080
sudo tail -f /var/log/suricata/fast.log
sudo grep 'LAB TCP 8080' /var/log/suricata/fast.log
sudo tail -n 20 /var/log/suricata/eve.json | jq .
sudo jq 'select(.event_type == "alert" and .alert.signature_id == 1000001)' /var/log/suricata/eve.json
sudo journalctl -u suricata --since "10 minutes ago"
ss -lntp | grep 8080
```

## Rule explanation
`alert tcp any any -> any 8080 (msg:"LAB TCP 8080 connection attempt"; flags:S; sid:1000001; rev:1;)`
- `alert`: produce an alert.
- `tcp`: TCP traffic.
- `any any -> any 8080`: any source to any destination on port 8080.
- `flags:S`: TCP SYN flag.
- `sid`: unique signature ID; `rev`: rule revision.

## Common fixes
- No route to host: VM network, IP, subnet, route, firewall.
- Connection refused: listener not started or wrong port/address.
- No alert: wrong interface, rule not loaded, config invalid, or logging disabled.
