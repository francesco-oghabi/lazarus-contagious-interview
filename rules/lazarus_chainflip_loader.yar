rule Lazarus_ContagiousInterview_ChainFlip_Loader
{
    meta:
        description = "Lazarus Contagious Interview - obfuscated JS loader (ChainFlip Labs lure). Exfiltrates process.env and eval()s C2-delivered stage 2."
        author = "threat-intel dossier"
        reference = "docs/02-stage1-loader.md"
        malware_family = "BeaverTail-style loader / InvisibleFerret"
        tlp = "CLEAR"
        date = "2026-06-29"

    strings:
        // base64 of the C2 url and campaign id
        $b64_url  = "aHR0cDovLzIxNi4yNTAuMjUxL"          // http://216.250.251.
        $b64_tid  = "bm93IGl0IHRpbWUgdG8gZ2V0"           // now it time to get...
        // C2 in clear
        $ip       = "216.250.251.187"
        $path     = "/api/checkStatus"
        // behavioral combo
        $exfil    = "processInfo"
        $eval     = "eval("
        $obf      = "_0x"
        $os_req   = "require('os')"

    condition:
        // any strong network indicator, OR the behavioral loader pattern
        any of ($b64_url, $b64_tid, $ip, $path)
        or ( $exfil and $eval and $obf and $os_req )
}
