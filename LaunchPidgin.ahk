#include FcnLib.ahk

Run, "C:\Program Files (x86)\Pidgin\pidgin.exe"

ForceWinFocus("Buddy List")
Send, ^m

ForceWinFocus("Pidgin")
Send, frigg{ENTER}

ForceWinFocus("frigg")
Send, ^!a

ForceWinFocus("Buddy List")
WinClose
