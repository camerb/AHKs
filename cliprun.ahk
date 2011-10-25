#include FcnLib.ahk

;General Window Settings
Gui, Font, s11 w700
Gui, -Caption +E0x200 +ToolWindow
TransColor = D4D1C8
Gui, Color, %TransColor%  ; This color will be made transparent later below.

bgColor = White ; Background color
;Button number, as found using the number pad
Seven = x10 y10 w100 h100 cWhite
Eight = x120 y10 w100 h100 cBlue
Nine = x230 y10 w100 h100 cRed
Four = x10 y120 w100 h100 c6698cb
Five = x120 y120 w100 h100 cFFC128
Six = x230 y120 w100 h100 c90D8EF
One = x10 y230 w100 h100 cf7f7e8
Two = x120 y230 w100 h100 c99cc99
Three = x230 y230 w100 h100 ceeee22

Gui, Add, Button, %Seven%, Drudge
Gui, Add, Button, %Eight%, MSNBC
Gui, Add, Button, %Nine%, Close
Gui, Add, Button, %Four%, MySpace
Gui, Add, Button, %Five%, YAHOO
Gui, Add, Button, %Six%, AutoHotKey
Gui, Add, Button, %One%, EHR
Gui, Add, Button, %Two%, WebPortal
Gui, Add, Button, %Three%, AD
Gui, Show, x400 y400 h340 w340

WinGet, k_ID, ID, A   ; Get its window ID.
WinSet, AlwaysOnTop, On, ahk_id %k_ID%
WinSet, TransColor, %TransColor% 170, ahk_id %k_ID%

Gui, 2:-Caption +E0x200 +ToolWindow
Gui, 2:Color, %bgColor% ; Set background color here

Gui, 2:Add, Progress, %Seven%, 100
Gui, 2:Add, Progress, %Eight%, 100
Gui, 2:Add, Progress, %Nine%, 100
Gui, 2:Add, Progress, %Four%, 100
Gui, 2:Add, Progress, %Five%, 100
Gui, 2:Add, Progress, %Six%, 100
Gui, 2:Add, Progress, %One%, 100
Gui, 2:Add, Progress, %Two%, 100
Gui, 2:Add, Progress, %Three%, 100
Gui, 2:Show, x400 y400 h340 w340
Return

ButtonClose:
ExitApp

ButtonAutoHotKey:
Run, http://www.autohotkey.com/
ExitApp

ButtonYahoo:
Run, http://www.yahoo.com/
ExitApp

ButtonMySpqace:
;Insert autologin code here
ExitApp

ButtonMSNBC:
Run, http://www.msnbc.com
ExitApp

ButtonDrudge:
Run, http://www.drudgereport.com
ExitApp

ButtonAD:
Run, mmc %systemroot%\system32\dsa.msc
WinWait, Active Directory Users and Computers, Active Directory Use
GoSub, LastFoundWindow
Send, {ALTDOWN}ai{ALTUP}
WinWait, Find Users`, Contacts`, and Groups, Select the storage f
GoSub, LastFoundWindow
Send, {SHIFTDOWN}{INS}{SHIFTUP}{ENTER}
Sleep 100
Send, {SPACE}{ALTDOWN}f{ALTUP}
Sleep 200
Send, r
ExitApp

LastFoundWindow: ;Duh
IfWinNotActive  ;automatically uses Last Found Window
    WinActivate  ;automatically uses Last Found Window
WinWaitActive  ;automatically uses Last Found Window
Return

StatusWaitDone: ; Used to wwait for a webpage to load before conintue
   SLEEP 100
   AHKID := WinExist("A")
   Ctr=0
   Loop
      {
      Sleep, 10
      Ctr+=1
      ControlGet, Progress, Visible,, msctls_progress321, ahk_id %AHKID%
      If (Progress=1)
         {
         Ctr=0
         Continue
         }
      If (Progress=0 AND Ctr>10)
      Break
      }
      StatusBarWait, Done, 10 
      RETURN



 ~esc::ExitApp