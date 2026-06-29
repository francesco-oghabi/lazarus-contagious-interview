<!-- 🇬🇧 English (default) · 🇮🇹 Italiano: 06-remediation.it.md -->

# 06 — Remediation & Prevention

## If you ran the project (even just once)

Treat the machine as **compromised**. Remote `eval` means you have no guarantees about what was executed.

1. **Isolate** the machine from the network immediately.
2. **Block** the IP `216.250.251.187` and port `1224` at the firewall/EDR (see [`../iocs/network.txt`](../iocs/network.txt)).
3. **Rotate all credentials** present in the environment at the time of execution:
   - DB passwords / `MONGO_URI`, `JWT_SECRET`;
   - API tokens, cloud keys (AWS/GCP/Azure), CI/CD tokens;
   - SSH keys, Git tokens/PAT.
4. **Browser**: change the passwords of your accounts and **revoke all sessions** (global logout) — stolen cookies bypass MFA as long as the sessions remain valid.
5. **Crypto wallets**: consider the seeds/keys compromised. Generate **new wallets on a clean machine** and move the funds. Do not reuse the same seeds.
6. **Persistence**: check cron jobs, services, startup entries, anomalous `node`/`python` processes, recently installed npm/pip packages.
7. **Reinstall the system** from scratch whenever possible.

## Prevention

- **Do not run** unverified interview *coding assignments* / take-home tests on personal or work machines. Use a **disposable VM**, with no credentials, on a monitored network.
- Be wary of repos that insist on **starting a server/app** "to see if it works."
- During code review, enable **word-wrap** and look for: `eval`, `Function(`, base64 blobs, `_0x…`, `child_process`, `require('os')`, HTTP beacons — especially **at the bottom** of files.
- Run a scan with the rules in [`../rules/`](../rules/) on repos and dependencies before execution.
- Keep crypto wallets on devices/hardware separate from the development machine.

## Neutralizing the sample (if you need to keep the repo)

The only component to remove in the source is the blob at **line 17** of `routes/api/auth.js` (everything that follows `login,` ... `);` up to just before `module.exports`). The second stage resides on the C2 and is not present in the files.
