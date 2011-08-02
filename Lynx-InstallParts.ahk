#include FcnLib.ahk

SetComputerName()
{
;set computer name
command=netdom.exe renamecomputer %A_ComputerName% /newname:%LynxCompyName%
GhettoCmdRet_RunReturn(command)
SleepSend("Y{ENTER}")
SleepSeconds(2)
WinClose
}

CopyInstallationFilesToHardDrive()
{
   ;Copy install files to the hard drive
   source:=DriveLetter() . ":\LynxCD\"
   FileCopyDir, %source%, C:\LynxCD\, 1
}

TurnOffWindowsFirewall()
{
;turn off firewall
Run, C:\windows\system32\firewall.cpl
ForceWinFocus("Windows Firewall")
SleepClick(95, 175)
ForceWinFocus("Customize Settings")
SleepClick(284, 247)
SleepClick(284, 382)
SleepClick(570, 570)
SleepSeconds(1)
WinClose, Windows Firewall
}

ChangeScreenResolution()
{
;Increase the screen resolution as much as possible
ForceWinFocus("Program Manager ahk_class Progman")
SleepSend("{AppsKey}c")

;note that this is Run > "control desk.cpl"
ForceWinFocus("Screen Resolution ahk_class CabinetWClass")
SleepSend("!r{UP 50}{ENTER}")
SleepSend("!a")

WinWaitActive, Display Settings, &Keep changes, 5
if NOT ERRORLEVEL
   SleepSend("!k")

ForceWinFocus("Screen Resolution ahk_class CabinetWClass")
SleepSend("!fc")
}

InstallActivePerl()
{
Run, C:\LynxCD\Server 7.11\Setup\ActivePerl-5.8.9.827-MSWin32-x86-291969.msi

ForceWinFocus("ActivePerl 5.8.9 Build 827 Setup ahk_class MsiDialogCloseClass")
SleepSeconds(3)
Send, !n
WinWaitActive, , accept the terms in the License Agreement
SleepSeconds(1)
Send, !a
SleepSeconds(1)
Send, !n
SleepSeconds(1)
Send, !n
SleepSeconds(1)
Send, !n
SleepSeconds(1)
;press install button
Send, !i
SleepSeconds(1)

;wait for install to complete (and the prompt to look at the release notes)
CustomTitleMatchMode("Contains")
WinWaitActive, , Display the release notes, 600
if ERRORLEVEL
   fatalErrord("ActivePerl install never finished")
SleepSeconds(1)
Click(255, 286)
SleepSeconds(1)
Send, !f
}


InstallSSMS()
{
Run, C:\LynxCD\Server 7.11\Setup\en_sql_server_2008_r2_express_with_management_tools_x64.exe

successWinText=New installation or add features to an existing installation
failureWinText=setup requires Microsoft .NET Framework
if ( MultiWinWait("", successWinText, "", failureWinText) = "FAILURE")
{
   WinWaitActive, , %failureWinText%, 600
   Sleep, 500
   Click(287, 150)
}

WinWaitActive, , %successWinText%, 600
Sleep, 500
Click(341, 42)

WinWaitActive, , I &accept the license terms, 600
SleepSeconds(1)
Send, !a
SleepSeconds(1)
Send, !n
SleepSeconds(1)

WinWaitActive, , Select the Express with Advanced Services features to install, 600
SleepSeconds(1)
Send, !n

WinWaitActive, , Specify the name and instance ID for the instance of SQL Server, 600
SleepSeconds(1)
Send, !d
SleepSeconds(1)
Send, !n

WinWaitActive, , Specify the service accounts and collation configuration, 600
SleepSeconds(1)
MouseClick, left,  580,  199
SleepSeconds(1)
MouseClick, left,  580,  199
SleepSeconds(1)
MouseClick, left,  568,  231
SleepSeconds(1)
MouseClick, left,  770,  221
SleepSeconds(1)
MouseClick, left,  770,  240
SleepSeconds(1)
Send, !n

WinWaitActive, , Specify Database Engine authentication security mode, 600
SleepSeconds(1)
Send, !m
SleepSeconds(1)
Send, !e
SleepSeconds(1)
Send, Password1!
SleepSeconds(1)
Send, !o
SleepSeconds(1)
Send, Password1!
SleepSeconds(1)
Send, !a

ForceWinFocus("Select Users or Groups")
SleepSend("!e")
SleepSend(A_ComputerName . "\Administrators")
SleepSeconds(1)
Click(325, 222)

WinWaitActive, , Specify Database Engine authentication security mode, 600
SleepSend("!n")

WinWaitActive, , Help Microsoft improve SQL Server, 600
SleepSend("!n")

WinWaitActive, , Your SQL Server 2008 R2 installation completed successfully, 600
SleepSeconds(1)
Click(688, 588)

ForceWinFocus("SQL Server Installation Center")
WinClose
}





