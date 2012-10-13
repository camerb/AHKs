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
devices=
(
CPU/%A_ComputerName%
SMS/9723429753
email/lynx2@mitsi.com
)
;devices=CPU/%A_ComputerName%

originalMessage := message
messageHtml := StringReplace(message, " ", "<SP>")
messageUrl := StringReplace(message, " ", "%20")
devices := StringReplace(devices, "`n", "<BR>")
url=http://release/cgi/send_sms.plx?ID=CAMERONONLY&Alarm001=On&Message=%messageUrl%

iMacro=
(
VERSION BUILD=7401004 RECORDER=FX
TAB T=1
URL GOTO=http://%server%/cgi/logon.plx?Option=Logout
URL GOTO=http://%server%/login/
TAG POS=1 TYPE=INPUT:TEXT FORM=NAME:Login_Form ATTR=NAME:UserID CONTENT=%user%
SET !ENCRYPTION NO
TAG POS=1 TYPE=INPUT:PASSWORD FORM=NAME:Login_Form ATTR=NAME:Password CONTENT=test
TAG POS=1 TYPE=INPUT:SUBMIT FORM=NAME:Login_Form ATTR=NAME:Enter&&VALUE:Enter<SP>Site
URL GOTO=%server%/cgi/sendmessage.plx
TAG POS=1 TYPE=TEXTAREA FORM=ACTION:/cgi/sendmessage.plx ATTR=NAME:Also CONTENT=%devices%
TAG POS=1 TYPE=INPUT:TEXT FORM=ACTION:/cgi/sendmessage.plx ATTR=NAME:Subject CONTENT=%messageHtml%
TAG POS=1 TYPE=INPUT:SUBMIT FORM=ACTION:/cgi/sendmessage.plx ATTR=NAME:SUBMIT&&VALUE:Send<SP>Message
)

RunProgram("C:\Program Files (x86)\Mozilla Firefox\firefox.exe")
RunIMacro(iMacro)
;UrlDownloadToVar(url)

CustomTitleMatchMode("RegEx")
WinTitle=(Lynx Alert|Lynx Alarm)
WinWait, %WinTitle%, , 10

if ERRORLEVEL
{
   testStatus=FAILED
}
else
{
   testStatus=Passed
   Sleep, 100
   ForceWinFocus(WinTitle)
   Send, ^w
}
testResultPopup=Lynx Test Popup %testStatus%
testInfo=Sent at: %timestamp%
;delog("", testResult, testInfo)
;ForceWinFocus("Lynx Menu - Mozilla Firefox")
;Send, ^w
Loop, 20
{
   WinClose, Lynx Menu - Mozilla Firefox
   Sleep, 10
}
Sleep, 10000
Loop, 20
   ProcessClose("firefox.exe")

SleepMinutes(timeToWait)
Loop, C:\DataExchange\BotEmail\Received\*
{
   ;TODO it might be a good idea to only look through the files that were modified in the last day or so
   thisEmailContents := FileRead(A_LoopFileFullPath)
   if InStr(thisEmailContents, originalMessage)
      sawSMS := true
}

if sawSMS
   testStatus=Passed
else
   testStatus=FAILED
testResultSms=Lynx Test SMS %testStatus%
;testInfo=Sent at: %timestamp%
delog("", testResultSms, testResultPopup, testInfo)

if NOT sawSMS
{
   SendEmail("Lynx SMS Failure", testInfo)
}
ExitApp
