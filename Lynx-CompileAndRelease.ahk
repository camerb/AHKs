#include FcnLib.ahk
#include C:/Dropbox/AHKs/thirdParty/cmdret.ahk

;Compile that friggin ahk
cmd="C:\Program Files (x86)\AutoHotkey\Compiler\Ahk2Exe.exe" /in "Lynx-Install.ahk"
CmdRet_RunReturn(cmd)

;Create Release Dir
;Copy files to release dir
;Copy files to flash drive

