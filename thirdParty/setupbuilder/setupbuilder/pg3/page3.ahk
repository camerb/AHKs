;PAGE 3 - Location

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

appname=Setup Builder Professional
appver=1.0.0
title=%appname% %appver% Setup
spacereq=10MB

appname=Setup Builder Professional
appver=1.0.0
title=%appname% %appver% Setup
spacereq=10MB

Gui, Add, Picture, x0 y0 , backtop.bmp
Gui, Add, Progress, y57 x0 w497 h1 cGray vMyProgress2
Gui, Add, Button, x248 y326 w75 h23 , < &Back
Gui, Add, Button, x323 y326 w75 h23 Disabled vNext, &Next >
Gui, Add, Button, x409 y326 w75 h23 , Cancel
Gui, Add, Text, x7 y305 vInstr Disabled, %appname% %appver% Installer
GuiControlGet, Inst, Pos, Instr
xpp:=InstW+7
Gui, Add, Progress, y312 x%xpp% w497 h1 cGray vMyProgress

Gui, font, Bold
Gui, Add, Text, x14 y7 backgroundtrans bold, License Agreement
Gui, font
Gui, Add, Text, x22 y25 backgroundtrans , Please read the following important information before continuing.
Gui, Add, Text, x22 y72 w450 h98 , Please read the following License Agreement. You must accept the terms of this agreement before continuing with the installation. 
Gui, add, Edit, x22 y110 w450 h140, License Agreement`n================

Gui, Add, Radio, gLicAgree vAgree, I agree with the terms.
Gui, Add, Radio, gLicAgree vDisAgree Checked, I disagree with the terms.

Gui, Show, w497 h361, %title%
Return

GuiClose:
ExitApp

LicAgree:
gui,submit,nohide
if (Agree=0 or Disagree=1){
Guicontrol,Disable,Next
}
else
{
Guicontrol,Enable,Next
}
return

