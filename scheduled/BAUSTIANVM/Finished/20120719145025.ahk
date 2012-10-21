#include FcnLib.ahk


#include FcnLib-Nightly.ahk
addtotrace("green line - launching GoToMeeting (queued at 2012-07-19_14-50-25)")
;RunIMacro("URL GOTO=https://www1.gotomeeting.com/join/536324016")
RunProgram("C:\Dropbox\Programs\GoToMeeting\g2m_download.exe")
WinWait, Join a session - GoToMeeting
WinActivate
WinWaitActive
Send, 536324016
Send, {ENTER}
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120719145025.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120719145025.ahk")