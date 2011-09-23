#include FcnLib.ahk

;TODO move X to top-right
;TODO make scorecard faster
; Delete filler text from Magic Faux MS_Word
; Auto-expand all pluses in the left-hand side
;WRITEME firefly: make paste paste without formatting in the MS-Word lookalike program


;{{{Globals and making the gui (one-time tasks)
cityChoices=Tampa|Ft. Lauderdale|Orlando|Jacksonville
clientChoices=Albertelli Law|FDLG|Florida Foreclosure Attorneys, PLLC|Gladstone Law Group, P.A.|Marinosci Law Group, PC - Florida|Pendergast & Morgan, P.A.|Shapiro & Fishman, LLP|Law Offices of Douglas C. Zahm, P.A.

ini := GetPath("myconfig.ini")
city := IniRead(ini, "firefly", "city")
client := IniRead(ini, "firefly", "client")

statusProMessage=The page at https://www.status-pro.biz says: ahk_class MozillaDialogClass
firefox=Status Pro Initial Catalog.*Firefox
excel=In House Process Server Scorecard.*OpenOffice.org Calc

;this is for the retarded comboboxes...
slowSendPauseTime=130
;breaks at 100,110
;reliable at 120,150

Gui, +LastFound -Caption +ToolWindow +AlwaysOnTop
Gui, Add, Button, , Reload Queue
Gui, Add, Button, , Change Queue
Gui, Add, Button, , Add Scorecard Entry
Gui, Add, Button, , X
Gui, Add, Button, , reload ahk
Gui, Show, , Firefly Shortcuts
;Sleep, 200
WinMove, Firefly Shortcuts, , 1770, 550
;}}}

;{{{Persistent items (things that are checked repetitively)
Loop
{
   ;GetKeyState, state, LCONTROL, P
   ;if (state == "D" AND performingAMacro)
      ;reload

   ;Stuff for annoying firefly boxes that are always cancelled out of
   IfWinActive, %statusProMessage%
      if ClickIfImageSearch("images/firefly/wouldYouLikeToApproveThisJob.bmp")
         Click(200, 90, "control")

   if (Mod(A_Sec, 5)==0)
   {
      if NOT didThisOnce
      {
         didThisOnce:=true
         IfWinActive, %statusProMessage%
         {
            if SimpleImageSearch("images/firefly/wouldYouLikeToApproveThisJob.bmp")
               continue
            if SimpleImageSearch("images/firefly/wouldYouLikeToContinueToApproveThisJob.bmp")
               continue
            SaveScreenShot("activeWindow")
         }
         ;AddToTrace(CurrentTime("hyphenated") . "hoping that this does not trigger more than once a second")
      }
   }
   else
   {
      didThisOnce:=false
   }

   Sleep, 100
}

return
;}}}


;{{{ButtonAddScorecardEntry:
ButtonAddScorecardEntry:
performingAMacro:=true

ArrangeWindows()
ForceWinFocus(firefox)
ss()
Click(1100, 165, "left double")
;Click(1100, 165, "left")
ss()
Send, {CTRLDOWN}c{CTRLUP}
ss()
Click(620, 237, "left double")
;Click(620, 237, "left")
ss()
referenceNumber:=Clipboard
if NOT RegExMatch(referenceNumber, "[0-9]{4}")
{
   msgbox, ERROR: I didn't get the reference number (scroll up, maybe?)
   return
}
Send, {CTRLDOWN}a{CTRLUP}{CTRLDOWN}c{CTRLUP}
Click(620, 237, "left")
ss()
Click(612, 254, "left")
ss()
Click(1254, 167, "left")
ss()
Click(922, 374, "left double")
;Click(922, 374, "left")
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
{
   msgbox, ERROR: It looks like this one was cancelled: %status%
   return
}

IfWinExist, The page at https://www.status-pro.biz says: ahk_class MozillaDialogClass
{
   msgbox, ERROR: The website gave us an odd error
   return
}


;;;;;;;;;;;;;;;;
ForceWinFocus(excel)

;DELETEME remove this before moving live
ss()
Send, {UP 50}{LEFT}{UP 50}{LEFT}
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
;ss()
Send, ICMbaustian{ENTER}
;ss()
Send, %today%{ENTER}
;ss()
Send, %referenceNumber%{ENTER}
;ss()
Send, ^c{ENTER}
;ss()
Send, {ENTER}
;ss()
Send, {ENTER}
;ss()
Send, {ENTER}{ENTER}{ENTER}{ENTER}
;ss()
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
;ss()
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
;ss()
Send, {ENTER}
;ss()
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
;ss()
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
;ss()
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
;ss()
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
;ss()
Send, {ENTER}
;ss()
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
;ss()
Send, {ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}
;ss()
Send, {SHIFTDOWN}n{SHIFTUP}{DEL}{ENTER}
;ss()
if NOT InStr(Clipboard, "Service County Not Required")
   msgbox, ERROR: It looks like you need a Service County - it says: %Clipboard%
;ss()

performingAMacro:=false
return
;}}}

;{{{ButtonChangeQueue:
ButtonChangeQueue:
performingAMacro:=true

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
IniWrite(ini, "firefly", "city", city)
IniWrite(ini, "firefly", "client", client)
Gui, 2: Destroy
GoSub, ButtonReloadQueue

performingAMacro:=false
return
;}}}

;{{{ButtonReloadQueue:
ButtonReloadQueue:
performingAMacro:=true

ArrangeWindows()
URLbar := GetURLbar("firefox")
if NOT InStr( URLbar, "status-pro.biz/fc/Portal.aspx" )
   return

ForceWinFocusIfExist(firefox)

BlockInput, MouseMove

;move to top of page
Click(1160, 200, "control")
ss()
Send, {PGUP 20}
ss()

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
Sleep, 500
Click(855, 282, "left control")
ss()
Click(855, 282, "left control")
BlockInput, MouseMoveOff

if ForceWinFocusIfExist(statusProMessage)
{
   WinClose
   Send, ^{F5}
   ;GoSub, ButtonReloadQueue
}

performingAMacro:=false
return
;}}}

;{{{ ButtonX:
ButtonX:
ExitApp
return
;}}}

;{{{ ButtonReloadAhk:
ButtonReloadAhk:
Reload
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
   If InStr(WinGetActiveTitle(), excel) OR InStr(WinGetActiveTitle(), firefox)
      Send, ^!{NUMPAD5}
}

;SSsend(text)
;{
;}

;controlMacrosGoneWild()
;{
   ;GetKeyState, state, LCONTROL, P
   ;if (state == "D")
   ;{
      ;BlockInput, MouseMoveOff
      ;return true
   ;}
;}
