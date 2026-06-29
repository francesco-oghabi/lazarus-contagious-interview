<!-- 🇬🇧 English (default) · 🇮🇹 Italiano: 01-overview.it.md -->

# 01 — Campaign Overview

## Context: Contagious Interview

**Contagious Interview** (aka *DeceptiveDevelopment*, *DEV#POPPER*, *Famous Chollima*) is a campaign attributed to **Lazarus** (DPRK). The scheme:

1. A fake recruiter contacts a developer (LinkedIn, Telegram, freelance board).
2. As part of the "interview" they are asked to download and run a project — usually a Web3 app / game / dApp — to "complete a task" or "fix a bug".
3. The project is **trojanized**: a malicious loader is hidden inside an otherwise ordinary file.
4. By running the project, the victim infects their development machine, which is rich in credentials and crypto wallets.

The ultimate goal is typically **financial** (theft of crypto-assets) and **access-oriented** (credentials, sessions, corporate secrets).

## This sample

The lure is **"ChainFlip Labs Platform"**, presented as a multi-purpose Web3 platform (poker/gaming + wallet). The original README (preserved in [`samples/lure/README.original.md`](../samples/lure/README.original.md)) inflates the tech stack — it claims Solana, Next.js 16, React 19, TypeScript — while the actual code is a plain Create-React-App + Express + ethers/Polygon app. This inconsistency between the README and the source is a typical **tell** of hastily built lures.

## Attack scheme (two stages)

```
┌──────────────────────────────────────────────────────────────┐
│ LIVELLO 1 — LOADER (statico nel repo, offuscato)            │
│ File: routes/api/auth.js (riga 17)                          │
│  • profila la macchina (hostname, OS, MAC)                  │
│  • esfiltra TUTTE le variabili d'ambiente (process.env)     │
│  • beacon HTTP al C2  216[.]250[.]251[.]187:1224            │
│  • eval(message) della risposta  ──────────────┐           │
│  • ripete ogni 5 secondi                       │           │
└────────────────────────────────────────────────┼───────────┘
                                                  ▼
┌──────────────────────────────────────────────────────────────┐
│ LIVELLO 2 — INFO-STEALER (consegnato a runtime via eval)    │
│ Famiglia: InvisibleFerret / browser-stealer JS              │
│  • NON presente nel repo: scaricato dal C2                  │
│  • eseguito in memoria, mai scritto su disco               │
│  • ruba password, cookie/sessioni, autofill dei browser    │
│  • ruba wallet crypto (MetaMask, Phantom) e keychain       │
│  • esfiltra verso l'infrastruttura dell'operatore          │
└──────────────────────────────────────────────────────────────┘
```

The rest of the project (React client, game logic, Mongo models, sockets) is legitimate **facade code**: it exists only to make the assignment believable and to induce execution of the server.

## TTPs (MITRE ATT&CK)

| Tactic | Technique | Detail |
|---|---|---|
| Initial Access | **T1566** Phishing / **T1195** Supply Chain | Fake interview + trojanized repo |
| Execution | **T1059.007** JavaScript | Node.js loader executed at `require` |
| Defense Evasion | **T1027** Obfuscated Files | `obfuscator.io`, base64, off-screen indentation |
| Command & Control | **T1071.001** Web Protocols | HTTP beacon to C2:1224 |
| Execution | **T1620** Reflective / in-memory | `eval()` of the second stage, never on disk |
| Credential Access | **T1555.003** Credentials from Browsers | Password/cookie theft |
| Collection | **T1005 / T1552.001** | `process.env`, config files, keystore |
| Exfiltration | **T1041** Exfil over C2 | Data to the same operator |

See [02-stage1-loader.md](./02-stage1-loader.md) and [03-stage2-stealer.md](./03-stage2-stealer.md).
