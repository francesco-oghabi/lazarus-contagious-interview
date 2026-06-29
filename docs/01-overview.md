# 01 — Overview della campagna

## Contesto: Contagious Interview

**Contagious Interview** (alias *DeceptiveDevelopment*, *DEV#POPPER*, *Famous Chollima*) è una campagna riconducibile a **Lazarus** (DPRK). Lo schema:

1. Un finto recruiter contatta uno sviluppatore (LinkedIn, Telegram, freelance board).
2. Come parte del "colloquio" gli viene chiesto di scaricare ed eseguire un progetto — di solito un'app Web3 / gioco / dApp — per "completare un task" o "fixare un bug".
3. Il progetto è **trojanizzato**: un loader malevolo è nascosto in un file altrimenti normale.
4. Eseguendo il progetto la vittima infetta la propria macchina di sviluppo, ricca di credenziali e wallet crypto.

L'obiettivo finale è tipicamente **finanziario** (furto di crypto-asset) e di **accesso** (credenziali, sessioni, segreti aziendali).

## Questo campione

L'esca è **"ChainFlip Labs Platform"**, presentata come piattaforma Web3 multi-funzione (poker/gaming + wallet). Il README originale (conservato in [`samples/lure/README.original.md`](../samples/lure/README.original.md)) gonfia lo stack tecnologico — dichiara Solana, Next.js 16, React 19, TypeScript — mentre il codice reale è una semplice app Create-React-App + Express + ethers/Polygon. Questa incoerenza tra README e sorgente è un **tell** tipico delle esche costruite in fretta.

## Schema dell'attacco (due livelli)

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

Il resto del progetto (client React, logica di gioco, modelli Mongo, socket) è **codice di facciata** legittimo: serve solo a rendere credibile l'assignment e a indurre l'esecuzione del server.

## TTP (MITRE ATT&CK)

| Tattica | Tecnica | Dettaglio |
|---|---|---|
| Initial Access | **T1566** Phishing / **T1195** Supply Chain | Finto colloquio + repo trojanizzato |
| Execution | **T1059.007** JavaScript | Loader Node.js eseguito al `require` |
| Defense Evasion | **T1027** Obfuscated Files | `obfuscator.io`, base64, indentazione fuori schermo |
| Command & Control | **T1071.001** Web Protocols | Beacon HTTP verso C2:1224 |
| Execution | **T1620** Reflective / in-memory | `eval()` della seconda fase, mai su disco |
| Credential Access | **T1555.003** Credentials from Browsers | Furto password/cookie |
| Collection | **T1005 / T1552.001** | `process.env`, file di config, keystore |
| Exfiltration | **T1041** Exfil over C2 | Dati verso lo stesso operatore |

Vedi [02-stage1-loader.md](./02-stage1-loader.md) e [03-stage2-stealer.md](./03-stage2-stealer.md).
