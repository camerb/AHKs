#include FcnLib.ahk

;if NOT ProcessExist("BareTail.exe")
   ;RunProgram("BareTail.exe")

ProcessClose("BareTail.exe")
Sleep, 200
;WinClose, BareTail
RunProgram("BareTail.exe")

if (A_ComputerName = "PHOSPHORUS")
   files .= ",C:\code\epms_logs\plack.log,C:\code\report.txt,C:\code\epms\script\mail\mqmail.log,C:\Program Files (x86)\Apache Software Foundation\Apache2.2\logs\access.log,C:\Program Files (x86)\Apache Software Foundation\Apache2.2\logs\error.log"

files.=",C:\Dropbox\Public\logs\trace.txt,C:\Dropbox\Public\logs\BAUSTIAN-09PC.txt,C:\Dropbox\Public\logs\PHOSPHORUS.txt,C:\Dropbox\Public\logs\PHOSPHORUSVM.txt"
files .= "," . GetPath("FireflyStats.ini")

;Close all windows
ForceWinFocus("BareTail")
Send, !fa

Loop, parse, files, CSV
{
   ForceWinFocus("BareTail")
   Send, !fo
   ;ClickButton("Ope&n") ;FIXME why doesn't this work?

   WinWaitActive, Select file(s) to view
   Sleep, 100
   Send, %A_LoopField%
   Sleep, 90
   ClickButton("&Open")

}
