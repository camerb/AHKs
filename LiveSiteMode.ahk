#include FcnLib.ahk

;IniWrite, true, C:\Dropbox\ahkConfig.ini, DebugAgainAhk, LiveSiteMode
;if FileExist("C:\Dropbox\ahkConfig.ini")
   ;debug("yup")


;IniRead, LiveSiteMode, C:\Dropbox\ahkConfig.ini, DebugAgainAhk, LiveSiteMode
;LiveSiteMode := LiveSiteMode == "true"
;if LiveSiteMode
   ;Run, LiveDbWarning.ahk

bool:=prompt("Specify whether LiveSiteMode should be true or false:")
;IniWrite, %bool%, C:\Dropbox\ahkConfig.ini, DebugAgainAhk, LiveSiteMode

if (bool == "true")
{
   FileCopy, C:\code\bench\fl_bench.json.remote, C:\code\bench\fl_bench.json, 1
   FileCopy, C:\code\epms\cgi\epms_LIVE.json, C:\code\epms\cgi\epms_local.json, 1
   message=LIVE SITE MODE
}
else
{
   FileCopy, C:\code\bench\fl_bench.json.dev, C:\code\bench\fl_bench.json, 1
   FileCopy, C:\code\epms\cgi\epms_mydev.json, C:\code\epms\cgi\epms_local.json, 1
   message=dev mode
}

file=C:\Dropbox\Public\remotewidget-livesitemode.txt
FileDelete, %file%
FileAppend, %message%`n, %file%

;debugBool(0=="0")
;debugBool(1=="1")

ExitApp
