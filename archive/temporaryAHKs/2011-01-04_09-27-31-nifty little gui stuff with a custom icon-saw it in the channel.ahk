#include FcnLib.ahk

#Persistent
#Singleinstance, force
#InstallMouseHook
#InstallKeybdHook
#KeyHistory 8
#ClipboardTimeout 2000
SendMode Input
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode, 2
SetControlDelay -1
SetBatchLines, -1
DetectHiddenWindows, on

Menu, Tray, NoStandard
Menu, Tray, Tip , The Master Script
Menu, Tray, Icon, Shell32.dll, 177

Menu, Tray, add, Edit, Edit
Menu, Tray, add, Reload, Reload
Menu, Tray, add,,,
Menu, Tray, add, Suspend, Suspend
Menu, Tray, add, Pause, Pause
Menu, Tray, add,,,s


Menu, Menu1, add, Run Clipboard, RunClipboard
Menu, Menu1, add, Key History, KeyHistory
Menu, Tray, add, Tools, :Menu1


Menu, Menu2, add, Notepad, Notepad
Menu, Menu2, add, OnScreenKeyboard, OnScreenKeyboard
Menu, Menu2, add, Calculator, Calculator
Menu, Menu2, add, FireFox, FireFox
Menu, Tray, add, Programs, :Menu2

Menu, Tray, add,,,
Menu, Tray, add, Exit, Exit

return


;------------------------------------------------------------------------------
;//////////////////////MENUS///////////////////////////////////////
;------------------------------------------------------------------------------


Edit:
Run, Notepad.exe %a_ScriptFullPath%
return

Reload:
Reload
return

Suspend:
Suspend
Return

Pause:
Pause
return

Exit:
ExitApp
return


;==============Tools===============

RunClipboard:
Filedelete, Quicktest.ahk
FileAppend, %Clipboard%, QuickTest.ahk
Run, QuickTest.ahk
return

KeyHistory:
Loop {
   KeyHistory
   sleep,500
}
return

;==============Programs===============

Notepad:
Run, Notepad.exe
return

OnScreenKeyboard:
Run, osk.exe
return

Calculator:
Run, Calc.exe
return

FireFox:
run, C:\Program Files\Mozilla Firefox\fireFox.exe
return

