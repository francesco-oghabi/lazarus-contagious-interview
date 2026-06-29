# 04 — Indicatori di compromissione (IOC)

> Indicatori *defanged* per la lettura. Versioni machine-readable "live" per import/blocklist in [`../iocs/`](../iocs/).

## Rete

| Tipo | Valore (defanged) | Note |
|---|---|---|
| C2 URL | `hxxp://216[.]250[.]251[.]187:1224/api/checkStatus` | Endpoint di beacon/consegna stage 2 |
| C2 IP | `216[.]250[.]251[.]187` | |
| Porta | `1224` | Porta C2 caratteristica della campagna *Contagious Interview* |
| URI path | `/api/checkStatus` | |
| Query params | `sysInfo`, `processInfo`, `tid`, `sysId` | Schema dei parametri del beacon |
| User-Agent | default di `fetch`/`undici` (Node) | Beacon da processo `node`, non da browser |
| Cadenza | beacon ogni **5000 ms** | `setInterval(..., 0x1388)` |

## Host / file

| Tipo | Valore |
|---|---|
| File infetto | `routes/api/auth.js` (payload top-level in fondo, riga 17) |
| Campaign id (`tid`) | `now it time to get everything` |
| `tid` base64 | `bm93IGl0IHRpbWUgdG8gZ2V0IGV2ZXJ5dGhpbmc=` |
| C2 URL base64 | `aHR0cDovLzIxNi4yNTAuMjUxLjE4NzoxMjI0L2FwaS9jaGVja1N0YXR1cw==` |
| Tecnica | offuscamento `obfuscator.io` + base64 + `eval()` su risposta C2 |
| Processo | `node` che apre connessioni in uscita verso `:1224` |

## Stringhe/pattern utili per detection

```
eval(                              ← su variabile da risposta HTTP
processInfo                        ← parametro di esfiltrazione process.env
checkStatus                        ← path C2
216.250.251.187                    ← IP C2
1224                               ← porta C2
aHR0cDovLzIxNi4yNTAuMjUxL          ← prefisso base64 dell'URL C2
bm93IGl0IHRpbWUgdG8gZ2V0           ← prefisso base64 del tid
_0x                                ← marker di offuscamento (basso valore da solo)
```

## Falsi positivi noti (file PULITI in questo repo)

| File | Perché sembra sospetto ma è pulito |
|---|---|
| `socket/packet.js` | Costanti esadecimali = id eventi di gioco |
| `client/src/components/decoration/WatermarkText.js` | Riga lunghissima = `path` SVG |
| `client/src/components/logo/LogoWithText.js` | Riga lunghissima = `path` SVG |
| `client/src/utils/interact.js`, `pages/ConnectWallet/` | Codice wallet legittimo (parte dell'esca, non malevolo) |

Regole pronte all'uso: [05-detection.md](./05-detection.md) e [`../rules/`](../rules/).
