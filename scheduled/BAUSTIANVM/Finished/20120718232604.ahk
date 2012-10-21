#include FcnLib.ahk


#include FcnLib-Nightly.ahk
addtotrace("green line - launching GoToMeeting (queued at 2012-07-18_23-26-04)")
RunIMacro("URL GOTO=https://www1.gotomeeting.com/join/536324016")
#include FcnLib.ahk
FileMove("C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Running\20120718232604.ahk", "C:\Dropbox\AHKs\scheduled\BAUSTIANVM\Finished\20120718232604.ahk")