#include FcnLib.ahk

RunThisNightlyAhk(3, "PushToGit.ahk")

RunThisNightlyAhk(1, "CopyVimSettings.ahk")
RunThisNightlyAhk(1, "SyntaxError.ahk")


RunThisNightlyAhk(waitTimeInMinutes, ahkToRun, params="")
{
   ;TODO put this in a separate script, do not compile (2 new ahks total)
   ;TODO write to ini, runwait, delete from ini
   ;TODO morning status sender will check to see if any ini records remain
   ;TODO another ahk will sit there to babysit, or perhaps we can put that in persistent

   ;quote="
   ;ahkToRun := EnsureStartsWith(ahkToRun, quote)
   ;ahkToRun := EnsureEndsWith(ahkToRun, quote)
   ;params := EnsureStartsWith(params, quote)
   ;params := EnsureEndsWith(params, quote)

   command=AutoHotkey.exe RunAhkAndBabysit.ahk "%ahkToRun%" "%params%" "wait"
   ;if InStr(options, "wait")
      ;RunWait %command%
   ;else
      Run %command%

   SleepMinutes(waitTimeInMinutes)
   ForceReloadAll()
}
