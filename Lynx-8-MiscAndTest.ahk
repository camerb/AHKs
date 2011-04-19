;stop and disable W3SVC service (WWW Pub Service)
ShortSleep()
CmdRet_RunReturn("net stop W3SVC")
ShortSleep()
ret := CmdRet_Runreturn("sc config AudioSrv start= disabled")
if NOT InStr(ret, "SUCCESS")
   MsgBox, %ret%

;install lynx messenger (cmd)
;TODO waiting on cmd from jason

ret := CmdRet_RunReturn("perl checkdb.plx", "C:\inetpub\wwwroot\cgi\")
;if NOT InStr(ret, "Finished with 0 errors")
   ;MsgBox, %ret%

ret := CmdRet_RunReturn("perl start-MSG-service.pl installall", "C:\inetpub\wwwroot\cgi\")
if NOT InStr(ret, "Finished with 0 errors")
   MsgBox, %ret%
