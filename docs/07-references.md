<!-- 🇬🇧 English (default) · 🇮🇹 Italiano: 07-references.it.md -->

# 07 — References & Attribution

## Attribution

- **Actor**: Lazarus Group (DPRK), cluster *Famous Chollima* / *DeceptiveDevelopment*.
- **Campaign**: *Contagious Interview* (aka *DEV#POPPER*).
- **Commonly associated malware chain**: JS loader (*BeaverTail* family) → second-stage stealer/backdoor (*InvisibleFerret*).

> Attribution is based on TTPs and infrastructure consistent with the publicly documented campaign: fake interview + trojanized project, obfuscated JS loader that exfiltrates `process.env` and executes a second stage via `eval`, C2 port `1224`, targeting browsers and crypto wallets.

## Reference reading (look for up-to-date public reports)

- Palo Alto Unit 42 — *Contagious Interview* / BeaverTail & InvisibleFerret.
- Securonix — *DEV#POPPER*.
- ESET — *DeceptiveDevelopment*.
- CISA/FBI — advisories on Lazarus / DPRK IT-worker & crypto theft.
- Community analyses of trojanized npm packages and fake interview assignments.

> Add the specific links here when publishing the dossier (this file is the single point for citations and sources). Always verify IOCs against up-to-date sources: C2 infrastructure can change.

## IOCs for this sample

See [04-iocs.md](./04-iocs.md) and [`../iocs/`](../iocs/).

| Indicator | Value |
|---|---|
| C2 | `216.250.251.187:1224` `/api/checkStatus` |
| Campaign id | `now it time to get everything` |
| File | `routes/api/auth.js` |
