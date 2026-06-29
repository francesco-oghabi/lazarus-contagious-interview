<!-- 🇬🇧 English (default) · 🇮🇹 Italiano: post-1-awareness.it.md -->
<!-- LinkedIn post #1 — awareness / general audience -->

🪤 A developer gets a dream job offer. The final step: "just clone our repo and run it to complete the coding task."

That one command would have drained their crypto wallet and stolen every saved password in their browser.

This is **Contagious Interview** — a North-Korean (Lazarus) campaign that doesn't phish your inbox. It phishes your *career*.

Here's how the trap works 👇

1️⃣ A fake recruiter hands you a polished "Web3 project" to run as a take-home test. It looks completely normal — a poker/game app, hundreds of legit files.

2️⃣ Hidden at the bottom of a single source file, behind hundreds of blank spaces so it's invisible in code review, sits an obfuscated loader. It runs the instant you start the project — no clicking required.

3️⃣ Stage 1 steals your environment secrets (DB passwords, API keys, tokens) and phones home.

4️⃣ Stage 2 is pulled from the attacker's server and runs in memory: it empties your browser passwords, **session cookies** (which bypass MFA), and crypto wallets like MetaMask.

The scary part? The malicious code never touches an antivirus the way a normal file does — and the second stage is never even saved to disk.

🛡️ Three habits that defeat this entire class of attack:
• Never run an interview "assignment" on your real machine. Use a throwaway VM with no credentials.
• Turn on word-wrap in code review and look at the *end* of files.
• Keep crypto wallets off your dev machine.

I wrote up the full technical breakdown — deobfuscated code, indicators, and ready-to-use YARA/Sigma/Suricata detection rules — as an open, bilingual dossier. Link in the comments. 🔗

Stay paranoid about "too good" job offers. 🧠

#CyberSecurity #Lazarus #ThreatIntel #InfoSec #Web3Security #DevSecOps #SocialEngineering
