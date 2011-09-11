#include FcnLib.ahk

;trying to run an AHK using _Basic or _L as specified

;exePath="C:\Program Files\AutoHotkey_L\AutoHotkey_L.exe"
exePath="C:\Program Files\AutoHotkey\AutoHotkey.exe"
workingDir=C:\Dropbox\AHKs\
ahkPath=%workingDir%ircClient.ahk
cmd=%exePath% %ahkPath%
output := CmdRet_RunReturn(cmd, workingDir)

