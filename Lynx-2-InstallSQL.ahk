#include FcnLib.ahk

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
SleepSend("LYNXGUIDE-R410\Administrators")
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




