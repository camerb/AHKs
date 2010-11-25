;***********************************************************************************

;Setup Builder - Functions
;Copyright 2010 Muhammad Umar

;Some of the layout of the gui is taken from Inno Setup, Copyright Jordan Russell.

;Define Functions for pages of the setup :

;SETUP_WELCOMEPAGE(appname,appver,logopic) 
;Gui 2

;SETUP_INSTALLDIRPAGE(appname,appver,pathdir)
;Gui 3

;SETUP_SPLASHBACK(appname)
;Gui 1

;SETUP_LICENSEPAGE(appname,appver,licfile)
;Gui 4

;SETUP_SHORTCUTSPAGE(appname,appver)
;Gui 5

;SETUP_FINISHPAGE(appname,appver)
;Gui 6

;SETUP_PROGRESSPAGE(appname,appver)
;Gui 7

;Configuration File to read settings
;setup.ini

;***********************************************************************************

;Improve Performance

#NoEnv
#SingleInstance, force
SetBatchLines -1
ListLines Off
SendMode Input
SetWorkingDir %A_ScriptDir%

;***********************************************************************************

;Read Settings from local setup.ini file
;Declare Variables

IniRead, appname, setup.ini, General, appname
appname:=appname

IniRead, appver, setup.ini, General, appver
appver:=appver

IniRead, logopic, setup.ini, General, logopic
logopic:=logopic

IniRead, licfile, setup.ini, License, licfile
licfile:=licfile

IniRead, pathdir, setup.ini, Dir, pathdir
pathdir:=pathdir

IniRead, SMFolder, setup.ini, Shortcuts, SMFolder
SMFolder:=SMFolder

IniRead, SMSC, setup.ini, Shortcuts, SMSC
SMSC:=SMSC

IniRead, DesktopSC, setup.ini, Shortcuts, DesktopSC
DesktopSC:=DesktopSC

;***********************************************************************************

;Welcome Page - GUI 2

;Parameters:
;	appname
;	appver
;	logopic

SETUP_WELCOMEPAGE(appname,appver,logopic){
Gui, 2:Add, Picture, x0 y0 , %logopic%
Gui, 2:Add, Picture, x165 y0 , back.bmp
Gui, 2:Add, Button, x323 y326 w75 h23 , &Next >
Gui, 2:Add, Button, x409 y326 w75 h23 , Cancel
Gui, 2:Font,s13
Gui, 2:Add, Text, x179 y15 w293 h46 BackgroundTrans, Welcome to the %appname% %appver% Setup Wizard
Gui, 2:Font,s9
Gui, 2:Add, Text, x179 y72 w293 h228 BackgroundTrans, This wizard will guide you through the installation of %appname% %appver%.`n`nIt is recommended that you close all other applications before starting Setup. This will make it possible to update relevant system files without having to reboot your computer.`n`nClick next to continue.
Gui, 2:Add, Progress, y317 x0 w497 h1 cGray
Gui, 2:Show, w497 h361, %appname% %appver% Setup
Return
}

;***********************************************************************************

;Install Location Page - GUI 3

;Parameters:
;	appname
;	appver
;	pathdir

