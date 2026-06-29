# 05 — Detection & Hunting

Regole complete in [`../rules/`](../rules/). Qui il razionale e le query di hunting.

## YARA — [`rules/lazarus_chainflip_loader.yar`](../rules/lazarus_chainflip_loader.yar)

Individua il loader statico in file JS sorgente. Combina più indicatori per ridurre i falsi positivi:
- base64 dell'URL C2 e/o del `tid`;
- pattern `processInfo` + `eval(`;
- IP/porta del C2 in chiaro;
- marker di offuscamento `_0x`.

Pensata per scansione di repo, pacchetti npm, allegati e snapshot di filesystem.

## Sigma — [`rules/lazarus_chainflip.sigma.yml`](../rules/lazarus_chainflip.sigma.yml)

Detection comportamentale su log di processo/EDR:
- processo `node` che stabilisce connessioni in uscita verso `216.250.251.187` o porta `1224`;
- da mappare sul proprio backend (Sysmon EventID 3, EDR network telemetry).

## Suricata/Snort — [`rules/lazarus_chainflip.suricata.rules`](../rules/lazarus_chainflip.suricata.rules)

Detection di rete:
- richiesta HTTP verso l'IP/porta del C2 con URI `/api/checkStatus`;
- presenza del parametro `processInfo=` nella query (esfiltrazione `process.env`).

## Query di hunting (adatta alla tua piattaforma)

**Connessioni di rete (EDR/Sysmon):**
```
process_name = "node"  AND  (dest_ip = "216.250.251.187"  OR  dest_port = 1224)
```

**Grep su sorgenti / repo / dipendenze:**
```bash
grep -rIlE "processInfo|checkStatus|216\.250\.251\.187|aHR0cDovLzIxNi4yNTAuMjUx|bm93IGl0IHRpbWUgdG8" .

# loader offuscato generico: eval su risposta + marker _0x in fondo a un file
grep -rIlE "eval\(" --include='*.js' . | xargs -r grep -lE "_0x[0-9a-f]{4,}"
```

**DNS/proxy:** allarme su qualsiasi richiesta verso `216.250.251.187:1224`.

## Triage rapido di un "assignment" sospetto

1. Cerca **righe anomalmente lunghe** o con molto whitespace iniziale in fondo ai file:
   ```bash
   for f in $(git ls-files '*.js'); do awk -v F="$f" 'length>1000{print F":"NR" ("length")"}' "$f"; done
   ```
   (Escludi i falsi positivi SVG/minified — vedi [04-iocs.md](./04-iocs.md).)
2. Cerca `eval(`, `Function(`, `child_process`, `require('os')` accostati a `fetch`/`http`.
3. Cerca blob base64 lunghi e decodificali prima di eseguire qualsiasi cosa.
4. Mai eseguire fuori da una VM isolata.
