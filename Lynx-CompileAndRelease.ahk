#include FcnLib.ahk
#include C:/Dropbox/AHKs/thirdParty/cmdret.ahk

fatalIfNotThisPc("PHOSPHORUS")

date:=CurrentTime("hyphendate")
releaseDir=C:\Lynx Server Installs\%date%\

;Compile EXEs and put them in the right places
allAhksToCompile=Lynx-Install,Lynx-Upgrade
Loop, parse, allAhksToCompile, CSV
{
   thisNameOnly=%A_LoopField%
   thisAhk=%A_LoopField%.ahk
   terminatorPath=T:\TechSupport\upgrade_files\%thisNameOnly%.exe

   exePath:=CompileAhk(thisAhk)
   FileMove(exePath, terminatorPath, "overwrite")
}

;Create Release Dir
;Copy files to release dir
Loop, C:\Dropbox\AHKs\*.*
{
   if RegExMatch(A_LoopFileName, "^Lynx-")
   {
      dest=%releaseDir%%A_LoopFileName%
      FileCopy(A_LoopFileFullPath, dest)
   }
}
