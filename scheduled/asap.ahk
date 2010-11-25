#include FunctionLibrary.ahk

;Run, https://www.noisetrade.com/?dc=qpemBM#
;DirectoryScan("C:\Downloads\*prison_show.zip", "C:\My Dropbox\dirScan-groves_album.txt")

;SleepMinutes(5)
;errord("shutting down soon")
;SleepMinutes(1)
;Run, shutdown.ahk

FileAppend, hello, C:\My Dropbox\report.txt
DirectoryScan("C:\", "C:\My Dropbox\scanned-hd.txt")


;Run, temporary2.ahk

SleepMinutes(1)
Run, ForceReloadAll.exe
