<!-- 🇮🇹 Italiano · 🇬🇧 English: post-2-technical.md -->
<!-- Post LinkedIn #2 — tecnico / addetti alla sicurezza -->

🔬 Anatomia di un campione Lazarus "Contagious Interview" — e le detection per individuarlo.

Ho fatto reverse-engineering di un repo trojanizzato "Web3 poker" consegnato come finto assignment di colloquio. Due livelli, un solo obiettivo: svuotare la macchina dello sviluppatore. Analisi 👇

🧩 LIVELLO 1 — il loader (statico, nel repo)
Nascosto in fondo a `routes/api/auth.js`, riempito di centinaia di spazi e offuscato (stile obfuscator.io). Parte al `require()` — cioè all'avvio del server, senza chiamare alcun endpoint. Fa:
• profila l'host (hostname, OS, MAC)
• esfiltra l'INTERO `process.env` (JWT secret, Mongo URI, API key) in chiaro su HTTP
• beacon ogni 5s al C2 ed esegue `eval()` sulla risposta
• C2 (defanged): hxxp://216[.]250[.]251[.]187:1224/api/checkStatus
• il campaign id nel parametro `tid` decodifica in: "now it time to get everything"

🧩 LIVELLO 2 — lo stealer (dinamico, via eval)
Mai presente nel repo — consegnato dal C2 ed eseguito in memoria (famiglia InvisibleFerret). Bersaglia Login Data dei browser, cookie di sessione (bypass MFA), autofill e wallet crypto (MetaMask/Phantom), oltre a keychain e chiavi SSH/cloud.

🎯 Perché evade:
eval in memoria (nessuno stage-2 su disco) + base64 + indentazione fuori schermo + progetto-esca dall'aspetto innocuo.

🛡️ Detection (tutte open-source nel dossier):
• YARA — individua il loader offuscato tramite il base64 del C2 + la combo comportamentale `processInfo`+`eval(`+`_0x`
• Sigma — un processo `node` che fa beacon verso 216[.]250[.]251[.]187 / porta 1224
• Suricata — HTTP verso `/api/checkStatus` con `processInfo=`
• IOC machine-readable (CSV + STIX 2.1) e una blocklist di rete
• CI che compila le regole YARA e verifica che continuino a matchare il sample

One-liner di hunting per i tuoi repo / dipendenze npm:
`grep -rIlE "processInfo|checkStatus|216\.250\.251\.187" .`

Analisi completa bilingue (EN/IT), codice deoffuscato, IOC e regole — dossier open-source:
🔗 https://github.com/francesco-oghabi/lazarus-contagious-interview/

Quali altri angoli di detection aggiungereste? 👇

#ThreatIntel #DFIR #DetectionEngineering #YARA #Sigma #Lazarus #MalwareAnalysis #InfoSec #IOC
