#include FcnLib.ahk

verticalSplit=677
horizontalSplit=588

rightWidth:=1680-verticalSplit

if (A_ComputerName == "PHOSPHORUS")
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
