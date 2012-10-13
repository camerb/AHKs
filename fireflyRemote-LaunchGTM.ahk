#include FcnLib.ahk

meetingID := "536324016"
timestamp := CurrentTime("hyphenated")
ahkText=
(
#include FcnLib-Nightly.ahk
addtotrace("green line - launching GoToMeeting (queued at %timestamp%)")
;RunIMacro("URL GOTO=https://www1.gotomeeting.com/join/536324016")
RunProgram("C:\Dropbox\Programs\GoToMeeting\g2m_download.exe")
WinWait, Join a session - GoToMeeting
WinActivate
WinWaitActive
Send, %meetingID%
Send, {ENTER}
)

ScheduleRemoteAhk(ahkText, "baustianvm")