SETUP_INSTALLDIRPAGE(appname,appver,pathdir){
Gui, 3:Add, Picture, x0 y0 , backtop.bmp
Gui, 3:Add, Progress, y57 x0 w497 h1 cGray,100
Gui, 3:Add, Button, x248 y326 w75 h23 , < &Back
Gui, 3:Add, Button, x323 y326 w75 h23 , &Next >
Gui, 3:Add, Button, x409 y326 w75 h23 , Cancel
static Instr
Gui, 3:Add, Text, x7 y305 vInstr Disabled, %appname% %appver% Installer
GuiControlGet, Inst, 3:Pos, Instr
xpp:=InstW+7
Gui, 3:Add, Progress, y312 x%xpp% w497 h1 cGray
global Path, Spav 
Gui, 3:font, Bold
Gui, 3:Add, Text, x14 y7 backgroundtrans, Choose Install Location
Gui, 3:font
Gui, 3:Add, Text, x22 y25 backgroundtrans , Choose the folder in which to install %appname% %appver%.
Gui, 3:Add, Edit, x37 y210 w323 h20 vPath gDriveFunc, %pathdir%
Gui, 3:Add, Button, x372 y207 w83 h24 gBrowseDir, B&rowse...
Gui, 3:Add, Text, x22 y275 w400 h13 vSpav, Space available: 
Gui, 3:Add, Text, x22 y259 w225 h13 , Space required: 
Gui, 3:Add, Text, x22 y72 w450 h98 , Setup will install %appname% %appver% in the following folder. To install in a different folder`, click Browse and select another folder. Click Next to continue.
Gui, 3:Add, GroupBox, x22 y186 w450 h57 , Destination Folder
Gui, 3:Show, w497 h361, %appname% %appver% Setup
Gosub, DriveFunc
Return

DriveFunc:
gui,3:submit,nohide
static drive, FreeSpace
SplitPath, path,name, dir, ext, name_no_ext, drive
DriveSpaceFree, FreeSpace, %drive%
GuiControl,3:, Spav, Space available: %FreeSpace% MB
Return

BrowseDir:
FileSelectFolder, installdir, Desktop
if (!installdir)
{
	GuiControl,3:, Path, %Path%
}
else
{
GuiControl,3:, Path, %installdir%
Gosub, DriveFunc
}
return
}

;***********************************************************************************

;Splash Background Page - GUI 1

;Parameters:
;	appname

SETUP_SPLASHBACK(appname){
Gui, Margin, 0,0 
Gui, Add, Picture, x0 y0 w1024 h768, bg.bmp 
gui, font, s36 cBlack, Verdana
splashtext=%appname% Setup
gui, add, text,x20 y20 backgroundtrans,%splashtext%
gui, font, s36 cWhite, Verdana
gui, add, text,x23 y23 backgroundtrans,%ssplashtext%
Gui,Show,,Setup
WinMaximize,Setup
return
}

;***********************************************************************************

;License Agreement Page - GUI 4

;Parameters:
;	appname
;	appver
;	licfile

SETUP_LICENSEPAGE(appname,appver,licfile){
Gui, 4:Add, Picture, x0 y0 , backtop.bmp
Gui, 4:Add, Progress, y57 x0 w497 h1 cGray
Gui, 4:Add, Button, x248 y326 w75 h23 , < &Back
global Next
Gui, 4:Add, Button, x323 y326 w75 h23 Disabled vNext, &Next >
Gui, 4:Add, Button, x409 y326 w75 h23 , Cancel
static Instr
Gui, 4:Add, Text, x7 y305 vInstr Disabled, %appname% %appver% Installer
GuiControlGet, Inst, 4:Pos, Instr
xpp:=InstW+7
Gui, 4:Add, Progress, y312 x%xpp% w497 h1 cGray
static LicAg, licfiler
Gui, 4:font, Bold
Gui, 4:Add, Text, x14 y7 backgroundtrans, License Agreement
Gui, 4:font,norm
Gui, 4:Add, Text, x22 y25 backgroundtrans , Please read the following important information before continuing.
Gui, 4:Add, Text, x22 y72 w450 h98 , Please read the following License Agreement. You must accept the terms of this agreement before continuing with the installation. 
Gui, 4:Add, Edit, x22 y110 w450 h140 vLicAg, License Agreement`n================
FileRead, licfiler, %licfile%
GuiControl,4:,LicAg,%licfiler%
static Agree, DisAgree
Gui, 4:Add, Radio, gLicAgree vAgree, I agree with the terms.
Gui, 4:Add, Radio, gLicAgree vDisAgree Checked, I disagree with the terms.
Gui, 4:Show, w497 h361, %appname% %appver% Setup
Return
LicAgree:
gui,submit,nohide
if (Agree=0 or Disagree=1){
Guicontrol,4:Disable,Next
}
else
{
Guicontrol,4:Enable,Next
}
return
}

;***********************************************************************************

;Shortcuts Page - GUI 5

;Parameters:
;	appname
;	appver
;	SMFolder
;	SMSC
;	DesktopSC

