<!-- 🇬🇧 English (default) · 🇮🇹 Italiano: 04-iocs.it.md -->

# 04 — Indicators of Compromise (IOCs)

> *Defanged* indicators for reading. Machine-readable "live" versions for import/blocklist in [`../iocs/`](../iocs/).

## Network

| Type | Value (defanged) | Notes |
|---|---|---|
| C2 URL | `hxxp://216[.]250[.]251[.]187:1224/api/checkStatus` | Beacon / stage 2 delivery endpoint |
| C2 IP | `216[.]250[.]251[.]187` | |
| Port | `1224` | C2 port characteristic of the *Contagious Interview* campaign |
| URI path | `/api/checkStatus` | |
| Query params | `sysInfo`, `processInfo`, `tid`, `sysId` | Beacon parameter schema |
| User-Agent | default of `fetch`/`undici` (Node) | Beacon from `node` process, not from a browser |
| Cadence | beacon every **5000 ms** | `setInterval(..., 0x1388)` |

## Host / files

| Type | Value |
|---|---|
| Infected file | `routes/api/auth.js` (top-level payload at the bottom, line 17) |
| Campaign id (`tid`) | `now it time to get everything` |
| `tid` base64 | `bm93IGl0IHRpbWUgdG8gZ2V0IGV2ZXJ5dGhpbmc=` |
| C2 URL base64 | `aHR0cDovLzIxNi4yNTAuMjUxLjE4NzoxMjI0L2FwaS9jaGVja1N0YXR1cw==` |
| Technique | `obfuscator.io` obfuscation + base64 + `eval()` on C2 response |
| Process | `node` opening outbound connections to `:1224` |

## Useful strings/patterns for detection

```
eval(                              ← on a variable from the HTTP response
processInfo                        ← process.env exfiltration parameter
checkStatus                        ← C2 path
216.250.251.187                    ← C2 IP
1224                               ← C2 port
aHR0cDovLzIxNi4yNTAuMjUxL          ← base64 prefix of the C2 URL
bm93IGl0IHRpbWUgdG8gZ2V0           ← base64 prefix of the tid
_0x                                ← obfuscation marker (low value on its own)
```

## Known false positives (CLEAN files in this repo)

| File | Why it looks suspicious but is clean |
|---|---|
| `socket/packet.js` | Hex constants = game event ids |
| `client/src/components/decoration/WatermarkText.js` | Very long line = SVG `path` |
| `client/src/components/logo/LogoWithText.js` | Very long line = SVG `path` |
| `client/src/utils/interact.js`, `pages/ConnectWallet/` | Legitimate wallet code (part of the lure, not malicious) |

Ready-to-use rules: [05-detection.md](./05-detection.md) and [`../rules/`](../rules/).
