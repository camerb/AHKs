#include FcnLib.ahk
#include firefly-FcnLib.ahk
#include firefly-Bot-FcnLib.ahk
#singleinstance force
assignGlobals()
bot:=true

;NOTE 2012-05-01 should be the first day where you can see when the bot finished adding fees based on the file modified date. You should be able when Mel stopped adding fees and when the Bot finished adding those fees based on file modified dates
;NOTE 2012-06-16 should be the first date where you have no conflicted copy files for the iniFs (checkins and fee files also). This was when I added the ModMin feature into the iniF lib

if NOT IsVM()
   fatalerrord("this macro is only for VMs")

;First things first, write a start message and do the checkin
;addtotrace("Started bot script")
;addtotrace("Started bot script (faint grey line)")
FireflyCheckin("Bot", "Started")
CheckBotHealth()

;roll over and play dead (test the check-ins)
;PlayDead()

iniFolder:=GetPath("FireflyIniFolder")

;if the bot doesn't have any fees to add, then wait for a little bit
if ( GetNumberOfFeesNotYetAdded() == 0 )
{
   iniPP("Finished adding fees")
   FireflyCheckin("Bot", "Finished adding fees")
   ArchiveOldInifParts( GetPath("FireflyIniFolder") )
   ;TODO this needs to happen on each individual computer, and only if the file hasn't been touched recently
   ;ArchiveOldInifParts( GetPath("FireflyCheckinIniFolder") )
   SleepSeconds(30)
   Reload()
}

;i think i did this because I wanted to restart the sucker remotely
;currentlyDebugging := 1
;if currentlyDebugging
;{
   ;ms := Random(20, 10000)
   ;Sleep, %ms%
   ;Run, ForceReloadAll.exe
   ;SleepMinutes(99)
   ;ExitApp
;}

;addtotrace("purple line - sending queued emails - triggered by bot")
;addtotrace("sending queued emails - triggered by bot")
Run, SendQueuedEmails.ahk

;addtotrace("faint blue line - restarted the script normally")
RefreshLogin()
FireflyCheckin("Bot", "Finished RefreshLogin")

uiSections := IniFolderListAllSections(iniFolder)
feesJson := GetSimpleFeesJson()
listFees := ListFees()
Loop, parse, uiSections, CSV
{
   thisReferenceNumber:=A_LoopField

   Loop, parse, listFees, CSV
   {
      thisFee:=A_LoopField

      timerEntire := StartTimer()

      ;checking if the entire ref num was aborted
      if ( FeeLookup(thisReferenceNumber, thisFee) == "ABORTED")
         continue

      ;checking if already added
      ;addtotrace("checking if fee is already added")
      if IsFeeAddedCorrectly(thisReferenceNumber, thisFee)
         continue

      ;go to the correct file
      ArrangeWindows()

      FireflyCheckin("Bot", "Started OpenReferenceNumber")

      ;addtotrace("opening ref num " . thisReferenceNumber)
      OpenReferenceNumber(thisReferenceNumber)

      FireflyCheckin("Bot", "Getting Fees (before)")

      ; get the file num
      ;commented to make it run faster
      fileNumber := GetFileNumber()
      IniFolderWrite(iniFolder, thisReferenceNumber, "FileNumber", fileNumber)

      ;addtotrace("getting fees " . thisReferenceNumber)
      GetFees()

      FireflyCheckin("Bot", "Working")


      ;checking if the entire ref num was aborted
      if ( FeeLookup(thisReferenceNumber, thisFee) == "ABORTED")
         continue

      ;checking if already added
      ;addtotrace("checking if fee is already added")
      if IsFeeAddedCorrectly(thisReferenceNumber, thisFee)
         continue

      FireflyCheckin("Bot", "Working")

      ;count the number of times that we try to add the fee
      thisKey=BotAttemptedToAddFee-%thisFee%
      attempts:=IniFolderRead(iniFolder, thisReferenceNumber, thisKey)
      if (attempts == "ERROR")
         attempts := 0
      attempts++
      IniFolderWrite(iniFolder, thisReferenceNumber, thisKey, attempts)

      FireflyCheckin("Bot", "Working")

      ;get info for adding the fee
      thisKeySubmitted=DesiredFees-%thisFee%
      desiredAmount:=IniFolderRead(iniFolder, thisReferenceNumber, "DesiredFees-" . thisFee)
      ;FASF - Fees Added So Far
      tracemsg=Adding Fee: %feesAddedCountSoFar%FASF %thisReferenceNumber% $%desiredAmount% %thisFee% (faint purple line)
      addtotrace(traceMsg)
      feesAddedCountSoFar++

      FireflyCheckin("Bot", "Adding fee")

      ;add the friggin fee!
      AddFees(thisFee, desiredAmount)
      IniFolderWrite(iniFolder, thisReferenceNumber, "BotAddedFee-" . thisFee, desiredAmount)

      FireflyCheckin("Bot", "Getting fees (after)")

      ;look to see if the fee was successfully added
      GetFees()

      FireflyBotEndTimer(timerEntire, "adding fee S-to-F (not a func)", 35, 90)
      FireflyCheckin("Bot", "Finished the fee loop")
   }
}

Sleep, 1000
KillFirefox()
Reload()

ExitApp
