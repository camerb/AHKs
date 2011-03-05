#include FcnLib.ahk

bottomRightX:=A_ScreenWidth
bottomRightY=1040
;ahk_class Shell_TrayWnd
;the top pixel of that window

verticalSplit=797
horizontalSplit=588

bottomLeftHeight:=bottomRightY-horizontalSplit
rightWidth:=bottomRightX-verticalSplit

if (A_ComputerName = "PHOSPHORUS")
{
   SysGet, MonitorCount, MonitorCount
   if (MonitorCount == 1)
   {
      WinGet, hwnd, ID, A
      WinMove, ahk_id %hwnd%, , 10, 10
      ExitApp
   }

   SetTitleMatchMode, 2

   WinClose, Buddy List ahk_class gdkWindowToplevel

   WinRestore, GVIM ahk_class Vim
   WinRestore, Administrator: Command Prompt ahk_class ConsoleWindowClass
   WinRestore, ahk_class gdkWindowToplevel

   WinMove, Ext Designer ahk_class QWidget, , %verticalSplit%, 0, %rightWidth%, %bottomRightY%
   WinMove, GVIM ahk_class Vim, , %verticalSplit%, 0, %rightWidth%, %bottomRightY%
   WinMove, C:\Windows\system32\cmd.exe ahk_class ConsoleWindowClass, , 0, 0, %verticalSplit%, %horizontalSplit%
   WinMove, Administrator: Command Prompt ahk_class ConsoleWindowClass, , 0, 0, %verticalSplit%, %horizontalSplit%
   WinMove, MINGW32 ahk_class ConsoleWindowClass, , 0, 0, %verticalSplit%, %horizontalSplit%
   WinMove, Git Console2 ahk_class Console_2_Main, , 0, 0, %verticalSplit%, %horizontalSplit%
   WinMove, BareTail ahk_class TMainWindow, , 0, 0, %verticalSplit%, %horizontalSplit%
   WinMove, ahk_class gdkWindowToplevel, , 0, %horizontalSplit%, %verticalSplit%, %bottomLeftHeight%
   WinMove, Irssi ahk_class PuTTY, , 0, %horizontalSplit%, %verticalSplit%, %bottomLeftHeight%
   WinMove, PhosphorusVM - VMware Player ahk_class VMPlayerFrame, , 2000, 0, 1298, 1024

   if ForceWinFocusIfExist("Google Chrome")
   {
      WinMove, Google Chrome, , 1920, 0, 1765, 1081
      Sleep, 10
      WinMove, Google Chrome, , 1920, 0, 1765, 1080
      ;Send, ^!{RIGHT}
      ;Send, ^!{NUMPAD2}
      ;Send, ^!{NUMPAD5}
      Send, ^!1
   }

   if ForceWinFocusIfExist("Mozilla Firefox")
   {
      WinMove, Mozilla Firefox, , 1920, 0, 1765, 1080
      ;Send, ^!{RIGHT}
      ;Send, ^!{NUMPAD2}
      ;Send, ^!{NUMPAD5}
      Send, ^!2
   }

   IfWinExist, PhosphorusVM - VMware Player ahk_class VMPlayerFrame
   {
      BlockInput, On

      ForceWinFocus("PhosphorusVM - VMware Player ahk_class VMPlayerFrame", "Exact")

      ;TODO only needs to be a mousemove -- "MouseMoveIfImageSearch"
      ClickIfImageSearch("images\VMware\BottomRightCorner.bmp")

      Sleep 1000
      Click down
      MouseMove, 5, 5, , r
      Click up
      Sleep 1000
      Click down
      MouseMove, -5, -5, , r
      Click up

      BlockInput, Off
   }

}

if (A_ComputerName = "BAUSTIAN-09PC")
{
   SetTitleMatchMode, 2

   ForceWinFocusIfExist("GVIM ahk_class Vim")
   ForceWinFocusIfExist("BareTail ahk_class TMainWindow")
   ForceWinFocusIfExist("Irssi ahk_class PuTTY")

   WinMove, GVIM ahk_class Vim, , 0, 0, 1177, 1020
   WinMove, BareTail ahk_class TMainWindow, , 1177, 0, 589, 681
   WinMove, Irssi ahk_class PuTTY, , 1179, 680, 587, 340

}
