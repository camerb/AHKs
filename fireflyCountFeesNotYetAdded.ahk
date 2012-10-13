#include FcnLib.ahk
#include firefly-FcnLib.ahk
#singleinstance force
#notrayicon
assignGlobals()

;DoubleSMS("Testing Double SMS")

iniFolder:=GetPath("FireflyIniFolder")
uiSections := IniFolderListAllSections(iniFolder)
feesJson := GetSimpleFeesJson()
listFees := ListFees()
feeNotYetAdded := 0
feeAdded := 0

;if (A_ComputerName == "PHOSPHORUS")
   ;debug("nolog", "hi")

Loop, parse, uiSections, CSV
{
   thisReferenceNumber:=A_LoopField

   totalFeesRequested++
   ;lotsotext .= thisReferenceNumber . ","

   Loop, parse, listFees, CSV
   {
      thisFee:=A_LoopField

      ;totalFeesRequested++
      ;lotsotext .= thisReferenceNumber . ","

      status := FeeLookup(thisReferenceNumber, thisFee)

      if (status == "NO SUCH FEE WAS SUBMITTED")
      {
         noSuchFee++
      }
      if (status == "FEE WAS THERE")
      {
         feeAdded++
      }
      if (status == "FEE NOT YET ADDED")
      {
         feeNotYetAdded++
         lotsotext .= feeNotYetAdded . " " . thisReferenceNumber . "," . thisFee . "`n"
      }
      if (status == "NOT_YET_ADDED")
      {
         feeNotYetAdded++
         lotsotext .= feeNotYetAdded . " " . thisReferenceNumber . "," . thisFee . "`n"
      }

      totalFeesAdded++
      ;lotsotext .= thisReferenceNumber . ","
   }
}

feeAdded := feeAdded / 2
RegExMatch(feeAdded, "^\d+", feeAdded)

;do some math stats
total := feeAdded + feeNotYetAdded
percent := 100 * feeAdded / total
RegExMatch(percent, "^\d+", percent)
if (total == 0)
   percent := 100

fileContents=Fees Not Yet Added: %feeNotYetAdded%`nFees Added: %feeAdded% (%percent%`%)
FileCreate(fileContents, "C:\Dropbox\Public\fireflyFees.txt")
;difference := totalFeesRequested - totalFeesAdded
;debug("notimeout", noSuchFee, feeAdded, feeNotYetAdded, lotsOtext)

if (A_ComputerName == "PHOSPHORUS")
{
   debug("fees not yet added", feeNotYetAdded)
   debug("fees added", feeAdded)
   debug("percent complete", percent)
   debug("no such fee", noSuchFee)
}


ExitApp
;just use the functions from that file
#include FireflyFeesBot.ahk
