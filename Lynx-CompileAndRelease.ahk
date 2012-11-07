#include FcnLib.ahk
#include thirdParty\notify.ahk

fatalIfNotThisPc("PHOSPHORUS")

;release new things first...
notify("Compiling AutomateUpdate")
CompileAhk("Lynx-AutomateUpdate.ahk")
FileDelete("\\release\c$\Users\Public\Documents\Lynx-AutomateUpdate.exe")
FileMove("Lynx-AutomateUpdate.exe", "\\release\c$\Users\Public\Documents\Lynx-AutomateUpdate.exe", "overwrite")

notify("Compiling SugarSpy")
CompileAhk("Sugar.ahk")
FileMove("Sugar.exe", "soffice.exe")

;move on to the main parts of the release
date:=CurrentTime("hyphendate")
releaseArchiveDir=C:\Lynx Server Installs\%date%\

;FIXME this function doesn't work at all? I thought I tested it
;AhkClose("Lynx-InstallBootstrap.ahk")
;FileCopy("C:\Dropbox\AHKs\Lynx-Upgrade.ahk", "C:\Dropbox\AHKs\Lynx-Update.ahk")

if FileExist("C:\Dropbox\AHKs\Lynx-Upgrade.ahk")
   errord("Lynx-Upgrade.ahk exists, the new naming convention is Lynx-Update.ahk (Are you from the past?)")

;Create Release Dir
;Copy files to release dir
Loop, C:\Dropbox\AHKs\*.*
{
   if RegExMatch(A_LoopFileName, "^Lynx-")
   {
      ;TODO check if it compiles
      ;if NOT SuccessfullyCompiles(A_LoopFileFullPath)
         ;fatalErrord("didn't compile", A_LoopFileFullPath)

      ;move the file
      dest=%releaseArchiveDir%%A_LoopFileName%
      FileCopy(A_LoopFileFullPath, dest)
   }
}

;Compile EXEs and put them in the right places
allAhksToCompile=Lynx-Upgrade,Lynx-Update
allAhksToCompile=Lynx-Maint,Lynx-Install,Lynx-Upgrade,Lynx-Update
allAhksToCompile=Lynx-Maint,Lynx-Install,Lynx-Update
;allAhksToCompile=Lynx-InstallBootstrap,Lynx-Install,Lynx-Upgrade,Lynx-Maint
Loop, parse, allAhksToCompile, CSV
{
   thisNameOnly=%A_LoopField%
   thisAhk=%A_LoopField%.ahk
   thisExe=%A_LoopField%.exe
   terminatorPath=T:\TechSupport\%thisExe%
   releaseArchivePath=%releaseArchiveDir%%thisExe%

   notify("Compiling Lynx Script: " . thisAhk)
   exePath:=CompileAhk(thisAhk, "MitsiIcon")
   Sleep, 1000
   FileCopy(exePath, releaseArchivePath, "overwrite")
   FileCopy(exePath, terminatorPath, "overwrite")
   FileDelete(exePath)
}
notify("Finishing up... almost done")

;delete this after we move all the junk to the ftp site
;exePath:=CompileAhk("C:\Dropbox\AHKs\Lynx-Install.ahk")
exePath:=CompileAhk("Lynx-InstallBootstrap.ahk")
FileMove(exePath, "E:\Lynx-InstallBootstrap.exe", "overwrite")
FileDelete(exePath)

notify("Finished compiling Lynx scripts")
SleepSeconds(35)
ExitApp
