#include FcnLib.ahk

;automatic updater clicker

;might just want to get rid of this, since I'm in the habit of clicking both anyway
;if ( FileExist("C:\Dropbox\AHKs\Lynx-Update.ahk") AND A_ComputerName = "T-800" )
;{
   ;if NOT IsAhkCurrentlyRunning("Lynx-Update.ahk")
   ;{
      ;SleepMinutes(1)
      ;RunAhk("Lynx-Update.ahk")
   ;}
;}

;if (A_ComputerName = "release")
;{
   ;delete old updater
   ;download updater
   ;run updater
;}

TimeToStop := CurrentTimePlus(20000) ; + 2 hours
Loop
{
   if ForceWinFocusIfExist("Lynx Upgrade Assistant")
      Send, {ENTER}
      ;Click()

   if ( TimeToStop < CurrentTime() )
      ExitApp

   SleepSeconds(5)
}
ExitApp
