<!-- Language: English (default) · 🇮🇹 Italiano: README.it.md -->

> # ⛔ DANGER — DO NOT INSTALL OR RUN THIS PROJECT
> **The code in this repository is live malware.** Do **not** run `npm install`, `npm run dev`, `node server.js`, or any build/install step on a real machine — the payload executes the moment the server starts, with no further interaction.
> Analyze **only** inside an isolated VM (revertible snapshot, no credentials, monitored or disconnected network). Samples in [`samples/`](./samples/) are isolated as `.txt` — do not rename or execute them. See [SECURITY.md](./SECURITY.md).

---

# 🛑 Lazarus "Contagious Interview" — ChainFlip Labs Platform (Trojanized Repo)

**Threat-intelligence dossier — defensive / educational use only.**

This repository documents a real sample of the North-Korean **Lazarus / Contagious Interview** campaign (aka *DeceptiveDevelopment*, *DEV#POPPER*). The malware is delivered as a fake job-interview *coding assignment*: a seemingly harmless "Web3 poker / ChainFlip Labs" project with a malicious loader hidden inside the server code.

🇮🇹 **Versione italiana:** [README.it.md](./README.it.md)

---

## TL;DR

| | |
|---|---|
| **Family** | Obfuscated JS loader (BeaverTail-style) → second-stage stealer (InvisibleFerret) |
| **Lure** | Fake Web3/poker project "ChainFlip Labs" handed out during an interview |
| **Infected file** | [`routes/api/auth.js`](./routes/api/auth.js) — payload appended at line 17 |
| **C2** | `hxxp://216[.]250[.]251[.]187:1224/api/checkStatus` |
| **Trigger** | Runs on `require()` of the router → at server startup |
| **Impact** | `process.env` theft (secrets), RCE via `eval`, browser password/cookie & crypto-wallet theft |

```
STAGE 1 (in-repo)              STAGE 2 (delivered via eval)
routes/api/auth.js     ──►     browser + wallet stealer
profiles host                  passwords, cookies/sessions,
steals process.env             MetaMask/Phantom, keychain
beacons every 5s to C2 ────────► eval(message) from C2
```

---

## 📚 Documentation

| Doc | Content |
|---|---|
| [docs/01-overview.md](./docs/01-overview.md) | Campaign, context (Contagious Interview), TTPs, attack chain |
| [docs/02-stage1-loader.md](./docs/02-stage1-loader.md) | Loader analysis (obfuscated → deobfuscated) |
| [docs/03-stage2-stealer.md](./docs/03-stage2-stealer.md) | Second stage (`eval`/InvisibleFerret), behavior |
| [docs/04-iocs.md](./docs/04-iocs.md) | Indicators of compromise (explained) |
| [docs/05-detection.md](./docs/05-detection.md) | Detection: YARA, Sigma, Suricata, hunting |
| [docs/06-remediation.md](./docs/06-remediation.md) | Remediation & prevention |
| [docs/07-references.md](./docs/07-references.md) | Sources & attribution |

## 🗂️ Artifacts

| Folder | Content |
|---|---|
| [`iocs/`](./iocs/) | Machine-readable IOCs: `iocs.csv`, `iocs.json` (STIX 2.1), `network.txt` (blocklist) |
| [`rules/`](./rules/) | Detection rules: YARA, Sigma, Suricata |
| [`samples/`](./samples/) | Isolated, defanged payload + original lure README as evidence |

---

## ⚖️ Disclaimer

Published for **defensive, research and educational purposes only**, to enable detection and remediation. Malicious code is included solely in neutralized/isolated form under `samples/`. The authors take no responsibility for misuse. See [SECURITY.md](./SECURITY.md).
