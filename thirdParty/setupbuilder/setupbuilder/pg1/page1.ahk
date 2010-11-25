;PAGE 1 - Welcome

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

appname=Setup Builder
appver=1.0.0
title=%appname% %appver% Setup

Gui, Add, Picture, x0 y0 , welcomepic.bmp
Gui, Add, Picture, x165 y0 , back.bmp
Gui, Add, Button, x323 y326 w75 h23 , &Next >
Gui, Add, Button, x409 y326 w75 h23 , Cancel
Gui, Font,s13
Gui, Add, Text, x179 y15 w293 h46 BackgroundTrans, Welcome to the %appname% %appver% Setup Wizard
Gui, Font,s9
Gui, Add, Text, x179 y72 w293 h228 BackgroundTrans, This wizard will guide you through the installation of %appname% %appver%.`n`nIt is recommended that you close all other applications before starting Setup. This will make it possible to update relevant system files without having to reboot your computer.`n`nClick next to continue.
Gui, Add, Progress, y317 x0 w497 h1 cGray vMyProgress
; Generated using SmartGUI Creator 4.0
Gui, Show, w497 h361, %title%
Return

GuiClose:
ExitApp

