#include FcnLib.ahk

ProcessClose("Ssms.exe")

RunProgram("C:\Program Files (x86)\Microsoft SQL Server\100\Tools\Binn\VSShell\Common7\IDE\Ssms.exe")
ForceWinFocus("Connect to Server")
ss()
ss()
Send, !s
ss()
Send, 10.6.0.9
ss()
Send, !l
ss()
Send, sa
ss()
Send, !p
ss()
joe:=SexPanther("work-lc")
SendRaw, % joe
;Send, {UP 5}{DOWN}{ENTER}
Send, {ENTER}
ss()

ForceWinFocus("Microsoft SQL Server Management Studio")
Send, ^!3

ss()
{
sleep, 100
}
