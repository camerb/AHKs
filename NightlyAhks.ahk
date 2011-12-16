#include FcnLib.ahk
#include FcnLib-Nightly.ahk

;{{{script

A_Debug := true

debug("log grey line", "starting nightly scripts")

if (NOT ProcessExist("dsidebar.exe") AND NOT IsVM())
   RunProgram("dsidebar.exe")

;delete the entire section of the ini for unfinished scripts
ini=gitExempt/%A_ComputerName%.ini
IniDelete(ini, "RunAhkAndBabysit.ahk")

;archive the trace file nightly
if (A_ComputerName = LeadComputer())
   DeleteTraceFile()

;clear out all morning status messages
;I might need to remove this someday and make it only delete some files
FileDeleteDirForceful("C:\Dropbox\AHKs\gitExempt\morning_status\")

if NOT IsVM()
{
   RunThisNightlyAhk(1, "CopyVimSettings.ahk")
   ;hypercam()
   ;RunThisNightlyAhk(7, "UpdateAdobeAcrobatReader.ahk")
}

RunThisNightlyAhk(3, "MintTouch.ahk")
RunThisNightlyAhk(2, "X10HostingForumLogin.ahk")
RunThisNightlyAhk(2, "DeleteDropboxCruft.ahk")
RunThisNightlyAhk(1, "MorningStatus.ahk", "GatherData")
RunThisNightlyAhk(1, "RestartDropbox.ahk")
RunThisNightlyAhk(1, "InfiniteLoop.ahk")
RunThisNightlyAhk(5, "REFPunitTests.ahk", "completedFeaturesOnly")
RunThisNightlyAhk(15, "UnitTests.ahk")

if (A_ComputerName="BAUSTIAN-09PC")
{
   ;hypercam()
   RunThisNightlyAhk(7, "SaveChromeBookmarks.ahk")
   RunThisNightlyAhk(10, "CreateDropboxBackup.ahk")
   RunThisNightlyAhk(3, "PushToGit.ahk")
}

if (A_ComputerName = LeadComputer())
{
   ;tasks that should be performed on phosphorus
   ;unless if the screen is not accessible
   ;  (last logged in via VPN and Windows logged physCompy out)
   ;  we can tell this if a screenshot saved is only half size
   ;  or possibly just check A_ScreenWidth

   RunThisNightlyAhk(7, "UploadAhkDotNetFiles.ahk")
   ;RunThisNightlyAhk(2, "GetPhoneDataUsage.ahk")
   ;hypercam()
   RunThisNightlyAhk(7, "GetSentryBalances.ahk")
   ;hypercam()
   RunThisNightlyAhk(7, "MintGetAccountCsvs.ahk")
   ;hypercam()
   RunThisNightlyAhk(7, "MintGetAccountBalances.ahk")
   ;hypercam()
   ;RunThisNightlyAhk(7, "UsaaGetAccountBalances.ahk") ;removeme?
   ;RunThisNightlyAhk(7, "UsaaGetAccountBalances-IE.ahk") ;removeme?
   ;RunThisNightlyAhk(4, "GetMintNetWorth.ahk")
   RunThisNightlyAhk(2, "ProcessMintExport.ahk")
   RunThisNightlyAhk(2, "MakeNightlyCsvsFromIni.ahk")

   RunThisNightlyAhk(1, "UsaaCheckingBalanceProjection.ahk")
   RunThisNightlyAhk(1, "AddAhkTask.ahk", "copyTasksToFcnLib")
   RunThisNightlyAhk(1, "GetNetWorth.ahk")
   RunThisNightlyAhk(2, "GetSlackInBudget.ahk")
   ;RunAhkAndBabysit("CreateFinancialPieChart.ahk")
   RunThisNightlyAhk(2, "CheckDropboxForConflictedCopies.ahk")
   ;SleepMinutes(15)
   ToggleIMacrosPanel()
}

if (A_ComputerName="PHOSPHORUS")
{
   RunThisNightlyAhk(1, "UpdatePerlPackages.ahk")
   ;looks like FF4 doesn't need a nightly restart (no longer a RAM hog)
   ;RunAhkAndBabysit("RestartFirefox.ahk")
   ;SleepMinutes(1)
   RunThisNightlyAhk(1, "UpdatePidginImStatus.ahk")
   RunThisNightlyAhk(1, "GitRefreshRemote.ahk")
}

if (A_ComputerName="PHOSPHORUSVM")
{
   RunThisNightlyAhk(5, "DeleteDropboxCruft.ahk")
}

;===done with nightly tasks... lets start things back up again
RunThisNightlyAhk(1, "StartIdleAhks.ahk")
ProcessCloseAll("firefoxPortable.exe")

;RunThisNightlyAhk(2, "MoveMouseAcrossEntireScreen.ahk")

if (A_ComputerName="PHOSPHORUS")
{
   ;this needs a little bit of click-around time
   ;commented this out cause I'm in C-4's office all the time now
   RunThisNightlyAhk(2, "LaunchPidgin.ahk")
}

;make a list of all the ahks that didn't end gracefully
;TODO switch this to IniListAllKeys()
Loop, C:\Dropbox\AHKs\*.ahk
{
   time:=IniRead(ini, "RunAhkAndBabysit.ahk", A_LoopFileName)
   if (time <> "ERROR")
   {
      text=AHK failed to end gracefully on %A_ComputerName%: %A_LoopFileName% (Started at %time%)
      file=gitExempt\morning_status\graceful-%A_ComputerName%.txt
      FileAppendLine(text, file)
      IniDelete(ini, "RunAhkAndBabysit.ahk", A_LoopFileName)
   }
}

debug("log grey line", "finished nightly scripts")
ExitApp
;}}}

;{{{ functions
RunThisNightlyAhk(waitTimeInMinutes, ahkToRun, params="")
{
   ;TODO put this in a separate script, do not compile (2 new ahks total)
   ;TODO write to ini, runwait, delete from ini
   ;TODO morning status sender will check to see if any ini records remain
   ;TODO another ahk will sit there to babysit, or perhaps we can put that in persistent

   global A_Debug
   ;A_Debug := true

   ;if A_Debug
      debug("", "nightly ahks: starting this ahk", ahkToRun)

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

   ;close everything that it possibly could have launched
   CloseAllAhks(A_ScriptName)

   ;close just the one we launched
   ;AhkClose(ahkToRun)

   ;if A_Debug
      debug("", "nightly ahks: finished this ahk", ahkToRun)
}

hypercam()
{
   if (A_ComputerName="BAUSTIAN-09PC")
   {
      RunAhk("HyperCamRecord.ahk")
      SleepSeconds(10)
   }
}
;}}}

