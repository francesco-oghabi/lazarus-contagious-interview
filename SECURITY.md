<!-- 🇬🇧 English (default) · 🇮🇹 Italiano: SECURITY.it.md -->

# Security & Safe-handling

## Purpose

This repository is a **threat intelligence dossier for defensive and educational purposes**. It documents a real sample of the **Lazarus / Contagious Interview** campaign to enable detection, attribution, and remediation.

## ⚠️ The code is hostile

- The `routes/api/auth.js` file contains a **malicious loader** that runs on server startup alone.
- **Do not run** `npm install`, `npm run dev`, `node server.js`, or any build on a real machine.
- Analyze exclusively in an **isolated VM**, with revertible snapshots, **without credentials**, and with the network monitored or disconnected.
- The samples in [`samples/`](./samples/) are neutralized for containment (renamed to `.txt`): do not rename them to `.js`, do not run them, do not import them.

## Permitted use

- Detection engineering (YARA/Sigma/Suricata in [`rules/`](./rules/)).
- Threat hunting with the IOCs in [`iocs/`](./iocs/).
- Training and awareness on "fake interview" attacks.

## Prohibited use

- Reuse of the malicious code to attack systems.
- Execution on production systems or machines with real data/credentials.

## Reporting

If you find this sample active or a related lure, report it to your national CERT/CSIRT and rotate the exposed credentials (see [docs/06-remediation.md](./docs/06-remediation.md)).
