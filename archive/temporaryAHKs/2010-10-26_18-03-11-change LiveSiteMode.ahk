#include FcnLib.ahk

;IniWrite, true, C:\Dropbox\ahkConfig.ini, DebugAgainAhk, LiveSiteMode
;if FileExist("C:\Dropbox\ahkConfig.ini")
   ;debug("yup")


;IniRead, LiveSiteMode, C:\Dropbox\ahkConfig.ini, DebugAgainAhk, LiveSiteMode
;LiveSiteMode := LiveSiteMode == "true"
;if LiveSiteMode
   ;Run, LiveDbWarning.ahk

bool:=prompt("Specify whether LiveSiteMode should be true or false:")
IniWrite, %bool%, C:\Dropbox\ahkConfig.ini, DebugAgainAhk, LiveSiteMode

;debugBool(0=="0")
;debugBool(1=="1")

ExitApp
