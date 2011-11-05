#include FcnLib.ahk


   ret := CmdRet_RunReturn("perl start-MSG-service.pl installall", "C:\inetpub\wwwroot\cgi\")
   debug("errord nolog", ret)
   if NOT InStr(ret, "Finished with 0 errors")
      fatalErrord("perl start-MSG-service.pl installall", "this command seemed to fail... it returned:", ret)
