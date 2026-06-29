<!-- Lingua: Italiano · 🇬🇧 English (default): README.md -->

> # ⛔ PERICOLO — NON INSTALLARE NÉ ESEGUIRE QUESTO PROGETTO
> **Il codice in questo repository è malware reale.** Non eseguire `npm install`, `npm run dev`, `node server.js` né alcun passo di build/install su una macchina reale: il payload parte al solo avvio del server, senza ulteriore interazione.
> Analizzare **solo** in VM isolata (snapshot revertibile, senza credenziali, rete monitorata o staccata). I campioni in [`samples/`](./samples/) sono isolati come `.txt` — non rinominarli né eseguirli. Vedi [SECURITY.md](./SECURITY.md).

---

# 🛑 Lazarus "Contagious Interview" — ChainFlip Labs Platform (Repo Trojanizzato)

**Dossier di threat intelligence — solo uso difensivo / educativo.**

Questo repository documenta un campione reale della campagna nordcoreana **Lazarus / Contagious Interview** (alias *DeceptiveDevelopment*, *DEV#POPPER*). Il malware è consegnato come finto *coding assignment* di colloquio: un progetto "Web3 poker / ChainFlip Labs" apparentemente innocuo, con un loader malevolo nascosto nel codice del server.

🇬🇧 **English version (default):** [README.md](./README.md)

---

## TL;DR

| | |
|---|---|
| **Famiglia** | Loader JS offuscato (stile BeaverTail) → stealer di seconda fase (InvisibleFerret) |
| **Esca** | Finto progetto Web3/poker "ChainFlip Labs" consegnato in colloquio |
| **File infetto** | [`routes/api/auth.js`](./routes/api/auth.js) — payload in fondo (riga 17) |
| **C2** | `hxxp://216[.]250[.]251[.]187:1224/api/checkStatus` |
| **Trigger** | Esecuzione al `require()` del router → all'avvio del server |
| **Impatto** | Furto `process.env` (segreti), RCE via `eval`, furto password/cookie browser e wallet crypto |

```
LIVELLO 1 (in-repo)            LIVELLO 2 (consegnato via eval)
routes/api/auth.js     ──►     stealer browser + wallet
profila host                   password, cookie/sessioni,
ruba process.env               MetaMask/Phantom, keychain
beacon ogni 5s al C2 ──────────► eval(message) dal C2
```

---

## 📚 Documentazione

| Doc | Contenuto |
|---|---|
| [docs/01-overview.md](./docs/01-overview.md) | Campagna, contesto (Contagious Interview), TTP, schema dell'attacco |
| [docs/02-stage1-loader.md](./docs/02-stage1-loader.md) | Analisi del loader (offuscato → deoffuscato) |
| [docs/03-stage2-stealer.md](./docs/03-stage2-stealer.md) | Seconda fase (`eval`/InvisibleFerret), comportamento |
| [docs/04-iocs.md](./docs/04-iocs.md) | Indicatori di compromissione (spiegati) |
| [docs/05-detection.md](./docs/05-detection.md) | Detection: YARA, Sigma, Suricata, hunting |
| [docs/06-remediation.md](./docs/06-remediation.md) | Bonifica e prevenzione |
| [docs/07-references.md](./docs/07-references.md) | Fonti e attribuzione |

## 🗂️ Artefatti

| Cartella | Contenuto |
|---|---|
| [`iocs/`](./iocs/) | IOC machine-readable: `iocs.csv`, `iocs.json` (STIX 2.1), `network.txt` (blocklist) |
| [`rules/`](./rules/) | Regole di detection: YARA, Sigma, Suricata |
| [`samples/`](./samples/) | Payload isolato e *defanged* + README-esca originale come evidenza |

---

## ⚖️ Disclaimer

Materiale pubblicato a **soli fini difensivi, di ricerca ed educativi** per consentire detection e bonifica. Il codice malevolo è incluso esclusivamente in forma neutralizzata/isolata in `samples/`. Gli autori non sono responsabili di un uso improprio. Vedi [SECURITY.md](./SECURITY.md).
