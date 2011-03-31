#include FcnLib.ahk

debug("log grey line", "starting nightly scripts")

if (A_ComputerName = LeadComputer())
   DeleteTraceFile()

if NOT IsVM()
{
   RunAhkAndBabysit("MintTouch.ahk")
   SleepMinutes(1)
   RunAhkAndBabysit("CopyVimSettings.ahk")
   SleepMinutes(1)
}

RunAhkAndBabysit("MorningStatus-GatherData.ahk")
SleepMinutes(1)
RunAhkAndBabysit("RestartDropbox.ahk")
SleepMinutes(1)
RunAhk("REFPunitTests.ahk", "completedFeaturesOnly")
SleepMinutes(5)
RunAhkAndBabysit("UnitTests.ahk")
SleepMinutes(15)

if (A_ComputerName="BAUSTIAN-09PC")
{
   RunAhkAndBabysit("SaveChromeBookmarks.ahk")
   SleepMinutes(1)
   RunAhkAndBabysit("CreateDropboxBackup.ahk")
   SleepMinutes(10)
   RunAhkAndBabysit("PushToGit.ahk")
   SleepMinutes(3)
}

if (A_ComputerName = LeadComputer())
{
   ;tasks that should be performed on phosphorus
   ;unless if the screen is not accessible
   ;  (last logged in via VPN and Windows logged physCompy out)
   ;  we can tell this if a screenshot saved is only half size
   ;  or possibly just check A_ScreenWidth
   ;if A_ComputerName = LeadCompy()
   RunAhkAndBabysit("UsaaGetAccountBalances.ahk")
   SleepMinutes(5)
   ;RunAhkAndBabysit("UsaaGetAccountCsvs.ahk")
   ;SleepMinutes(5)
   RunAhkAndBabysit("MintGetAccountCsvs.ahk")
   SleepMinutes(5)
   RunAhkAndBabysit("ProcessMintExport.ahk")
   SleepMinutes(5)
   RunAhkAndBabysit("UsaaCheckingBalanceProjection.ahk")
   SleepMinutes(1)
   ;RunAhkAndBabysit("CreateFinancialPieChart.ahk")
   ;SleepMinutes(15)
   RunAhkAndBabysit("GetSentryBalances.ahk")
   SleepMinutes(5)
}
else if (A_ComputerName="PHOSPHORUS")
{
   RunAhkAndBabysit("UpdatePerlPackages.ahk")
   SleepMinutes(1)
   RunAhk("AddAhkTask.ahk", "copyTasksToFcnLib")
   SleepMinutes(1)
   RunAhkAndBabysit("RestartFirefox.ahk")
   SleepMinutes(1)
   RunAhkAndBabysit("UpdatePidginImStatus.ahk")
   SleepMinutes(1)
}
else if (A_ComputerName="PHOSPHORUSVM")
{
   RunAhkAndBabysit("DeleteDropboxCruft.ahk")
   ;SleepMinutes(30)
   ;RunAhkAndBabysit("UsaaGetAccountBalances.ahk")
   SleepMinutes(5)
}

RunAhkAndBabysit("StartIdleAhks.ahk")
SleepMinutes(1)

;only run these on the work pc to start things back up again
if (A_ComputerName="PHOSPHORUS")
{
   ;this needs a little bit of click-around time
   RunAhkAndBabysit("LaunchPidgin.ahk")
   SleepMinutes(1)
}

RunAhkAndBabysit("MoveMouseAcrossEntireScreen.ahk")
SleepMinutes(2)
;SleepMinutes(30)

debug("log grey line", "finished nightly scripts")
