#include FcnLib.ahk

RunAhk("C:\Dropbox\AHKs\GetNetWorth.ahk")
;Run, MintGetAccountBalances.ahk
ExitApp

;Run, https://www.noisetrade.com/?dc=qpemBM#
;DirectoryScan("C:\Downloads\*prison_show.zip", "C:\Dropbox\dirScan-groves_album.txt")

;SleepMinutes(5)
;errord("shutting down soon")
;SleepMinutes(1)
;Run, shutdown.ahk

FileAppend, hello, C:\Dropbox\report.txt
DirectoryScan("C:\", "C:\Dropbox\scanned-hd.txt")


;Run, temporary2.ahk

SleepMinutes(1)
Run, ForceReloadAll.exe

#include FcnLib.ahk
SelfDestruct()