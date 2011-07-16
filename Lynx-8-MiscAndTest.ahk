;make the shortcuts on the desktop
FileCopy("C:\LynxCD\Server 7.11\Desktop\Log On Admin.url", "C:\Users\Administrator\Desktop\Log On Admin.url")
FileCopy("C:\LynxCD\Server 7.11\Desktop\Log On Security Account.url", "C:\Users\Administrator\Desktop\Log On Security Account.url")
FileCopy("C:\LynxCD\Server 7.11\Desktop\Log On Test Account.url", "C:\Users\Administrator\Desktop\Log On Test Account.url")

;install lynx messenger (cmd)
command=msiexec.exe /I "C:\LynxCD\Server 7.11\setup\LynxMessengerV4_06.msi" INSTALLDIR="C:\Program Files\LynxMessenger\" SERVERURL=localhost GROUPNAME=Popup PCNAME=Server /quiet
ret := CmdRet_RunReturn(command)

ret := CmdRet_RunReturn("perl checkdb.plx", "C:\inetpub\wwwroot\cgi\")

ret := CmdRet_RunReturn("perl start-MSG-service.pl installall", "C:\inetpub\wwwroot\cgi\")
if NOT InStr(ret, "Finished with 0 errors")
   MsgBox, %ret%

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

