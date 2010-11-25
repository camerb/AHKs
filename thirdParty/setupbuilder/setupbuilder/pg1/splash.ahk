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

Gui, Margin, 0,0 
Gui, Add, Picture, x0 y0 w1024 h768, bg.bmp 
gui, font, s36 cBlack, Verdana
gui, add, text,x20 y20 backgroundtrans,Sajanpur
gui, font, s36 cWhite, Verdana
gui, add, text,x23 y23 backgroundtrans,Sajanpur
Gui,Show,,%appname% Setup
WinMaximize,%appname% Setup
return

Guiclose:
exitapp