# 07 — Riferimenti & Attribuzione

## Attribuzione

- **Attore**: Lazarus Group (DPRK), cluster *Famous Chollima* / *DeceptiveDevelopment*.
- **Campagna**: *Contagious Interview* (alias *DEV#POPPER*).
- **Catena malware comunemente associata**: loader JS (famiglia *BeaverTail*) → stealer/backdoor di seconda fase (*InvisibleFerret*).

> L'attribuzione si basa su TTP e infrastruttura coerenti con la campagna pubblicamente documentata: finto colloquio + progetto trojanizzato, loader JS offuscato che esfiltra `process.env` ed esegue una seconda fase via `eval`, porta C2 `1224`, target su browser e wallet crypto.

## Letture di riferimento (cerca i report pubblici aggiornati)

- Palo Alto Unit 42 — *Contagious Interview* / BeaverTail & InvisibleFerret.
- Securonix — *DEV#POPPER*.
- ESET — *DeceptiveDevelopment*.
- CISA/FBI — advisory su Lazarus / DPRK IT-worker & crypto theft.
- Analisi community su npm trojanizzati e finti assignment di colloquio.

> Inserire qui i link specifici quando si pubblica il dossier (questo file è il punto unico per citazioni e fonti). Verificare sempre gli IOC contro fonti aggiornate: l'infrastruttura C2 può cambiare.

## IOC di questo campione

Vedi [04-iocs.md](./04-iocs.md) e [`../iocs/`](../iocs/).

| Indicatore | Valore |
|---|---|
| C2 | `216.250.251.187:1224` `/api/checkStatus` |
| Campaign id | `now it time to get everything` |
| File | `routes/api/auth.js` |
