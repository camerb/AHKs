#include FcnLib.ahk

verticalSplit=677
horizontalSplit=588

rightWidth:=1680-verticalSplit

if (A_ComputerName = "PHOSPHORUS")
{
   SetTitleMatchMode, 2

   WinClose, Buddy List ahk_class gdkWindowToplevel

   WinRestore, GVIM ahk_class Vim
   WinRestore, Administrator: Command Prompt ahk_class ConsoleWindowClass
   WinRestore, ahk_class gdkWindowToplevel

   WinMove, Ext Designer ahk_class QWidget, , %verticalSplit%, 0, %rightWidth%, 1010
   WinMove, GVIM ahk_class Vim, , %verticalSplit%, 0, %rightWidth%, 1010
   WinMove, C:\Windows\system32\cmd.exe ahk_class ConsoleWindowClass, , 0, 0, %verticalSplit%, %horizontalSplit%
   WinMove, Administrator: Command Prompt ahk_class ConsoleWindowClass, , 0, 0, %verticalSplit%, %horizontalSplit%
   WinMove, MINGW32 ahk_class ConsoleWindowClass, , 0, 0, %verticalSplit%, %horizontalSplit%
   WinMove, Git Console2 ahk_class Console_2_Main, , 0, 0, %verticalSplit%, %horizontalSplit%
   WinMove, BareTail ahk_class TMainWindow, , 0, 0, %verticalSplit%, %horizontalSplit%
   WinMove, ahk_class gdkWindowToplevel, , 0, %horizontalSplit%, %verticalSplit%, 424
   WinMove, Irssi ahk_class PuTTY, , 0, %horizontalSplit%, %verticalSplit%, 424
   WinMove, PhosphorusVM - VMware Player ahk_class VMPlayerFrame, , 1758, 0, 1298, 1024

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

   ForceWinFocus("GVIM ahk_class Vim")
   ForceWinFocus("BareTail ahk_class TMainWindow")
   ForceWinFocus("Irssi ahk_class PuTTY")

   WinMove, GVIM ahk_class Vim, , 0, 0, 1177, 1020
   WinMove, BareTail ahk_class TMainWindow, , 1177, 0, 589, 681
   WinMove, Irssi ahk_class PuTTY, , 1179, 680, 587, 340



;>>>>>>>>>>( Window Title & Class )<<<<<<<<<<<
;out1.txt (15.3 KB) - BareTail
;ahk_class TMainWindow

;>>>>>>>>>>( Active Window Position )<<<<<<<<<<
;left: 1177     top: 0     width: 589     height: 681

;>>>>>>>>>>( Window Title & Class )<<<<<<<<<<<
;Irssi v0.8.12 (20071006) - camerb@baustian-09pc ~ CYGWIN_NT-5.1 1.5.24(0.156/4/2) i686
;ahk_class PuTTY

;>>>>>>>>>>( Active Window Position )<<<<<<<<<<
;left: 1179     top: 680     width: 587     height: 340

;>>>>( TitleMatchMode=slow Hidden Text )<<<<
;[No Name] - GVIM
;ahk_class Vim

;>>>>>>>>>>( Active Window Position )<<<<<<<<<<
;left: 0     top: 0     width: 1177     height: 1020


   ;WinMove, PhosphorusVM - VMware Player ahk_class VMPlayerFrame, , 1758, 0, 1298, 1024

   ;IfWinExist, PhosphorusVM - VMware Player ahk_class VMPlayerFrame
   ;{
      ;BlockInput, On

      ;ForceWinFocus("PhosphorusVM - VMware Player ahk_class VMPlayerFrame", "Exact")

      ;;TODO only needs to be a mousemove -- "MouseMoveIfImageSearch"
      ;ClickIfImageSearch("images\VMware\BottomRightCorner.bmp")

      ;Sleep 1000
      ;Click down
      ;MouseMove, 5, 5, , r
      ;Click up
      ;Sleep 1000
      ;Click down
      ;MouseMove, -5, -5, , r
      ;Click up

      ;BlockInput, Off
   ;}
}
