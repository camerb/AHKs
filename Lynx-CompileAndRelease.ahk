#include FcnLib.ahk
#include thirdParty\notify.ahk

fatalIfNotThisPc("PHOSPHORUS")

date:=CurrentTime("hyphendate")
releaseDir=C:\Lynx Server Installs\%date%\

;FIXME this function doesn't work at all? I thought I tested it
AhkClose("Lynx-InstallBootstrap.ahk")

;Create Release Dir
;Copy files to release dir
Loop, C:\Dropbox\AHKs\*.*
{
   if RegExMatch(A_LoopFileName, "^Lynx-")
   {
      ;check if it compiles
      ;if NOT SuccessfullyCompiles(A_LoopFileFullPath)
         ;fatalErrord("didn't compile", A_LoopFileFullPath)

      ;move the file
      dest=%releaseDir%%A_LoopFileName%
      FileCopy(A_LoopFileFullPath, dest)
   }
}

;Compile EXEs and put them in the right places
allAhksToCompile=Lynx-Upgrade
allAhksToCompile=Lynx-Maint,Lynx-Install,Lynx-Upgrade
;allAhksToCompile=Lynx-InstallBootstrap,Lynx-Install,Lynx-Upgrade,Lynx-Maint
Loop, parse, allAhksToCompile, CSV
{
   thisNameOnly=%A_LoopField%
   thisAhk=%A_LoopField%.ahk
   terminatorPath=T:\TechSupport\%thisNameOnly%.exe

   notify("Compiling Lynx Script: " . thisAhk)
   exePath:=CompileAhk(thisAhk, "MitsiIcon")
   Sleep, 1000
   FileMove(exePath, terminatorPath, "overwrite")
}
notify("Finishing up... almost done")

;delete this after we move all the junk to the ftp site
;exePath:=CompileAhk("C:\Dropbox\AHKs\Lynx-Install.ahk")
exePath:=CompileAhk("Lynx-InstallBootstrap.ahk")
FileMove(exePath, "E:\Lynx-InstallBootstrap.exe", "overwrite")

notify("Finished compiling Lynx scripts")
SleepSeconds(35)
ExitApp
