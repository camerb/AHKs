#include FcnLib.ahk

Run, C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Nemon2\Nemon2.lnk
ForceWinFocus("Login : NEMON")
Sleep, 100
Send, {enter}
Sleep, 100
Click(94, 1052)
ForceWinFocus("Connection", "Exact")
Click(40, 93, "double")
