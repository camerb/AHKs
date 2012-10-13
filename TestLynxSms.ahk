#include FcnLib.ahk
#include FcnLib-Nightly.ahk

;Test Lynx

;timeToWait := 0
;timeToWait := 2
timeToWait := 5

server=release
user=test
timestamp:=CurrentTime("hyphenated")
message=Testing Lynx System - %timestamp%
message=%timestamp% antelope
;message=This is a message
devices=SMS/9723429753

originalMessage := message
messageHtml := StringReplace(message, " ", "<SP>")
messageUrl := StringReplace(message, " ", "%20")
devices := StringReplace(devices, "`n", "<BR>")
url=http://%server%/cgi/send_sms.plx?ID=CAMERONONLY&Alarm001=On&Message=%messageUrl%

UrlDownloadToVar(url)
iniPP("Sent Lynx SMS")

SleepMinutes(timeToWait)
Loop, C:\DataExchange\BotEmail\Received\*
{
   ;TODO it might be a good idea to only look through the files that were modified in the last day or so
   ;today only seems like a reasonable decision
   today := CurrentTime("date")
   if NOT InStr(A_LoopFileTimeModified, today)
      continue

   thisEmailContents := FileRead(A_LoopFileFullPath)
   if InStr(thisEmailContents, originalMessage)
      sawSMScount++
      ;sawSMS := true
   Sleep, 100
}

if NOT sawSmsCount
   testStatus=FAILED
if (sawSmsCount == "1")
   testStatus=Passed
else
   testStatus=DOUBLED (%sawSMSCount%)

;format message
testResultSms=Lynx Test SMS %testStatus%
testInfo=Sent at: %timestamp% %testStatus%

;send reports
iniPP(testStatus)
if (testStatus != "Passed")
{
   subject:="Lynx SMS Failure "
   fullMessage:=subject . testInfo
   SendEmail(subject, testInfo)
   FastNotification(fullMessage)
}
ExitApp
