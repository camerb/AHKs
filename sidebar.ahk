#include FcnLib.ahk

DetectHiddenWindows, On
CustomTitleMatchMode("Exact")
CustomTitleMatchMode("Contains")
OnExit, ExitSub

WinGetPos, no, no, no, trayHeight, ahk_class Shell_TrayWnd

childWindows=TimeWidget.ahk
;,RemoteWidget2.ahk
allWindows=AHK Sidebar,%childWindows%

;A_ScreenWidth
;A_ScreenHeight
screenheight:=A_ScreenHeight
screenwidth:=A_ScreenWidth
width:=160
height:=screenheight - trayheight
xpos:=screenwidth - width
ypos:=0
;debug("notimeout", width, height, xpos, ypos)

configIni=sidebar_config.ini
;IniWrite(configIni, "TimeWidget.ahk", "x", 233)

CustomColor1 = ffaa00
CustomColor2 = 000000
Gui, +LastFound
Gui, -Caption
Gui, +ToolWindow
Gui, +AlwaysOnTop
Gui, Color, %CustomColor1%
Gui, Font, s36
Gui, Add, Text, cRed, 
WinSet, TransColor, %CustomColor2% 150
Gui, Show, NoActive, AHK Sidebar
WinMove, , , %xpos%, %ypos%, %width%, %height%
Loop, parse, childWindows, CSV
{
   thisWindow=%A_LoopField% ahk_class AutoHotkeyGUI
   Run, %A_LoopField%
   WinWaitActive, %A_LoopField%
   Loop
   {
      Sleep, 100
      WinMove, %thisWindow%, , %xpos%, %ypos%
      WinGetPos, winXpos, winYPos, no, no, %thisWindow%
      if (winXpos == xpos AND winYpos == ypos)
         break
   }
}
SleepSeconds(2)
;SleepSeconds(20)
GoSub, ExitSub


ExitSub:
Loop, parse, childWindows, CSV
   WinClose, %A_LoopField% ahk_class AutoHotkeyGUI
Loop, parse, allWindows, CSV
   WinClose, %A_LoopField% ahk_class AutoHotkeyGUI
;TODO close child processes forcefully
ExitApp