ConfigureSSMS()
{
SleepSeconds(20)
Run, C:\Windows\SysWOW64\mmc.exe /32 c:\Windows\SysWOW64\SQLServerManager10.msc

ForceWinFocus("Sql Server Configuration Manager")
SleepClick(150,  400)
SleepClick(150,  400)
SleepSend("{LEFT 50}")
SleepSend("{RIGHT}")
Loop 4
   SleepSend("{DOWN}")
SleepSend("{RIGHT 10}")
;SleepClick(98,  166)
SleepClick(329,  119, "right")
SleepClick(375,  175)
ForceWinFocus("Named Pipes Properties")
SleepClick(366,  79)
SleepClick(342,  100)
SleepClick(106,  409)
;SleepClick(948,  427)
WinWaitActive, Warning, , 5
if NOT ERRORLEVEL
   SleepSend("{ENTER}")
   ;SleepClick(342,  122)
ForceWinFocus("Sql Server Configuration Manager")
;SleepClick(249,  15)
;SleepClick(255,  11)
SleepClick(306,  138, "right")
SleepClick(364,  194)
ForceWinFocus("TCP/IP Properties")
SleepClick(366,  79)
SleepClick(342,  100)
SleepClick(106,  409)
;SleepClick(948,  427)
WinWaitActive, Warning, , 5
if NOT ERRORLEVEL
   SleepSend("{ENTER}")
   ;SleepClick(342,  122)

SleepSeconds(2)
ForceWinFocus("Sql Server Configuration Manager")
SleepSeconds(2)
WinClose
SleepSeconds(2)

RestartService("MSSQLSERVER")

file1=lLynx.mdf
file2=lLynx_log.ldf
sourcePath=C:\LynxCD\Server 7.11\Setup\
destPath=C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\
source1=%sourcePath%%file1%
source2=%sourcePath%%file2%
dest1=%destPath%%file1%
dest2=%destPath%%file2%
FileCopy(source1, dest1, "overwrite")
FileCopy(source2, dest2, "overwrite")

Run, C:\Program Files (x86)\Microsoft SQL Server\100\Tools\Binn\VSShell\Common7\IDE\Ssms.exe
ForceWinFocus("Connect to Server")
SleepSend("(local)")
SleepSend("!c")
SleepSeconds(20)
ForceWinFocus("Microsoft SQL Server Management Studio")
SleepClick(77,  137, "right")
SleepClick(146,  177)
ForceWinFocus("Attach Databases")
SleepClick(493,  305)
ForceWinFocus("Locate Database Files", "Contains")
SleepClick(355,  291)
SleepClick(199,  546)
SleepSend(dest1)
SleepClick(297,  573)
ForceWinFocus("Attach Databases")
SleepClick(560,  606)

WinWaitActive, , If you are certain that you have added all the necessary, 10
if NOT ERRORLEVEL
   SleepClick(473,  97)

ForceWinFocus("Microsoft SQL Server Management Studio")
WinClose

ConfigureODBC("32")
ConfigureODBC("64")

ForceWinFocus("system32")
WinClose
ForceWinFocus("SysWOW64")
WinClose

FileCopyDir, C:\LynxCD\Server 7.11\inetpub, c:\inetpub, 1
}

