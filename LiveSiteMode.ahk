#include FcnLib.ahk

;IniWrite, true, C:\My Dropbox\ahkConfig.ini, DebugAgainAhk, LiveSiteMode
;if FileExist("C:\My Dropbox\ahkConfig.ini")
   ;debug("yup")


;IniRead, LiveSiteMode, C:\My Dropbox\ahkConfig.ini, DebugAgainAhk, LiveSiteMode
;LiveSiteMode := LiveSiteMode == "true"
;if LiveSiteMode
   ;Run, LiveDbWarning.ahk

bool:=prompt("Specify whether LiveSiteMode should be true or false:")
;IniWrite, %bool%, C:\My Dropbox\ahkConfig.ini, DebugAgainAhk, LiveSiteMode

if (bool == "true")
{
   FileCopy, C:\code\bench\fl_bench.json.remote, C:\code\bench\fl_bench.json, 1
   FileCopy, C:\code\epms\cgi\epms_LIVE.json, C:\code\epms\cgi\epms_local.json, 1
}
else
{
   FileCopy, C:\code\bench\fl_bench.json.dev, C:\code\bench\fl_bench.json, 1
   FileCopy, C:\code\epms\cgi\epms_mydev.json, C:\code\epms\cgi\epms_local.json, 1
}

file=C:\My Dropbox\Public\remotewidget-livesitemode.txt
FileDelete, %file%
FileAppend, `n%bool%, %file%
FileAppend, `nft, %file%

;debugBool(0=="0")
;debugBool(1=="1")

ExitApp
