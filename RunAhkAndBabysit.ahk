#include FcnLib.ahk

;NOTE that how we're babysitting ahks has changed.
;now we are marking an ini when we start and when we finish to keep track of ahks that do not finish

ahkFilename=%1%
params=%2%
options=%3%
command=AutoHotkey.exe %ahkFilename% %params%
ini=gitExempt/%A_ComputerName%.ini
currentTime:=currentTime("hyphenated")

IniWrite(ini, A_ScriptName, ahkFilename, currentTime)

;if InStr(options, "wait")
   RunWait %command%
;else
   ;Run %command%

IniDelete(ini, A_ScriptName, ahkFilename)
