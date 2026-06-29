<!-- 🇮🇹 Italiano · 🇬🇧 English: 03-stage2-stealer.md -->

# 03 — Livello 2: l'info-stealer (consegnato via `eval`)

## Perché non è nel repo

La seconda fase **non è memorizzata nel repository**: per questo non la si trova "in chiaro" tra i file. Viene scaricata a runtime dal C2 nel campo `message` della risposta JSON ed eseguita con `eval(message)` (vedi [02-stage1-loader.md](./02-stage1-loader.it.md)).

Conseguenze:
- **esecuzione di codice arbitrario** controllata dall'operatore in tempo reale;
- payload **aggiornabile a ogni beacon** (ogni 5 s) e diverso per vittima;
- **nessun artefatto su disco** → bassa rilevabilità statica; serve detection comportamentale/di rete.

## Comportamento atteso (famiglia InvisibleFerret / stealer JS)

Nelle infezioni note di questa campagna la seconda fase effettua tipicamente:

### Furto dati browser (Chromium: Chrome, Brave, Edge, Opera, Chrome Beta…)
- **password salvate** (`Login Data`);
- **cookie di sessione** → consente l'hijack di account già loggati, **bypassando l'MFA**;
- **autofill / dati carte**;
- **chiave di decifratura del DB** (`Local State`, AES key protetta da DPAPI/keychain).

### Furto wallet crypto
- estensioni browser: **MetaMask**, **Phantom**, e altre dei principali wallet;
- file/keystore di wallet locali.

### Furto credenziali e segreti
- keychain / portachiavi di sistema;
- file di configurazione, chiavi SSH, token cloud/CI.

### Backdoor / fasi successive
- alcune varianti scaricano ulteriori strumenti (es. keylogger Python, modulo di persistenza, RAT) e mantengono accesso remoto.

### Esfiltrazione
- invio dei dati raccolti verso l'infrastruttura dell'operatore (stesso attore del Livello 1).

## In sintesi

| Livello | Ruolo | Dati |
|---|---|---|
| **1** (in repo) | foothold + downloader | host info, `process.env` |
| **2** (via eval) | info-stealer | password/cookie browser, wallet, keychain, file sensibili |

Il Livello 1 prende piede e ruba i segreti d'ambiente; il Livello 2 svuota browser e wallet.

> ⚠️ Poiché la seconda fase è dinamica, il dettaglio esatto può variare tra le vittime e nel tempo. Il comportamento sopra riflette i campioni pubblicamente documentati della stessa campagna (vedi [07-references.md](./07-references.it.md)) e va trattato come **descrizione della capacità**, non come dump del payload specifico.
