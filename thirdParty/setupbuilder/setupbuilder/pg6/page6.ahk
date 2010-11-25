;Page 6-Finish

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

appname=Setup Builder
appver=1.0.0
title=%appname% %appver% Setup

Gui, Add, Picture, x0 y0 , welcomepic.bmp
Gui, Add, Picture, x165 y0 , back.bmp
Gui, Font,s13
Gui, Add, Text, x179 y15 w293 h46 BackgroundTrans, Completing the %appname% %appver% Setup Wizard.
Gui, Font,s9
Gui, Add, Text, x179 y72 w293 h228 BackgroundTrans, %appname% %appver% has been installed on your computer.
Gui, Add, Progress, y317 x0 w497 h1 cGray vMyProgress

Gui, Add, Button, x248 y326 w75 h23 , < &Back
Gui, Add, Button, x323 y326 w75 h23 , &Finish
Gui, Add, Button, x409 y326 w75 h23 , Cancel

Gui, Show, x260 y172 h361 w497, %appname% %appver% Setup
Return

GuiClose:
ExitAPP