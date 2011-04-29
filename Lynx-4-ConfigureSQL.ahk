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
ForceWinFocus("Locate Database Files - LYNXGUIDE-R410")
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

ret := CmdRet_RunReturn("perl C:\inetpub\wwwroot\cgi\banner.plx", "C:\inetpub\wwwroot\cgi\")
if NOT InStr(ret, "Location: /banner/banner.gif")
   fatalErrord("the banner.plx file did not run correctly")

