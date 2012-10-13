#include FcnLib.ahk
#include Lynx-FcnLib.ahk
#include Lynx-ProcedureParts.ahk
Lynx_MaintenanceType := "install"

;minimalist startup
msg:="Starting LynxGuide Server Install Bootstrap"
lynx_log(msg)
notify(msg)

;downloading file
installExePath:="C:\Users\Administrator\Desktop\Lynx-Install.exe"
tempInstallExePath:="C:\temp\lynx_upgrade_files\Lynx-Install.exe"

lynx_log("Deleting old copies of the installer")
FileDelete(installExePath)
FileDelete(tempInstallExePath)

lynx_log("Downloading Installer")
DownloadLynxFile("Lynx-Install.exe")

lynx_log("Copying installer")
FileCopy(tempInstallExePath, installExePath, "overwrite")

;running file (not as administrator) (not recommended)
;lynx_log("running lynx installer")
;Run, %installExePath%

;tell them to run the file
lynx_log("Telling them to run the lynx installer")
notify("Please right-click on the Lynx Installer on the Desktop and say 'Run as administrator'")

;wait for the file to finish running and then delete it
;TODO REMOVEME ASAP
WaitForInstallerToFinish()
FileDelete(installExePath)
;TODO REMOVEME ASAP

;exit
lynx_log("exiting install bootstrap")
SleepSeconds(30)
ExitApp

WaitForInstallerToFinish()
{
   Loop
   {
      if ProcessExist("Lynx-Install.exe")
         break
      Sleep, 100
   }
   SleepSeconds(10)
   Loop
   {
      if NOT ProcessExist("Lynx-Install.exe")
         break
      Sleep, 100
   }
   SleepSeconds(10)
}
