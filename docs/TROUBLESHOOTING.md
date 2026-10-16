# Troubleshooting Guide

## `No route to host`
1. Run `ip -br address` and `ip route` on both VMs.
2. Verify both VMs are attached to the same host-only/internal lab network.
3. Confirm addresses, subnet masks, and routes are correct.
4. Check adapter state and firewall rules.
5. ICMP may be blocked, so a failed ping alone does not prove TCP is unreachable.

## `Connection refused`
- Usually the host is reachable but no process is listening, or a firewall actively rejects the connection.
- Start the sensor listener first: `nc -lv <SURICATA_IP> 8080`.
- Check `ss -lntp | grep 8080`.
- Confirm the client connects to the sensor IP, not its own address.

## Wrong interface / no packets
- Use `ip route get <CLIENT_IP>` on the sensor.
- Check `sudo tcpdump -ni <INTERFACE> tcp port 8080`.
- A passive sensor on an unrelated interface will not see unicast traffic. Traffic must actually traverse or reach the monitored interface.

## Missing alerts
- Validate: `sudo suricata -T -c /etc/suricata/suricata.yaml`.
- Confirm `local.rules` is listed in `rule-files`.
- Start Suricata before creating a fresh connection.
- Confirm destination port 8080 and TCP SYN traffic.
- Inspect `sudo journalctl -u suricata --since "10 minutes ago"`.
- Verify `fast.log` and EVE output are enabled and check the configured log directory.

## `jq: command not found`
Install it with `sudo apt install -y jq`.
