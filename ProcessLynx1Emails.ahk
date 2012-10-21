#include FcnLib.ahk
#include thirdParty/CmdRet.ahk

;recieve emails macro

;first, check the rss/xml page to see if there are new messages
;emailUsername=lynxnonautomatedemails
DownloadEmails("lynxnonautomatedemails")
ExitApp

DownloadEmails(emailUsername)
{
   joe:=SexPanther()
   BotGmailUrl=https://%emailUsername%:%joe%@gmail.google.com/gmail/feed/atom
   savePath=C:\DataExchange\BotEmail\%emailusername%\Received
   ini=%savePath%.ini

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
      exePath="C:\Dropbox\Programs\GmailBackup\gmail-backup.exe"
      EnsureDirExists(savePath)
      command=%exePath% backup %savePath% %emailUsername%@gmail.com %joe% %start% %end%
      ret:=CmdRet_RunReturn(command)
      ;delog(ret)
      ;debug(command)

      ;processing the backup that just came in
      Loop, %savePath%\*.eml
      {
         if (IniRead(ini, "default", A_LoopFileName) == "ERROR")
         {
            IniWrite(ini, "default", A_LoopFileName, "true")
            Sleep, 100
            examineEmail(A_LoopFileFullPath)
         }
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

      ;very rough ways to process the message quickly (new as of 2012-10-16)
      if ( RegExMatch(thisLine, "^From: ") AND NOT rawFrom )
         rawFrom := thisLine
      if ( RegExMatch(thisLine, "^To: ") AND NOT rawTo )
         rawTo := thisLine
      if ( RegExMatch(thisLine, "^Subject: ") AND NOT rawSubject )
         rawSubject := thisLine

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
         {
            ;this is not an incoming email, don't process it
            thisEmailIsOutbound:=true
            return
         }
         ;else if (thisLine == "From: `"(972) 342-9753`" <19724540889.19723429753.Pzkq8Mxk4c@txt.voice.google.com>")
         ;{
            ;;this was sent from my cell phone
         ;}
         ;else if InStr(thisLine == "******Forwarded by Actions******")
         ;{
            ;;this message was received by my cell phone and forwarded to the bot
            ;thisMessageOriginallyReceivedByMyPhone:=true
         ;}
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
   debug(rawFrom, rawTo, rawSubject)
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
   if InStr(emailMessage, "Say hello")
   {
      FastNotification("Hello!")
   }
}
