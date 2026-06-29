<!-- 🇬🇧 English (default) · 🇮🇹 Italiano: post-2-technical.it.md -->
<!-- LinkedIn post #2 — technical / security peers -->

🔬 Anatomy of a Lazarus "Contagious Interview" sample — and the detections to catch it.

I reverse-engineered a trojanized "Web3 poker" repo handed out as a fake interview assignment. Two stages, one goal: empty the developer's machine. Breakdown 👇

🧩 STAGE 1 — the loader (static, in-repo)
Hidden at the end of `routes/api/auth.js`, padded with hundreds of spaces and obfuscated (obfuscator.io style). It executes on `require()` — i.e. at server start, no endpoint call needed. It:
• profiles the host (hostname, OS, MAC)
• exfiltrates the ENTIRE `process.env` (JWT secret, Mongo URI, API keys) in cleartext over HTTP
• beacons every 5s to the C2 and runs `eval()` on the response
• C2 (defanged): hxxp://216[.]250[.]251[.]187:1224/api/checkStatus
• campaign id in the `tid` param decodes to: "now it time to get everything"

🧩 STAGE 2 — the stealer (dynamic, via eval)
Never stored in the repo — delivered by the C2 and run in memory (InvisibleFerret family). Targets browser Login Data, session cookies (MFA bypass), autofill, and crypto wallets (MetaMask/Phantom), plus keychains and SSH/cloud keys.

🎯 Why it evades:
in-memory eval (no stage-2 on disk) + base64 + off-screen indentation + benign-looking lure project.

🛡️ Detections (all open-sourced in the dossier):
• YARA — flags the obfuscated loader by C2 base64 + the `processInfo`+`eval(`+`_0x` behavioral combo
• Sigma — a `node` process beaconing to 216[.]250[.]251[.]187 / port 1224
• Suricata — HTTP to `/api/checkStatus` carrying `processInfo=`
• Machine-readable IOCs (CSV + STIX 2.1) and a network blocklist
• CI that compiles the YARA rules and asserts they still match the sample

Hunting one-liner for your repos / npm deps:
`grep -rIlE "processInfo|checkStatus|216\.250\.251\.187" .`

Full bilingual (EN/IT) write-up, deobfuscated code, IOCs and rules — link in the comments. 🔗

What other detection angles would you add? 👇

#ThreatIntel #DFIR #DetectionEngineering #YARA #Sigma #Lazarus #MalwareAnalysis #InfoSec #IOC
