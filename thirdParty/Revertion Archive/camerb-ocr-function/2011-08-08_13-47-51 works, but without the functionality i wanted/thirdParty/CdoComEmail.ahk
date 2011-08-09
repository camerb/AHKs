;http://www.autohotkey.com/forum/topic39797.html

sFrom     := "Mail_Address_Of_Sender"
sTo       := "Mail_Address_Of_Receipient"
sSubject  := "Message_Subject"
sBody     := "Message_Text"
sAttach   := "Path_Of_Attachment" ; can add multiple attachments, the delimiter is |

sServer   := "smtp.gmail.com" ; specify your SMTP server
nPort     := 465 ; 25
bTLS      := True ; False
nSend     := 2   ; cdoSendUsingPort
nAuth     := 1   ; cdoBasic
sUsername := "your_username"
sPassword := "your_password"

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
COM_Invoke(pmsg, "Subject", sSubject)
COM_Invoke(pmsg, "TextBody", sBody)
Loop, Parse, sAttach, |, %A_Space%%A_Tab%
COM_Invoke(pmsg, "AddAttachment", A_LoopField)
COM_Invoke(pmsg, "Send")

COM_Release(pfld)
COM_Release(pcfg)
COM_Release(pmsg)
COM_Term()