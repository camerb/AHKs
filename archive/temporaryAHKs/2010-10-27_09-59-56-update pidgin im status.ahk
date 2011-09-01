#include FcnLib.ahk

Run, "C:\Program Files (x86)\Pidgin\pidgin.exe"

ForceWinFocus("Buddy List ahk_class gdkWindowToplevel")

Click(30, 1030, "Click")

Send, ^a
Sleep, 100

Send, {DEL}
Sleep, 100

FileRead, statusText, C:\Dropbox\Android\sd\imStatus.txt
statusText:=RegExReplace(statusText, "(`r|`n)", " ")
statusText:=RegExReplace(statusText, " +", " ")
SendViaClipboard(statusText)

Sleep, 2000

WinClose, Buddy List ahk_class gdkWindowToplevel
