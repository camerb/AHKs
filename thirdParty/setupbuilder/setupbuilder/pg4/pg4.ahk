;PAGE 4 - Shortcuts
;D:\UMAR\Extras\AHK\PSPad_AHK_Toolbar_v1a
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
Gui, Add, Text, x14 y7 backgroundtrans bold, Select Start Menu Folder
Gui, font
Gui, Add, Picture, x45 y75 Icon37, shell32.dll
Gui, Add, Text, x22 y25 backgroundtrans , Choose the folder in which to create the program's shortcuts.
Gui, Add, Text, x90 y80  , Setup will create the program's shortcuts in the following Start Menu folder.
Gui, Add, Text, x45 y115  , To continue, click next. If you would like to select a different folder, click Browse.
Gui, Add, Edit, x45 y140 vSMFolder w320, %appname%
Gui, Add, Button, x375 y139 w80 gBrowseFolder, Browse...
Gui, Add, Text,x45 y175,Additional Options
Gui, Add, Checkbox,x45 y200,Don't create a Start Menu folder.
Gui, Add, Checkbox,x45 y225,Create a Desktop shortcut.

Gui, Show, w497 h361, %title%
Return

BrowseFolder:
FileSelectFolder, smdir, %A_ProgramsCommon%
SplitPath, smdir,name, dir, ext, name_no_ext, drive
GuiControl,, SMFolder, %name%
return

GuiClose:
ExitApp