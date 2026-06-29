<!-- 🇬🇧 English (default) · 🇮🇹 Italiano: 03-stage2-stealer.it.md -->

# 03 — Stage 2: the info-stealer (delivered via `eval`)

## Why it is not in the repo

The second stage is **not stored in the repository**: this is why you will not find it "in the clear" among the files. It is downloaded at runtime from the C2 in the `message` field of the JSON response and executed with `eval(message)` (see [02-stage1-loader.md](./02-stage1-loader.md)).

Consequences:
- **arbitrary code execution** controlled by the operator in real time;
- payload **updatable on every beacon** (every 5 s) and different per victim;
- **no on-disk artifact** → low static detectability; behavioral/network detection is required.

## Expected behavior (InvisibleFerret family / JS stealer)

In the known infections of this campaign, the second stage typically performs:

### Browser data theft (Chromium: Chrome, Brave, Edge, Opera, Chrome Beta…)
- **saved passwords** (`Login Data`);
- **session cookies** → enables hijacking of already-logged-in accounts, **bypassing MFA**;
- **autofill / card data**;
- **DB decryption key** (`Local State`, AES key protected by DPAPI/keychain).

### Crypto wallet theft
- browser extensions: **MetaMask**, **Phantom**, and others from the major wallets;
- local wallet files/keystores.

### Credential and secret theft
- system keychain / keyring;
- configuration files, SSH keys, cloud/CI tokens.

### Backdoor / later stages
- some variants download additional tooling (e.g. Python keylogger, persistence module, RAT) and maintain remote access.

### Exfiltration
- sending the collected data to the operator's infrastructure (same actor as Stage 1).

## In summary

| Stage | Role | Data |
|---|---|---|
| **1** (in repo) | foothold + downloader | host info, `process.env` |
| **2** (via eval) | info-stealer | browser passwords/cookies, wallets, keychain, sensitive files |

Stage 1 gains a foothold and steals environment secrets; Stage 2 drains browsers and wallets.

> ⚠️ Because the second stage is dynamic, the exact detail may vary between victims and over time. The behavior above reflects the publicly documented samples of the same campaign (see [07-references.md](./07-references.md)) and should be treated as a **capability description**, not as a dump of the specific payload.
