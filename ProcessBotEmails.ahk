#include FcnLib.ahk
#include thirdParty/CmdRet.ahk

;recieve emails macro

;first, check the rss/xml page to see if there are new messages
joe:=SexPanther()
BotGmailUrl=https://cameronbaustianbot:%joe%@gmail.google.com/gmail/feed/atom
ini=C:\DataExchange\BotEmail\Received.ini

gmailPage:=urldownloadtovar(url)
RegExMatch(gmailPage, "<fullcount>(\d+)</fullcount>", gmailPage)
RegExMatch(gmailPage, "\d+", number)

if (number == 0 || number == "")
   number == ""

if (number != "")
{
   ;then, save all the recent emails to the hard drive
   today:=CurrentTime()
   twoDaysAgo:=dt
   twoDaysAgo += -2, days
   twoDaysAgo := FormatTime(twoDaysAgo, "yyyyMMdd")
   today := FormatTime(today, "yyyyMMdd")

   command="C:\Program Files\GmailBackup\gmail-backup.exe" backup "C:\DataExchange\BotEmail\Received" cameronbaustianbot@gmail.com %joe% %twoDaysAgo% %today%
   ret:=CmdRet_RunReturn(command)
   ;delog(ret)

   ;processing the backup that just came in
   Loop, C:\DataExchange\BotEmail\Received\*.eml
   {
      if (IniRead(ini, "default", A_LoopFileName) == "ERROR")
      {
         examineEmail(A_LoopFileFullPath)
         IniWrite(ini, "default", A_LoopFileName, "true")
      }
   }
}

examineEmail(emailFile)
{
   findingSubject:=true
   Loop, read, %emailFile%
   {
      thisLine:=A_LoopReadLine
      if processingMessage
      {
         if (thisLine == boundary)
         {
            ;success, finished
            debug(subjectLine, emailContents)
            break
         }
         else if NOT firstLineHasBeenRead
            firstLineHasBeenRead:=true
         else
            emailContents .= thisLine . "`n"
      }
      else if findingStart
      {
         if (thisLine == boundary)
            processingMessage:=true
      }
      else if lookingForMarker
      {
         if RegExMatch(thisLine, "Content-Type.*boundary=(.*)$", result)
         {
            boundary := "--" . result1
            findingStart:=true
         }
         else if (thisLine == "From: Bot Baustian <cameronbaustianbot@gmail.com>")
            break
      }
      else if findingSubject
      {
         if RegExMatch(thisLine, "Subject\: (.*)$", result)
         {
            subjectLine:=result1
            lookingForMarker:=true
         }
      }
   }
}

;GetGmailMessageCount(url, prettyName)
;{
   ;gmailPage:=urldownloadtovar(url)
   ;RegExMatch(gmailPage, "<fullcount>(\d+)</fullcount>", gmailPage)
   ;RegExMatch(gmailPage, "\d+", number)
   ;;number := getXmlElement(gmailPage, "fullcount")

   ;if (number == 0 || number == "")
      ;return ""
   ;returned=%prettyName% has %number% new emails`n
   ;return returned
;}
