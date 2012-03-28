;#singleinstance force
#include FcnLib.ahk
#include Lynx-FcnLib.ahk
#include Lynx-ProcedureParts.ahk
;#include Lynx-UpgradeParts.ahk
;#singleinstance force
Lynx_MaintenanceType := "install"

;minimalist startup
msg:="Starting LynxGuide Server Install Bootstrap"
lynx_log(msg)
notify(msg)

;downloading file
installExePath:="C:\temp\lynx_upgrade_files\Lynx-Install.exe"
FileDelete(installExePath)
DownloadLynxFile("Lynx-Install.exe")
;WaitFileExist(installExePath) ;i don't think i need this anymore

;running file
lynx_log("running lynx installer")
Run, %installExePath%

;exit
lynx_log("exiting install bootstrap")
ExitApp
