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
   end:=CurrentTime()
   start:=end
   end += -2, days
   start += 1, days
   start := FormatTime(start, "yyyyMMdd")
   end := FormatTime(end, "yyyyMMdd")

   exePath="C:\Program Files (x86)\GmailBackup\gmail-backup.exe"
   ;exePath="C:\Program Files\GmailBackup\gmail-backup.exe"
   command=%exePath% backup "C:\DataExchange\BotEmail\Received" cameronbaustianbot@gmail.com %joe% %start% %end%
   ret:=CmdRet_RunReturn(command)
   ;delog(ret)
   ;debug(command)

   ;processing the backup that just came in
   Loop, C:\DataExchange\BotEmail\Received\*.eml
   {
      if (IniRead(ini, "default", A_LoopFileName) == "ERROR")
      {
         IniWrite(ini, "default", A_LoopFileName, "true")
         Sleep, 100
         examineEmail(A_LoopFileFullPath)
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
            processSingleEmail(subjectLine, emailContents)
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

ProcessSingleEmail(emailSubject, emailMessage)
{
   delog(emailSubject, emailMessage)
   if InStr(emailSubject, "Scheduled AHK")
   {
      timestamp:=CurrentTime()
      filename=scheduled/%A_ComputerName%/%timestamp%.ahk
      FileAppendLine(emailMessage, filename)
      ;TODO send it to an archive file as well
   }
}
