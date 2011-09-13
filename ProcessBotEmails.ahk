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
   end   := AddDatetime(CurrentTime(), 1, "days")
   start := AddDatetime(CurrentTime(), -2, "days")
   start := FormatTime(start, "yyyyMMdd")
   end := FormatTime(end, "yyyyMMdd")

   ;TODO find a way to use RunProgram and pass in params, and specify to use CmdRet to run the program
   ;exePath="C:\Program Files (x86)\GmailBackup\gmail-backup.exe"
   exePath="C:\Program Files\GmailBackup\gmail-backup.exe"
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

;TODO rewrite this whole friggin thing!!! email formats are just plain inconsistent
examineEmail(emailFile)
{
   ;get the first boundary and the first subject
   Loop, read, %emailFile%
   {
      thisLine:=A_LoopReadLine
      if NOT boundary AND RegExMatch(thisLine, "Content-Type.*boundary=(.*)$", result)
         boundary := "--" . result1
      if NOT subjectLine AND RegExMatch(thisLine, "Subject\: (.*)$", result)
         subjectLine:=result1
   }

   ;get the email message
   ;delog(boundary, subjectLine)
   Loop, read, %emailFile%
   {
      thisLine:=A_LoopReadLine
      if processingMessage
      {
         if (thisLine == boundary)
         {
            ;success, finished
            ;errord("nolog", "finished processing email", emailfile)
            processSingleEmail(subjectLine, emailContents)
            ;break
            return
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
            return
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
   ;FIXME haxor I was trying to avoid regexes, but I may need to use them after all
   emailContents .= thisLine . "`n"
   ;errord("nolog", "died before finishing processing email", subjectLine, emailContents)
   processSingleEmail(subjectLine, emailContents)
}

ProcessSingleEmail(emailSubject, emailMessage)
{
   ;delog("blue line", emailSubject, emailMessage)
   ;errord("nolog", emailSubject, emailMessage)
   if InStr(emailSubject, "Scheduled AHK")
   {
      ;delog("yellow line", "saw a sched ahk")
      timestamp:=CurrentTime()
      filename=scheduled/%A_ComputerName%/%timestamp%.ahk
      archiveFile=archive/cloudAHKs/%timestamp%-%A_ComputerName%.ahk
      FileAppendLine("#include FcnLib.ahk", filename)
      FileAppendLine("DeleteTraceFile()", filename)
      FileAppendLine("AddToTrace(""running scheduled ahk from the cloud"")", filename)
      FileAppendLine(emailMessage, filename)
      FileCopy(filename, archiveFile)
      ;TODO send it to an archive file as well
   }
}
