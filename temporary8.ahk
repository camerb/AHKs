#include FcnLib.ahk

delog("grey line")
Loop, 1000
{
   if (GetPerlVersion() == "5.8.9")
      passed++
   else
      failed++
   total++
   delog("green line", passed, failed, total)
}
ExitApp

;joe:=LynxDatabaseQuery("select * from setup where [TYPE] = 'companyname'", "Type,Value")
;joe:=LynxDatabaseQuery("select * from setup where [TYPE] = 'ID'", "Type,Value")
;joe:=LynxDatabaseQuery("select * from users", "CompanyName,Name")
CreateSmsKey()
InstallSmsKey()
joe:=GetSmsKey()
debug("notimeout", "asdf" . joe . "asdf")
;"select * from setup where [TYPE] = 'c ;ompanyname'", "Type,Value"
;c:\Inetpub\wwwroot\cgi>perl get_query.plx "select * from setup where [TYPE] = 'c ;ompanyname'" Type,Value
;CompanyName     T-800

ExitApp
#include Lynx-Upgrade.ahk

