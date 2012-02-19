#include FcnLib.ahk
#include FcnLib-Clipboard.ahk

;if NOT ProcessExist("BareTail.exe")
   ;RunProgram("BareTail.exe")

ProcessClose("BareTail.exe")
Sleep, 200
;WinClose, BareTail
RunProgram("BareTail.exe")

;if (A_ComputerName = "PHOSPHORUS")
   ;files .= ",C:\code\epms_logs\plack.log,C:\code\report.txt,C:\code\epms\script\mail\mqmail.log,C:\Program Files (x86)\Apache Software Foundation\Apache2.2\logs\access.log,C:\Program Files (x86)\Apache Software Foundation\Apache2.2\logs\error.log"

files.=",C:\Dropbox\Public\logs\BAUSTIAN-09PC.txt,C:\Dropbox\Public\logs\BAUSTIAN-09PC.ini"
files.=",C:\Dropbox\Public\logs\PHOSPHORUS.txt,C:\Dropbox\Public\logs\PHOSPHORUS.ini"
files.=",C:\Dropbox\Public\logs\PHOSPHORUSVM.txt,C:\Dropbox\Public\logs\PHOSPHORUSVM.ini"
files.=",C:\Dropbox\Public\logs\T-800.txt,C:\Dropbox\Public\logs\T-800.ini"
files.=",C:\Dropbox\Public\logs\BAUSTIANVM.txt,C:\Dropbox\Public\logs\BAUSTIANVM.ini"

files.=",C:\Dropbox\AHKs\gitExempt\firefly\botCommunication\inif\BAUSTIAN-09PC.ini,C:\Dropbox\AHKs\gitExempt\firefly\botCommunication\inif\BAUSTIANVM.ini"

;always put the trace at the end
files.=",C:\Dropbox\Public\logs\trace.txt"

;Close all windows
ForceWinFocus("BareTail")
Send, !fa
;Sleep, 2000

Loop, parse, files, CSV
{
   ForceWinFocus("BareTail")
   ;Send, !fo
   ;ClickButton("Ope&n") ;FIXME why doesn't this work?
   Send, !n

   ;if Active Win is About BareTail
      ;then winactivate select files window

   WinWaitActive, Select file(s) to view
   ;ForceWinFocus("Select file(s) to view")
   ;Sleep, 100
   SendViaClip(A_LoopField)
   ;Sleep, 90
   ClickButton("&Open")

}

