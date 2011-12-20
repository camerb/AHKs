#include FcnLib.ahk

;joe:=LynxDatabaseQuery("select * from setup where [TYPE] = 'companyname'", "Type,Value")
;joe:=LynxDatabaseQuery("select * from setup where [TYPE] = 'ID'", "Type,Value")
joe:=LynxDatabaseQuery("select * from users", "CompanyName,Name")
debug("notimeout", joe)
;"select * from setup where [TYPE] = 'c ;ompanyname'", "Type,Value"
;c:\Inetpub\wwwroot\cgi>perl get_query.plx "select * from setup where [TYPE] = 'c ;ompanyname'" Type,Value
;CompanyName     T-800

ExitApp
#include Lynx-Upgrade.ahk

