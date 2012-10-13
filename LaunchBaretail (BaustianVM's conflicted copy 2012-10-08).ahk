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

files.=",C:\Dropbox\Public\logs\BAUSTIAN12.txt,C:\Dropbox\Public\logs\BAUSTIAN12.ini"
files.=",C:\Dropbox\Public\logs\PHOSPHORUS.txt,C:\Dropbox\Public\logs\PHOSPHORUS.ini"
files.=",C:\Dropbox\Public\logs\PHOSPHORUSVM.txt,C:\Dropbox\Public\logs\PHOSPHORUSVM.ini"
files.=",C:\Dropbox\Public\logs\T-800.txt,C:\Dropbox\Public\logs\T-800.ini"
files.=",C:\Dropbox\Public\logs\BAUSTIANVM.txt,C:\Dropbox\Public\logs\BAUSTIANVM.ini"

;inif files from firefly bot?
files.=",C:\Dropbox\Public\logs\fireflyTimers.txt"
files.=",C:\Dropbox\fastData\fireflyBotCommunication\fireflyBot.ini"
files.=",C:\Dropbox\fastData\fireflyCheckins\botCheckins.ini"

;always put the trace at the end
files.=",C:\Dropbox\Public\logs\trace.txt"

;Close all windows
ForceWinFocus("About BareTail")
WinWaitClose
;Sleep, 100
ForceWinFocus("BareTail")
WinRestore
ForceWinFocus("BareTail")
Send, !fa

Loop, parse, files, CSV
{
   if NOT A_LoopField
      continue

   ;Sleep, 100
   ;debug("opening file", A_LoopField)
   ;Sleep, 100
   ;Sleep, 100
   ForceWinFocus("BareTail")
   ;Sleep, 100
   ;Send, !fo
   ;ClickButton("Ope&n") ;FIXME why doesn't this work?
   Send, !n
   ;Sleep, 100

   ;if Active Win is About BareTail
      ;then winactivate select files window

   WinWaitActive, Select file(s) to view
   ;Sleep, 100
   Send, !n
   ;Sleep, 100
   ;WinWaitActive, Select.+file
   ;ForceWinFocus("Select.+file", "RegEx")
   ;ForceWinFocus("Select file(s) to view")
   ;Sleep, 100
   SendViaClip(A_LoopField)
   ;Sleep, 100
   ;Sleep, 90
   ClickButton("&Open")
}

;open up the current preferences file
Send, !pl{enter}
WinWaitActive, Select a file
SendViaClip("C:\Dropbox\Programs\BareTail\baretail-preferences.udm")
ClickButton("&Open")

