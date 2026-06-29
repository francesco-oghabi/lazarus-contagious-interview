# 06 — Bonifica & Prevenzione

## Se hai eseguito il progetto (anche una sola volta)

Tratta la macchina come **compromessa**. `eval` da remoto significa che non hai garanzie su cosa sia stato eseguito.

1. **Isola** subito la macchina dalla rete.
2. **Blocca** in firewall/EDR l'IP `216.250.251.187` e la porta `1224` (vedi [`../iocs/network.txt`](../iocs/network.txt)).
3. **Ruota tutte le credenziali** presenti nell'ambiente al momento dell'esecuzione:
   - password DB / `MONGO_URI`, `JWT_SECRET`;
   - token API, chiavi cloud (AWS/GCP/Azure), token CI/CD;
   - chiavi SSH, token Git/PAT.
4. **Browser**: cambia le password dei tuoi account e **revoca tutte le sessioni** (logout globale) — i cookie rubati bypassano l'MFA finché le sessioni restano valide.
5. **Wallet crypto**: considera le seed/chiavi compromesse. Genera **nuovi wallet su una macchina pulita** e sposta i fondi. Non riusare le stesse seed.
6. **Persistenza**: controlla cron job, servizi, voci di avvio, processi `node`/`python` anomali, pacchetti npm/pip installati di recente.
7. **Reinstalla il sistema** da zero quando possibile.

## Prevenzione

- **Non eseguire** *coding assignment* / take-home test di colloqui non verificati su macchine personali o di lavoro. Usa una **VM usa-e-getta**, senza credenziali, con rete monitorata.
- Diffida di repo che insistono per **avviare un server/app** "per vedere se funziona".
- In code review attiva il **word-wrap** e cerca: `eval`, `Function(`, blob base64, `_0x…`, `child_process`, `require('os')`, beacon HTTP — specie **in fondo** ai file.
- Esegui scansione con le regole in [`../rules/`](../rules/) su repo e dipendenze prima dell'esecuzione.
- Tieni i wallet crypto su dispositivi/hardware separati dalla macchina di sviluppo.

## Neutralizzazione del campione (se devi conservare il repo)

L'unico componente da rimuovere nel sorgente è il blob alla **riga 17** di `routes/api/auth.js` (tutto ciò che segue `login,` ... `);` fino a prima di `module.exports`). La seconda fase risiede sul C2 e non è presente nei file.
