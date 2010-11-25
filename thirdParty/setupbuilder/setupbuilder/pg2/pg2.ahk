dir=;PAGE 2 - Location

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

appname=Setup Builder Professional
appver=1.0.0
title=%appname% %appver% Setup
spacereq=10MB

Gui, Add, Picture, x0 y0 , backtop.bmp
Gui, Add, Progress, y57 x0 w497 h1 cGray vMyProgress2
Gui, Add, Button, x248 y326 w75 h23 , < &Back
Gui, Add, Button, x323 y326 w75 h23 , &Next >
Gui, Add, Button, x409 y326 w75 h23 , Cancel
Gui, Add, Text, x7 y305 vInstr Disabled, %appname% %appver% Installer
GuiControlGet, Inst, Pos, Instr
xpp:=InstW+7
Gui, Add, Progress, y312 x%xpp% w497 h1 cGray vMyProgress
Gui, font, Bold
Gui, Add, Text, x14 y7 backgroundtrans bold, Choose Install Location
Gui, font
Gui, Add, Text, x22 y25 backgroundtrans , Choose the folder in which to install %appname% %appver%.
Gui, Add, Edit, x37 y210 w323 h20 vPath gDriveFunc, %A_ProgramFiles%\%appname%
Gui, Add, Button, x372 y207 w83 h24 gBrowseDir, B&rowse...
Gui, Add, Text, x22 y275 w400 h13 vSpav, Space available: 
Gui, Add, Text, x22 y259 w225 h13 , Space required: 
Gui, Add, Text, x22 y72 w450 h98 , Setup will install %appname% %appver% in the following folder. To install in a different folder`, click Browse and select another folder. Click Next to continue.
Gui, Add, GroupBox, x22 y186 w450 h57 , Destination Folder
Gui, Show, w497 h361, %title%
Gosub, DriveFunc
Return

DriveFunc:
gui,submit,nohide
SplitPath, path,name, dir, ext, name_no_ext, drive
DriveSpaceFree, FreeSpace, %drive%
GuiControl,, Spav, Space available: %FreeSpace% MB
Return

BrowseDir:
FileSelectFolder, installdir, Desktop
GuiControl,, Path, %installdir%
Gosub, DriveFunc
return

GuiClose:
ExitApp