<!-- 🇬🇧 English (default) · 🇮🇹 Italiano: 05-detection.it.md -->

# 05 — Detection & Hunting

Complete rules in [`../rules/`](../rules/). This page covers the rationale and the hunting queries.

## YARA — [`rules/lazarus_chainflip_loader.yar`](../rules/lazarus_chainflip_loader.yar)

Detects the static loader in JS source files. It combines multiple indicators to reduce false positives:
- base64 of the C2 URL and/or of the `tid`;
- `processInfo` + `eval(` pattern;
- cleartext C2 IP/port;
- `_0x` obfuscation marker.

Designed for scanning repos, npm packages, attachments, and filesystem snapshots.

## Sigma — [`rules/lazarus_chainflip.sigma.yml`](../rules/lazarus_chainflip.sigma.yml)

Behavioral detection on process/EDR logs:
- `node` process establishing outbound connections to `216.250.251.187` or port `1224`;
- to be mapped to your own backend (Sysmon EventID 3, EDR network telemetry).

## Suricata/Snort — [`rules/lazarus_chainflip.suricata.rules`](../rules/lazarus_chainflip.suricata.rules)

Network detection:
- HTTP request to the C2 IP/port with URI `/api/checkStatus`;
- presence of the `processInfo=` parameter in the query (exfiltration of `process.env`).

## Hunting queries (adapt to your platform)

**Network connections (EDR/Sysmon):**
```
process_name = "node"  AND  (dest_ip = "216.250.251.187"  OR  dest_port = 1224)
```

**Grep over sources / repos / dependencies:**
```bash
grep -rIlE "processInfo|checkStatus|216\.250\.251\.187|aHR0cDovLzIxNi4yNTAuMjUx|bm93IGl0IHRpbWUgdG8" .

# generic obfuscated loader: eval over a response + _0x marker at the end of a file
grep -rIlE "eval\(" --include='*.js' . | xargs -r grep -lE "_0x[0-9a-f]{4,}"
```

**DNS/proxy:** alert on any request to `216.250.251.187:1224`.

## Quick triage of a suspicious "assignment"

1. Look for **abnormally long lines** or lines with a lot of leading whitespace at the end of files:
   ```bash
   for f in $(git ls-files '*.js'); do awk -v F="$f" 'length>1000{print F":"NR" ("length")"}' "$f"; done
   ```
   (Exclude SVG/minified false positives — see [04-iocs.md](./04-iocs.md).)
2. Look for `eval(`, `Function(`, `child_process`, `require('os')` placed next to `fetch`/`http`.
3. Look for long base64 blobs and decode them before running anything.
4. Never run outside an isolated VM.
