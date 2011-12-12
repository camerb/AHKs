#include FcnLib.ahk

text=
(
#include FcnLib.ahk
time:=CurrentTime()
AddToTrace(time)
;FileDelete(A_ScriptDir . "\" . A_ScriptName)
)

FileCreate(text, "C:\Dropbox\AHKs\scheduled\BAUSTIAN-09PC\asap.ahk")
FileCreate(text, "C:\Dropbox\AHKs\scheduled\BAUSTIAN-09PC\asap.txt")

;ahk=C:\Dropbox\AHKs\scheduled\BAUSTIAN-09PC\asap.ahk
;Run, %ahk%
