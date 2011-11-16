#include FcnLib.ahk
#include C:/Dropbox/AHKs/thirdParty/cmdret.ahk

fatalIfNotThisPc("PHOSPHORUS")

date:=CurrentTime("hyphendate")
releaseDir=C:\Lynx Server Installs\%date%\
exePath=C:\Dropbox\AHKs\Lynx-Install.exe

;Compile that friggin ahk
FileDelete(exePath)
WaitFileNotExist(exePath)
;Sleep, 2000 ;it seems that a super-long sleep here always works
;Sleep, 300 ;and now that we have a "WaitFileNotExist" in here, it seems to work with a somewhat-short sleep
;Sleep, 100
;trying it without any sleep... seems that the "WaitFileNotExist" should be enough
cmd="C:\Program Files (x86)\AutoHotkey\Compiler\Ahk2Exe.exe" /in "Lynx-Install.ahk" /nodecompile
CmdRet_RunReturn(cmd)
if NOT FileExist(exePath)
   ExitApp

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

;Copy files to flash drive
FileCopy(exePath, "E:\Lynx-Install.exe", "overwrite")

FileDelete(exePath)
