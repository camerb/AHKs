#include FcnLib.ahk
#include firefly-FcnLib.ahk
#include firefly-Bot-FcnLib.ahk
#singleinstance force
assignGlobals()

;addtotrace("faint blue line - started " . A_ScriptName)
;addtotrace(" - started " . A_ScriptName)
FireflyCheckin("", "Started")
SleepMinutes(2)

;roll over and play dead (test the check-ins)
;PlayDead()

Loop
{
   ;supervise the other supervisions, watch the watchers
   ;VerifyFireflyCheckin("fireflySupervisionCore.ahk")
   ;VerifyFireflyCheckin("fireflySupervisionCore2.ahk")
   ;VerifyFireflyCheckin("fireflySupervisionCore3.ahk")

   ;VerifyFireflyCheckin("SupervisionCore1.ahk")
   ;VerifyFireflyCheckin("SupervisionCore2.ahk")
   ;VerifyFireflyCheckin("SupervisionCore3.ahk")
   VerifyFireflyCheckin("AutoHotkey.ahk")

   ;note that we got done with a supervision check
   FireflyCheckin("", "Working")
   ;Sleep, 1200
   Sleep, 10000
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
   ahkWhoIsCheckingIn := whoIsCheckingIn
   keyForThisAhk := A_ComputerName . "_" . whoIsCheckingIn

   iniFolder:=GetPath("FireflyCheckinIniFolder")

   lastTickCheckin := iniFolderRead(iniFolder, "TickCheckin", keyForThisAhk)
   lastReadableCheckin := iniFolderRead(iniFolder, "ReadableCheckin", keyForThisAhk) ;only for debugging

   ;if the last checkin was outside of an acceptable interval
   if (lastTickCheckin < FailedCheckinLower OR FailedCheckinUpper < lastTickCheckin)
   {
      ;(this may not be able to save on the vm)
      ;SaveScreenshot("killing-firefly-vm-bot")
      ;SaveScreenshot2()
      debugmsg:="killing unresponsive ahk (faint orange line) "
      debugmsg .= keyForThisAhk
      iniPP(debugmsg)

      ;put a bit more info into the trace
      checkinDiff := CurrentTick - lastTickCheckin
      moreInfoForTrace=(%lastReadableCheckin% %lastTickCheckin% last checkin) (%CurrentTick% now) (%checkinDiff% diff)

      ;disabled the trace messages for now
      addtotrace(debugmsg . " " . moreInfoForTrace)
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

      ;TODO use CloseAhk once it is fixed.
      ;CloseAhk(ahkWhoIsCheckingIn)
      RunAhk(ahkWhoIsCheckingIn)
      RestartEverythingForcefully()
   }
   Sleep, 100
}

RestartEverythingForcefully()
{
   ;Run, ForceReloadAll.exe  ;just gives a lot of dead tray icons
   ;CmdRet("")
   ;RunAhk("StartIdleAhks.ahk")
   SleepSeconds(20)
   Reload()

   ;might want to delete this, kinda useless, right?
   ;it should never get to this point... it should always restart first
   ExitApp
}
