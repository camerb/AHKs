#include FcnLib.ahk


#include FcnLib-Nightly.ahk
addtotrace("green line - launching GoToMeeting (queued at 2012-07-18_23-39-11)")
;RunIMacro("URL GOTO=https://www1.gotomeeting.com/join/536324016")
RunProgram("C:\Dropbox\Programs\GoToMeeting\g2m_download.exe")
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120718233911.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120718233911.ahk")