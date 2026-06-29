# Security & Safe-handling

## Scopo

Questo repository è un **dossier di threat intelligence a fini difensivi ed educativi**. Documenta un campione reale della campagna **Lazarus / Contagious Interview** per consentire detection, attribuzione e bonifica.

## ⚠️ Il codice è ostile

- Il file `routes/api/auth.js` contiene un **loader malevolo** che parte al solo avvio del server.
- **Non eseguire** `npm install`, `npm run dev`, `node server.js` o qualsiasi build su una macchina reale.
- Analizzare esclusivamente in **VM isolata**, snapshot revertibile, **senza credenziali**, rete monitorata o staccata.
- I campioni in [`samples/`](./samples/) sono neutralizzati per isolamento (rinominati `.txt`): non rinominarli in `.js`, non eseguirli, non importarli.

## Uso consentito

- Detection engineering (YARA/Sigma/Suricata in [`rules/`](./rules/)).
- Threat hunting con gli IOC in [`iocs/`](./iocs/).
- Formazione e awareness su attacchi "finto colloquio".

## Uso non consentito

- Riutilizzo del codice malevolo per attaccare sistemi.
- Esecuzione su sistemi di produzione o macchine con dati/credenziali reali.

## Segnalazioni

Se trovi questo campione attivo o un'esca correlata, segnala al tuo CERT/CSIRT nazionale e ruota le credenziali esposte (vedi [docs/06-remediation.md](./docs/06-remediation.md)).
