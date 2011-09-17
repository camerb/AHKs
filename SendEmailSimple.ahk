#include FcnLib.ahk
#include thirdParty\COM.ahk
#include SendEmailSimpleLib.ahk

;Send an email without doing any of the complex queuing stuff
SendEmailSimple(sSubject, sBody, sAttach="", sTo="cameronbaustian@gmail.com", sReplyTo="cameronbaustian+bot@gmail.com")
{
   item .= SexPanther()

   sFrom     := "cameronbaustian@gmail.com"

   sServer   := "smtp.gmail.com" ; specify your SMTP server
   nPort     := 465 ; 25
   bTLS      := True ; False
   nSend     := 2   ; cdoSendUsingPort
   nAuth     := 1   ; cdoBasic
   sUsername := "cameronbaustian"
   sPassword := item

   SendTheFrigginEmail(sSubject, sAttach, sTo, sReplyTo, sBody, sUsername, sPassword, sFrom, sServer, nPort, bTLS, nSend, nAuth)
}