SETUP_SHORTCUTSPAGE(appname,appver,SMFolder,SMSC,DesktopSC){
Gui, 5:Add, Picture, x0 y0 , backtop.bmp
Gui, 5:Add, Progress, y57 x0 w497 h1 cGray 
Gui, 5:Add, Button, x248 y326 w75 h23 , < &Back
Gui, 5:Add, Button, x323 y326 w75 h23 , &Next >
Gui, 5:Add, Button, x409 y326 w75 h23 , Cancel
static Instr
Gui, 5:Add, Text, x7 y305 vInstr Disabled, %appname% %appver% Installer
GuiControlGet, Inst, 5:Pos, Instr
xpp:=InstW+7
Gui, 5:Add, Progress, y312 x%xpp% w497 h1 cGray
Gui, 5:font, Bold
Gui, 5:Add, Text, x14 y7 backgroundtrans bold, Select Start Menu Folder
Gui, 5:font,norm
Gui, 5:Add, Picture, x45 y75 Icon37, shell32.dll
Gui, 5:Add, Text, x22 y25 backgroundtrans , Choose the folder in which to create the program's shortcuts.
Gui, 5:Add, Text, x90 y80 vT1, Setup will create the program's shortcuts in the following Start Menu folder.
Gui, 5:Add, Text, x45 y115 vT2 , To continue, click next. If you would like to select a different folder, click Browse.
global SMFolder1, T1, T2, T3
Gui, 5:Add, Edit, x45 y140 vSMFolder1 w320, %SMFolder%
Gui, 5:Add, Button, x375 y139 w80 vT3 gBrowseFolder, Browse...
Gui, 5:Add, Text,x45 y175,Additional Options
global SMSCbox , DSCbox
Gui, 5:Add, Checkbox,x45 y200 vSMSCbox gSMSC,Don't create a Start Menu folder.
Gui, 5:Add, Checkbox,x45 y225 vDSCbox gDSC,Create a Desktop shortcut.
Gosub, SCCheck
Gui, 5:Show, w497 h361, %title%
Return

BrowseFolder:
global smdir,name
FileSelectFolder, smdir, %A_ProgramsCommon%
if (!smdir) {
	GuiControl,5:, SMFolder1, %SMFolder%
}
Else
{
SplitPath, smdir,name, dir, ext, name_no_ext, drive
GuiControl,5:, SMFolder1, %name%
}
return

SCCheck:
smsc1 := (SMSC=1) ? "1" : "0"
dsc1 := (DesktopSC=1) ? "1" : "0"
if (smsc1=1) {
	GuiControl, 5:, SMSCbox, 0
}
Else if (smsc1=0){
	GuiControl, 5:, SMSCbox,1
}
if (dsc1=1) {
	GuiControl, 5:, DSCbox, 1
}
Else if (dsc1=0){
	GuiControl, 5:, DSCbox,0
}

SMSC:
gui,submit,nohide
if (SMSCbox=1){
	GuiControl,disable,T1
	GuiControl,disable,T2
	GuiControl,disable,T3
	GuiControl,disable,SMFolder1
}
else if (SMSCbox=0){
	GuiControl,enable,T1
	GuiControl,enable,T2
	GuiControl,enable,T3
	GuiControl,enable,SMFolder1
	}
Return

DSC:
return
}

;***********************************************************************************

;Finish Page - GUI 6

;Parameters:
;	appname
;	appver

SETUP_FINISHPAGE(appname,appver){
Gui, 6:Add, Picture, x0 y0 , welcomepic.bmp
Gui, 6:Add, Picture, x165 y0 , back.bmp
Gui, 6:Font,s13
Gui, 6:Add, Text, x179 y15 w293 h46 BackgroundTrans, Completing the %appname% %appver% Setup Wizard.
Gui, 6:Font,s9
Gui, 6:Add, Text, x179 y72 w293 h228 BackgroundTrans, %appname% %appver% has been installed on your computer.
Gui, 6:Add, Progress, y317 x0 w497 h1 cGray
Gui, 6:Add, Button, x248 y326 w75 h23 , < &Back
Gui, 6:Add, Button, x323 y326 w75 h23 , &Finish
Gui, 6:Add, Button, x409 y326 w75 h23 , Cancel
Gui, 6:Show, x260 y172 h361 w497, %appname% %appver% Setup
Return
}

;***********************************************************************************

;Installing Progress Page - GUI 7

;Parameters:
;	appname
;	appver

SETUP_PROGRESSPAGE(appname,appver){
Gui, 7:Add, Picture, x0 y0 , backtop.bmp
Gui, 7:Add, Progress, y57 x0 w497 h1 cGray
Gui, 7:Add, Button, x248 y326 w75 h23 , < &Back
Gui, 7:Add, Button, x323 y326 w75 h23 , &Next >
Gui, 7:Add, Button, x409 y326 w75 h23 , Cancel
static Instr
Gui, 7:Add, Text, x7 y305 vInstr Disabled, %appname% %appver% Installer
GuiControlGet, Inst, 7:Pos, Instr
xpp:=InstW+7
Gui, 7:Add, Progress, y312 x%xpp% w497 h1 cGray
Gui, 7:font, Bold
Gui, 7:Add, Text, x14 y7 backgroundtrans bold, Installing
Gui, 7:font,NORM
Gui, 7:Add, Text, x22 y25 backgroundtrans , Please wait while the program has been installed.
global InsProg
Gui, 7:Add, Progress, x30 y80 w430 h25 -smooth vInsProg,55
Gui, 7:Show, w497 h361, %appname% %appver% Setup
Return
}