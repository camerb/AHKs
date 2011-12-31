#include FcnLib.ahk

;compile the hatchling irc client

ahkFile:="C:\Dropbox\Projects\Hatchling-IRC\hatchling-irc.ahk"
ahk2exe:=ProgramFilesDir("AutoHotkey\Compiler\Ahk2Exe.exe")
cmd="%ahk2exe%" /in "%ahkFile%" /nodecompile
CmdRet_RunReturn(cmd)
