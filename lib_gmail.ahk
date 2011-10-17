#include FcnLib.ahk
#include thirdParty\COM.ahk

;TODO move sReplyTo to be an optional param
/* Proposed Param order:
sSubject, sBody, sAttach,
sTo,
sUsername, sPassword,
sFrom="",
sReplyTo="",
sServer="smtp.gmail.com",
nPort=25, bTLS=true, nSend=2, nAuth=1)
*/
SendGmail(sSubject, sAttach, sTo, sReplyTo, sBody, sUsername, sPassword, sFrom="", sServer="smtp.gmail.com", nPort=25, bTLS=true, nSend=2, nAuth=1)
{
   if (sFrom == "")
      sFrom := username . "@gmail.com"
   if (sReplyTo == "")
      sReplyTo := username . "@gmail.com"

   COM_Init()
   pmsg :=   COM_CreateObject("CDO.Message")
   pcfg :=   COM_Invoke(pmsg, "Configuration")
   pfld :=   COM_Invoke(pcfg, "Fields")

   COM_Invoke(pfld, "Item", "http://schemas.microsoft.com/cdo/configuration/sendusing", nSend)
   COM_Invoke(pfld, "Item", "http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout", 60)
   COM_Invoke(pfld, "Item", "http://schemas.microsoft.com/cdo/configuration/smtpserver", sServer)
   COM_Invoke(pfld, "Item", "http://schemas.microsoft.com/cdo/configuration/smtpserverport", nPort)
   COM_Invoke(pfld, "Item", "http://schemas.microsoft.com/cdo/configuration/smtpusessl", bTLS)
   COM_Invoke(pfld, "Item", "http://schemas.microsoft.com/cdo/configuration/smtpauthenticate", nAuth)
   COM_Invoke(pfld, "Item", "http://schemas.microsoft.com/cdo/configuration/sendusername", sUsername)
   COM_Invoke(pfld, "Item", "http://schemas.microsoft.com/cdo/configuration/sendpassword", sPassword)
   COM_Invoke(pfld, "Update")

   COM_Invoke(pmsg, "From", sFrom)
   COM_Invoke(pmsg, "To", sTo)
   COM_Invoke(pmsg, "ReplyTo", sReplyTo)
   COM_Invoke(pmsg, "Subject", sSubject)
   COM_Invoke(pmsg, "TextBody", sBody)
   Loop, Parse, sAttach, |, %A_Space%%A_Tab%
      COM_Invoke(pmsg, "AddAttachment", A_LoopField)
   COM_Invoke(pmsg, "Send")

   COM_Release(pfld)
   COM_Release(pcfg)
   COM_Release(pmsg)
   COM_Term()
}
