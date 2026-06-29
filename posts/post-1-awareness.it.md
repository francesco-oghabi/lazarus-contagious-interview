<!-- 🇮🇹 Italiano · 🇬🇧 English: post-1-awareness.md -->
<!-- Post LinkedIn #1 — awareness / pubblico generalista -->

🪤 Uno sviluppatore riceve l'offerta di lavoro dei sogni. Ultimo step: "clona il nostro repo ed eseguilo per completare il task di coding."

Quel singolo comando gli avrebbe svuotato il wallet crypto e rubato tutte le password salvate nel browser.

Questa è **Contagious Interview** — una campagna nordcoreana (Lazarus) che non colpisce la tua casella di posta. Colpisce la tua *carriera*.

Ecco come funziona la trappola 👇

1️⃣ Un finto recruiter ti consegna un curato "progetto Web3" da eseguire come test a casa. Sembra del tutto normale — un'app di gioco/poker, centinaia di file legittimi.

2️⃣ In fondo a un singolo file sorgente, nascosto dietro centinaia di spazi vuoti per essere invisibile in code review, c'è un loader offuscato. Parte nell'istante in cui avvii il progetto — senza bisogno di cliccare nulla.

3️⃣ Il Livello 1 ruba i segreti del tuo ambiente (password DB, API key, token) e "telefona a casa".

4️⃣ Il Livello 2 viene scaricato dal server dell'attaccante ed eseguito in memoria: svuota le password del browser, i **cookie di sessione** (che bypassano l'MFA) e i wallet crypto come MetaMask.

La parte inquietante? Il codice malevolo non si comporta come un file normale di fronte all'antivirus — e la seconda fase non viene nemmeno mai scritta su disco.

🛡️ Tre abitudini che sconfiggono l'intera categoria di questo attacco:
• Non eseguire mai un "assignment" di colloquio sulla tua macchina reale. Usa una VM usa-e-getta, senza credenziali.
• Attiva il word-wrap in code review e guarda la *fine* dei file.
• Tieni i wallet crypto fuori dalla macchina di sviluppo.

Ho scritto l'analisi tecnica completa — codice deoffuscato, indicatori e regole di detection YARA/Sigma/Suricata pronte all'uso — come dossier aperto e bilingue. Link nei commenti. 🔗

Resta diffidente verso le offerte di lavoro "troppo belle". 🧠

#CyberSecurity #Lazarus #ThreatIntel #InfoSec #Web3Security #DevSecOps #SocialEngineering
