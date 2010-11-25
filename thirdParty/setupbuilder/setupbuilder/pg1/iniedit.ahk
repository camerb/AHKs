;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Gui, add, Text,, Program Name:
Gui, add, Text,, Program Version (short):
Gui, add, Text,, Program Version (full):
Gui, add, Text,, Welcome Logo Image (w164 h316):
Gui, add, Text,, Install Path:
Gui, add, Text,, Start Menu Shortcut Folder:
Gui, add, Text,, Desktop Shortcut:
Gui, add, Text,, License File (txt):
Gui, add, Text,, Files:

Gui, Add, ListBox, h200 vCC, c:\tariq.ini
GuiControl,,CC,112|dfsdf|ASdfsafasf|sdfsadf\sfdsf\|asdfsf

Gui,show,

Return
GuiClose:
ExitApp
