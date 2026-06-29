<!-- 🇬🇧 English (default) · 🇮🇹 Italiano: README.it.md -->

# samples/ — Evidence (isolated)

> ⚠️ **Contains malicious code for analysis purposes.** The files here are **neutralized through isolation**: renamed to `.txt` so they are **neither executable nor importable** by Node/bundler. Do not rename to `.js` and do not run. Isolated VM only.

## Contents

| File | Description |
|---|---|
| [`stage1/auth_js_payload.js.txt`](./stage1/auth_js_payload.js.txt) | The Stage 1 loader extracted from line 17 of `routes/api/auth.js`. Obfuscated, kept intact for signature/analysis purposes. Inert as `.txt`. |
| [`lure/README.original.md`](./lure/README.original.md) | The original lure README of the fake "ChainFlip Labs" project, preserved as evidence. |

## Notes

- **Stage 2** (the browser/wallet stealer) **is not included**: it is delivered by the C2 at runtime via `eval` and is not present in the original repo. See [`../docs/03-stage2-stealer.md`](../docs/03-stage2-stealer.md).
- The base64 strings in the payload (C2 URL, `tid`) are kept intact because they constitute the **indicators/signatures**; they are inert data. Decodings in [`../docs/04-iocs.md`](../docs/04-iocs.md).
