#include FcnLib.ahk

;{{{Globals and making the gui
cityChoices=Tampa|Ft. Lauderdale|Orlando|Jacksonville
clientChoices=Albertelli Law|FDLG|Florida Foreclosure Attorneys, PLLC|Gladstone Law Group, P.A.|Marinosci Law Group, PC - Florida|Pendergast & Morgan, P.A.|Shapiro & Fishman, LLP|Law Offices of Douglas C. Zahm, P.A.
city=Tampa
client=Shapiro & Fishman, LLP

firefox=Status Pro Initial Catalog.*Firefox
excel=In House Process Server Scorecard.*OpenOffice.org Calc

;this is for the retarded comboboxes...
slowSendPauseTime=130
;breaks at 100,110
;reliable at 120,150

Gui, +LastFound -Caption +ToolWindow +AlwaysOnTop
;Gui, Add, Edit, r10 w500 vOut ReadOnly
;Gui, Add, Edit, w500 vInputText
Gui, Add, Button, , Reload Queue
Gui, Add, Button, , Change Queue
Gui, Add, Button, , Add Scorecard Entry
Gui, Show, , Firefly Shortcuts
;Sleep, 200
WinMove, Firefly Shortcuts, , 1770, 550

return
;}}}


;{{{ButtonAddScorecardEntry:
ButtonAddScorecardEntry:
ArrangeWindows()
ForceWinFocus(firefox)
ss()
Click(1100, 165, "left")
Click(1100, 165, "left")
ss()
Send, {CTRLDOWN}c{CTRLUP}
ss()
Click(620, 237, "left")
Click(620, 237, "left")
ss()
referenceNumber:=Clipboard
Send, {CTRLDOWN}a{CTRLUP}{CTRLDOWN}c{CTRLUP}
Click(620, 237, "left")
ss()
Click(612, 254, "left")
ss()
Click(1254, 167, "left")
ss()
Click(922, 374, "left")
Click(922, 374, "left")
ss()
server:=Clipboard
Send, {CTRLDOWN}a{CTRLUP}{CTRLDOWN}c{CTRLUP}
Click(911, 371, "left")
ss()
Click(867, 397, "left")
ss()
Click(1264, 399, "left")
ss()
status:=Clipboard
FormatTime, today, , M/d/yyyy
if InStr(status, "Cancelled")
   msgbox, ERROR: It looks like this one was cancelled: status

;;;;;;;;;;;;;;;;
ForceWinFocus(excel)

;DELETEME remove this before moving live
ss()
Send, {UP 50}{LEFT 5}{UP 50}{LEFT 5}
ss()
Send, {RIGHT}
ss()
Send, {DOWN}
ss()

;Loop to find the first empty column
Loop
{
   Send, {RIGHT}
   Send, ^c
   Sleep, 500
   if NOT RegExMatch(Clipboard, "[A-Za-z]")
      break
}

ss()
Send, %server%{ENTER}
ss()
Send, ICMbaustian{ENTER}
ss()
Send, %today%{ENTER}
ss()
Send, %referenceNumber%{ENTER}
ss()
Send, ^c{ENTER}
ss()
Send, {ENTER}
ss()
Send, {ENTER}
ss()
Send, {ENTER}{ENTER}{ENTER}{ENTER}
ss()
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
ss()
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
ss()
Send, {ENTER}
ss()
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
ss()
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
ss()
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
ss()
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
ss()
Send, {ENTER}
ss()
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
ss()
Send, {ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}
ss()
Send, {SHIFTDOWN}n{SHIFTUP}{DEL}{ENTER}
ss()
if NOT InStr(Clipboard, "Service County Not Required")
   msgbox, ERROR: It looks like you need a Service County - it says: %Clipboard%
ss()
return
;}}}

;{{{ButtonChangeQueue:
ButtonChangeQueue:
ArrangeWindows()
Gui, 2: Add, ComboBox, vCityNew, %cityChoices%
Gui, 2: Add, ComboBox, vClientNew, %clientChoices%
Gui, 2: Add, Button, Default, Change To This Queue
Gui, 2: Show
return
2ButtonChangeToThisQueue:
Gui, 2: Submit
city:=cityNew
client:=clientNew
Gui, 2: Destroy
GoSub, ButtonReloadQueue
return
;}}}

;{{{ButtonReloadQueue:
ButtonReloadQueue:
ArrangeWindows()
URLbar := GetURLbar("firefox")
if NOT InStr( URLbar, "status-pro.biz/fc/Portal.aspx" )
   return

ForceWinFocusIfExist(firefox)

;Send, {PGUP 20}

BlockInput, MouseMove
ClickIfImageSearch("images/firefly/closeTab.bmp", "control")

ss()
MouseMove, 33, 115
ss()
Click(33, 132, "left control")
Sleep, 200
MouseMove, 33, 198
Click(259, 182, "left control")
Sleep, 200
SendSlow(city, slowSendPauseTime)
ss()
Click(284, 206, "left control")
ss()
Click(278, 230, "left control")
Sleep, 200
SendSlow(client, slowSendPauseTime)
ss()
Click(280, 250, "left control")
ss()
;Click(241, 255, "left control")
ss()
ss()
Click(241, 255, "left control")
ss()
BlockInput, MouseMoveOff
return
;}}}

ss()
{
Sleep, 500
}

ArrangeWindows()
{
   global
   WinMove, %firefox%, , 0, 0, 1766, 1020
   WinMove, %excel%  , , 0, 0, 1766, 1020
;left: 0     top: 0     width: 1766     height: 1020
}
