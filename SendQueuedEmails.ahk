#include FcnLib.ahk
#include SendEmailSimple.ahk

Loop, C:\DataExchange\SendEmail\*.txt
{
   file:=A_LoopFileFullPath
   SendEmailFromIni(file)
   FileDelete, %file%
}

SendEmailFromIni(file)
{
   IniRead, sSubject, %file%, pendingEmail, subject
   IniRead, sAttach, %file%, pendingEmail, attach
   IniRead, sTo, %file%, pendingEmail, to
   IniRead, sReplyTo, %file%, pendingEmail, replyto
   IniRead, sBody, %file%, pendingEmail, body
   sBody:=RegExReplace(sBody, "ZZZnewlineZZZ", "`n")

   SendEmailSimple(sSubject, sBody, sAttach, sTo, sReplyTo)
}
