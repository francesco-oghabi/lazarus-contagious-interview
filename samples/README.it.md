<!-- 🇮🇹 Italiano · 🇬🇧 English: README.md -->

# samples/ — Evidence (isolated)

> ⚠️ **Contiene codice malevolo a scopo di analisi.** I file qui sono **neutralizzati per isolamento**: rinominati in `.txt` così da **non essere eseguibili né importabili** da Node/bundler. Non rinominare in `.js` e non eseguire. Solo VM isolata.

## Contenuto

| File | Descrizione |
|---|---|
| [`stage1/auth_js_payload.js.txt`](./stage1/auth_js_payload.js.txt) | Il loader del Livello 1 estratto dalla riga 17 di `routes/api/auth.js`. Offuscato, intatto a fini di firma/analisi. Inerte come `.txt`. |
| [`lure/README.original.md`](./lure/README.original.md) | Il README-esca originale del finto progetto "ChainFlip Labs", conservato come evidenza. |

## Note

- Il **Livello 2** (stealer del browser/wallet) **non è incluso**: viene consegnato dal C2 a runtime via `eval` e non è presente nel repo originale. Vedi [`../docs/03-stage2-stealer.md`](../docs/03-stage2-stealer.it.md).
- Le stringhe base64 nel payload (URL C2, `tid`) sono mantenute integre perché costituiscono gli **indicatori/firme**; sono dati inerti. Decodifiche in [`../docs/04-iocs.md`](../docs/04-iocs.it.md).
