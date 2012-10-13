#include FcnLib.ahk
#include firefly-FcnLib.ahk
#include firefly-Bot-FcnLib.ahk
#singleinstance force
assignGlobals()
bot:=true

if NOT IsVM()
   fatalerrord("this macro is only for VMs")

;addtotrace("faint blue line - started " . A_ScriptName)
;addtotrace(" - started " . A_ScriptName)
FireflyCheckin("SupervisionCore", "Started")

;roll over and play dead (test the check-ins)
;PlayDead()

Loop
{
   ;supervise
   VerifyFireflyCheckin("fireflyFeesBot.ahk")
   VerifyFireflyCheckin("fireflyBotHelper.ahk")

   ;supervise the other supervisions, watch the watchers
   VerifyFireflyCheckin("fireflySupervisionCore.ahk")
   ;VerifyFireflyCheckin("fireflySupervisionCore2.ahk")
   ;VerifyFireflyCheckin("fireflySupervisionCore3.ahk")
   VerifyFireflyCheckin("AutoHotkey.ahk")

   ;note that we got done with a supervision check
   FireflyCheckin("SupervisionCore", "Working")
   Sleep, 1200
}

;END OF THE STUFF FOR THIS AHK
ExitApp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;if bot or helper haven't said hi within a certain period of time, kill them and restart them
VerifyFireflyCheckin(whoIsCheckingIn)
{
   ;Two minutes, in MS (tickcount)
   CheckinInterval := 2*60*1000

   CurrentTick := A_TickCount
   FailedTickCheckinTime := CurrentTick - CheckinInterval
   FailedCheckinLower := CurrentTick - CheckinInterval
   FailedCheckinUpper := CurrentTick + CheckinInterval

   iniFolder:=GetPath("FireflyCheckinIniFolder")

   lastTickCheckin := iniFolderRead(iniFolder, "TickCheckin", whoIsCheckingIn)
   lastReadableCheckin := iniFolderRead(iniFolder, "ReadableCheckin", whoIsCheckingIn) ;only for debugging

   ;if the last checkin was outside of an acceptable interval
   if (lastTickCheckin < FailedCheckinLower OR FailedCheckinUpper < lastTickCheckin)
   {
      ;(this may not be able to save on the vm)
      ;SaveScreenshot("killing-firefly-vm-bot")
      SaveScreenshot2()
      debugmsg:="killing unresponsive vm-ahk (faint orange line) "
      debugmsg .= whoIsCheckingIn
      iniPP(debugmsg)

      ;put a bit more info into the trace
      checkinDiff := CurrentTick - lastTickCheckin
      moreInfoForTrace=(%lastReadableCheckin% %lastTickCheckin% last checkin) (%CurrentTick% now) (%checkinDiff% diff)

      ;disabled the trace messages for now
      ;addtotrace(debugmsg . " " . moreInfoForTrace)
      ;HowManyAhksAreRunning()

      ;TODO restart that specific AHK, and come back to it later
      ;if NOT InStr(
      ;if ahk is not having trouble
      ;{
         ;RestartThatAhk
         ;Make a note it is having trouble
      ;}
      ;else - ahk is having trouble
      ;{
         ;RestartEverythingForcefully()
      ;}

      RestartEverythingForcefully()
   }
   Sleep, 100
}

GetRidOfDeadTrayIcons()
{
   ;move mouse to get rid of lame dead icons in the tray
   WinActivate, Program Manager
   MouseMove, 720, 944, 20
   MouseMove, 1080, 944, 80
   MouseMove, 1280, 944, 80
}

RestartEverythingForcefully()
{
   GetRidOfDeadTrayIcons()
   Run, ForceReloadAll.exe  ;just gives a lot of dead tray icons
   ;SleepSeconds(20)
   Reload()

   ;might want to delete this, kinda useless, right?
   ExitApp
}
