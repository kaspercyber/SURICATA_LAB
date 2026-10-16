# Screenshot Capture Guide

Screenshots are part of the deliverable: they show that you performed the practical, not merely read the instructions. Capture them from your own VM session. No screenshots are fabricated or prefilled in this repository.

## Recommended evidence sequence

| File | What to show | Suggested command / view |
|---|---|---|
| `01-topology.png` | Client and sensor on the intended isolated network | VM network settings or a simple topology diagram |
| `02-interface-addresses.png` | Sensor interface and IP | `ip -br address` |
| `03-suricata-validation.png` | Successful rule/config test | `sudo suricata -T -c /etc/suricata/suricata.yaml` |
| `04-custom-rule.png` | SID and rule text | `cat /etc/suricata/rules/local.rules` |
| `05-suricata-running.png` | Sensor running on correct interface | foreground command or service status |
| `06-netcat-connection.png` | Client-to-sensor TCP connection | listener and client terminals |
| `07-fast-log-alert.png` | Custom signature in fast.log | `sudo grep 'LAB TCP 8080' /var/log/suricata/fast.log` |
| `08-eve-json-alert.png` | Parsed JSON alert fields | `sudo jq 'select(.event_type == "alert" and .alert.signature_id == 1000001)' /var/log/suricata/eve.json` |
| `09-verification-checklist.png` | Final checklist/report | completed results template |

## Quality checklist
- Make the command and output readable.
- Keep the terminal prompt visible when useful, but do not expose usernames or paths you prefer to keep private.
- Capture the successful output, not just the command.
- Do not include credentials, tokens, browser tabs with private information, or unrelated notifications.
- Do not edit an image in a way that changes the apparent test result.
- Give each image a caption in your final portfolio README or report.
