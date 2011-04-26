;stop and disable W3SVC service (WWW Pub Service)
ShortSleep()
CmdRet_RunReturn("net stop W3SVC")
ShortSleep()
ret := CmdRet_Runreturn("sc config AudioSrv start= disabled")
if NOT InStr(ret, "SUCCESS")
   MsgBox, %ret%

;install lynx messenger (cmd)
command=msiexec.exe /I "C:\LynxCD\Server 7.11\setup\LynxMessengerV4_06.msi" INSTALLDIR="C:\Program Files\LynxMessenger\" SERVERURL=localhost GROUPNAME=Popup PCNAME=Server /quiet
ret := CmdRet_RunReturn(command)

ret := CmdRet_RunReturn("perl checkdb.plx", "C:\inetpub\wwwroot\cgi\")

ret := CmdRet_RunReturn("perl start-MSG-service.pl installall", "C:\inetpub\wwwroot\cgi\")
if NOT InStr(ret, "Finished with 0 errors")
   MsgBox, %ret%
