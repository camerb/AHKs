#include FcnLib.ahk

filename=C:\DataExchange\urltempfile.txt
UrlDownloadToFile, http://on-air.897powerfm.com/, %filename%
FileRead, playlist, %filename%
;debug(playlist)
playlist:=RegExReplace(playlist, "(`r|`n)", " ")
RegExMatch(playlist, "Now Playing.*What`'s Played Recently", outputVar)

outputVar:=RegExReplace(outputVar, "(Now Playing|What`'s Played Recently)", "")
outputVar:=RegExReplace(outputVar, "<.*?>", "")
outputVar:=RegExReplace(outputVar, " +", " ")

debug(outputVar)

