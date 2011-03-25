#include FcnLib.ahk

SetFormat, Integer, H
Loop, 0x7f
Hotkey, % "*~" . chr(A_Index), LogKey
Return
LogKey:
Key := RegExReplace(asc(SubStr(A_ThisHotkey,0)),"^0x")
;FileAppend, % (StrLen(Key) == 1 ? "0" : "") . Key, Log.log
FileAppend, %A_ThisHotkey%`t%key%`n, gitExempt/log.log
Return
