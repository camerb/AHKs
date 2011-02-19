#include FcnLib.ahk


Winactivate, CM-73
WinWaitActive, CM-73

Send, 41{ENTER}
Sleep, 400

iindex:=iindex+1
;iindex now equals the total number of files
iiindex:=1

F4::
IfWinExist, File Information
{
WinActivate  ; Automatically uses the window found above.
Send, {SPACE}
}

Loop, %iindex%
{
;these variables are defined in the script above what I've displayed
  dfileno:=fileno%iiindex%
  dcltname:=cltname%iiindex%
  dbalance:=balance%iiindex%
  dforwrate:=forwrate%iiindex%
  dspecins:=specins%iiindex%
  dattyno:=attyno%iiindex%
  dlawl:=lawl%iiindex%
  dcollno:=collno%iiindex%
  dletter:=letter%iiindex%
  dattycomm:=attycomm%iiindex%
  dattysfee:=attysfee%iiindex%
  dattyemail:=attyemail%iiindex%

  Send, %dfileno%{ENTER}

  Gui, Add, Button, x106 y207 w110 h30 gGuiClose, OK
  Gui, Add, Text, x106 y17 w100 h30 , %dfileno%
  Gui, Add, Text, x36 y57 w270 h20 , %dcltname%
  Gui, Add, Text, x36 y87 w80 h20 , Forw Rate:
  Gui, Add, Text, x126 y87 w180 h20 , %dforwrate%
  Gui, Add, Text, x36 y117 w80 h20 , Special Ins:
  Gui, Add, Text, x126 y117 w180 h40 , %dspecins%
  ; Generated using SmartGUI Creator 4.0
  Gui, Show, x0 y0 h266 w344, File Information
  Winactivate, CM-73
  WinWaitActive, CM-73
  Return

  Winactivate, CM-73
  WinWaitActive, CM-73

  GuiClose:
    Gui, Cancel


  Winactivate, CM-73
  WinWaitActive, CM-73


  KeyWait, F4, D
  return
  continue
}

Msgbox, File Forwarding Completed.
return

Exitapp