TestBannerDotPlx()
{
ret := CmdRet_RunReturn("perl C:\inetpub\wwwroot\cgi\banner.plx", "C:\inetpub\wwwroot\cgi\")
if NOT InStr(ret, "Location: /banner/banner.gif")
   errord("the banner.plx file did not run correctly, instead it returned:", ret)
}

ConfigureW3SVCservice()
{
;stop and disable W3SVC service (WWW Pub Service)
ShortSleep()
CmdRet_RunReturn("net stop W3SVC")
ShortSleep()
ret := CmdRet_Runreturn("sc config W3SVC start= disabled")
;DO NOT check for success... (it may not have been installed in the first place)
;if NOT InStr(ret, "SUCCESS")
   ;MsgBox, %ret%
}

InstallApache()
{
SleepSeconds(20)
Run, C:\LynxCD\Server 7.11\Setup\apache_2.2.8-win32-x86-openssl-0.9.8g.msi
SleepSeconds(9)

;ForceWinFocus("Apache")
SleepSeconds(1)
SleepSend("!n")
SleepSend("!a")
SleepSend("!n")
SleepSend("!n")
SleepSend("!n")
SleepSend("!n")
SleepSend("!n")
SleepSend("!i")
WinWaitActive, , The Installation Wizard has successfully installed Apache
SleepSend("!f")

SleepSeconds(1)
FileCopy("C:\LynxCD\Server 7.11\Setup\httpd.conf", "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\conf\httpd.conf", "overwrite")

RestartService("apache2.2")
}

ConfigureAudioSrvService()
{
ret := CmdRet_Runreturn("sc config AudioSrv start= auto")
if NOT InStr(ret, "SUCCESS")
   MsgBox, %ret%
ShortSleep()
CmdRet_RunReturn("net start AudioSrv")
ShortSleep()
}

InstallAllTTS()
{
Run, C:\LynxCD\Server 7.11\Text2Speech\SIIG\setup.exe
WinWaitActive, , Welcome to the InstallShield Wizard
SleepSend("!n")
SleepSend("!n")
WinWaitActive, , Installation is complete
SleepClick(35, 160)
SleepClick(160, 190)

Run, C:\LynxCD\Server 7.11\Text2Speech\kate\setup.exe
InstallTTS()
Run, C:\LynxCD\Server 7.11\Text2Speech\paul\setup.exe
InstallTTS()

Run, C:\LynxCD\Server 7.11\Text2Speech\setup.exe
SleepSeconds(2)
SleepSend("!n")
SleepSend("!n")
SleepSend("!n")
WinWaitActive, , Setup has finished installing
SleepSend("!f")
}

InstallIIS()
{
;install IIS (clickin' around)
GhettoCmdRet_RunReturn("%SystemRoot%\system32\ServerManager.msc", "", "extraGhettoForHighAuth")
ForceWinFocus("Server Manager")
SleepSeconds(20)
ForceWinFocus("Server Manager")
;TESTME verify that this block works correctly... seems like it ends up in the winwaitactive block below
SleepClick(20, 400)
SleepSend("{LEFT 10}")
SleepSend("{RIGHT}")
Loop 2
   SleepSend("{DOWN}")
SleepSend("{ENTER}")
SleepClick(845, 226)
SleepSend("{PGDN 50}")

SleepClick(253, 152)
;TESTME end of block to test

;WinWaitActive, , &Add Required Role Services
;WinWaitActive, , &Add Required Features
MultiWinWait("", "&Add Required Role Services", "", "&Add Required Features")
SleepSend("!a")
WinWaitActive, , SMTP Server supports the transfer of e-mail messages
SleepSend("!n")

WinWaitActive, , Introduction to Web Server (IIS), 10
if NOT ERRORLEVEL
   SleepSend("!n")

WinWaitActive, , Select the role services to install, 10
if NOT ERRORLEVEL
   SleepSend("!n")

;WinWaitActive, , &Install
WinWaitActive, , To install the following roles
SleepSend("!i")
WinWaitActive, , Installation succeeded
SleepSend("!o")

;stop and disable W3SVC service (WWW Pub Service)
ShortSleep()
CmdRet_RunReturn("net stop W3SVC")
ShortSleep()
ret := CmdRet_Runreturn("sc config W3SVC start= disabled")
if NOT InStr(ret, "SUCCESS")
   MsgBox, %ret%

WinClose, Server Manager

ForceWinFocus("(cmd.exe|Command Prompt)", "RegEx")
WinClose
}

MakeDesktopShortcuts()
{
;make the shortcuts on the desktop
FileCopy("C:\LynxCD\Server 7.11\Desktop\Log On Admin.url", "C:\Users\Administrator\Desktop\Log On Admin.url")
FileCopy("C:\LynxCD\Server 7.11\Desktop\Log On Security Account.url", "C:\Users\Administrator\Desktop\Log On Security Account.url")
FileCopy("C:\LynxCD\Server 7.11\Desktop\Log On Test Account.url", "C:\Users\Administrator\Desktop\Log On Test Account.url")
}

InstallLynxMessenger()
{
;install lynx messenger (cmd)
command=msiexec.exe /I "C:\LynxCD\Server 7.11\setup\LynxMessengerV4_06.msi" INSTALLDIR="C:\Program Files\LynxMessenger\" SERVERURL=localhost GROUPNAME=Popup PCNAME=Server /quiet
ret := CmdRet_RunReturn(command)

ret := CmdRet_RunReturn("perl checkdb.plx", "C:\inetpub\wwwroot\cgi\")

ret := CmdRet_RunReturn("perl start-MSG-service.pl installall", "C:\inetpub\wwwroot\cgi\")
if NOT InStr(ret, "Finished with 0 errors")
   MsgBox, %ret%
}

EnableIISlocalhostRelay()
{
;enable IIS localhost relay
Run, %windir%\system32\inetsrv\InetMgr6.exe
ForceWinFocus("IIS")
;SleepSeconds(5)
SleepClick(30, 200)
SleepSend("{LEFT 50}")
Loop 4
   SleepSend("{RIGHT}")
SleepSend("{APPSKEY}r")
SleepClick(82, 38)
SleepSend("!e")
SleepSend("!a")
SleepSend("!a")
SleepSend("127.0.0.1{ENTER}")
ForceWinFocus("Relay Restrictions")
SleepSend("{ENTER}")
ForceWinFocus(".SMTP Virtual Server .1. Properties", "Regex")
SleepClick(120, 420)
ForceWinFocus("IIS")
WinClose
}

ChangeDesktopBackground()
{
;change the desktop image
FileCopy("C:\LynxCD\Server 7.11\Setup\New Lynx Screen.jpg", "C:\Users\Administrator\Pictures\LynxBackground.jpg")
SleepSend("#r")
SleepSend("control panel{ENTER}")
SleepSend("change desktop background{ENTER}")
SleepClick(74, 105)
SleepSend("!b")
ForceWinFocus("Browse For Folder")
SleepClick(75, 131)
Loop 8
   SleepSend("{DOWN}")
SleepSend("{ENTER}")
SleepClick(163, 250)
SleepSend("{ENTER}")
SleepSeconds(1)

ForceWinFocus("Control Panel")
WinClose
}

