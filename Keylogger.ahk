#include FcnLib.ahk
#NoTrayIcon

SetFormat, Integer, H
Loop, 0x7f
Hotkey, % "*~" . chr(A_Index), LogKey
Return
LogKey:
Key := RegExReplace(asc(SubStr(A_ThisHotkey,0)),"^0x")
;FileAppend, % (StrLen(Key) == 1 ? "0" : "") . Key, Log.log
date:=CurrentTime("hyphendate")
FileAppend, %A_ThisHotkey%`t%key%`n, gitExempt/logs/%date%.log
Return
