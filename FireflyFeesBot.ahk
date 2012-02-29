#include FcnLib.ahk
#include firefly-FcnLib.ahk
#singleinstance force
assignGlobals()
bot:=true

if NOT IsVM()
   fatalerrord("this macro is only for VMs")

iniFolder:=GetPath("FireflyIniFolder")

;checkin
FireflyCheckin("Bot", "Started/Chillin")

;currentlyDebugging := 1
if currentlyDebugging
{
   ms := Random(20, 10000)
   Sleep, %ms%
   Run, ForceReloadAll.exe
   SleepMinutes(30)
   ExitApp
}

;REMOVEME before moving live
;addtotrace("started bot")
;displayableIniFolder(inifolder)
;SleepMinutes(99)

uiSections := IniFolderListAllSections(iniFolder)
feesJson := GetSimpleFeesJson()
listFees := ListFees()
Loop, parse, uiSections, CSV
{
   thisReferenceNumber:=A_LoopField

   Loop, parse, listFees, CSV
   {
      thisFee:=A_LoopField

      ;checking if already added
      ;addtotrace("checking if fee is already added")
      if IsFeeAddedCorrectly(thisReferenceNumber, thisFee)
         continue

      ;go to the correct file
      ;if ( Mod(feesAddedCountSoFar, 5) == 0)
         RefreshLogin()
      ArrangeWindows()
      ;addtotrace("opening ref num")
      OpenReferenceNumber(thisReferenceNumber)
      ;addtotrace("getting fees")
      GetFees()

      ;checking if already added
      ;addtotrace("checking if fee is already added")
      if IsFeeAddedCorrectly(thisReferenceNumber, thisFee)
         continue

      FireflyCheckin("Bot", "Working")

      ;addtotrace("looking at new fee - grey line")
      addtotrace("looking at new fee")
      addtotrace(thisreferencenumber)
      addtotrace(thisfee)
      addtotrace("adding the fee")

      ;add the friggin fee!
      thisKeySubmitted=DesiredFees-%thisFee%
      desiredAmount:=IniFolderRead(iniFolder, thisReferenceNumber, "DesiredFees-" . thisFee)
      AddFees(thisFee, desiredAmount)
      IniFolderWrite(iniFolder, thisReferenceNumber, "BotAddedFee-" . thisFee, desiredAmount)

      addtotrace("getting fees")
      GetFees()
      feesAddedCountSoFar++

      msg=Added %feesAddedCountSoFar% fees so far
      AddToTrace(msg)
      ;iniPP("Bot Is Working")

      ;checkin
      FireflyCheckin("Bot", "Working")
      ;displayableIniFolder(inifolder)
   }
}
;iniPP("Bot Is Chillin")

Sleep, 1000
KillFirefox()
Reload()

ExitApp

;works ok on manned
;works great on bot
AddFees(name, amount)
{
   iniFolder:=GetPath("FireflyIniFolder")
   feesJson := GetSimpleFeesJson()
   type := json(feesJson, name . ".type")

   OpenFeesWindow()
   dist:=93

   ;Click add new fee button
   WaitForImageSearch("images/firefly/fees/addNewFee.bmp", 60)
   ClickIfImageSearch("images/firefly/fees/addNewFee.bmp")
   ClickIfImageSearch("images/firefly/fees/addNewFee2.bmp")
   ClickIfImageSearch("images/firefly/fees/addNewFee2.bmp")
   ClickIfImageSearch("images/firefly/fees/addNewFee3.bmp")
   ClickIfImageSearch("images/firefly/fees/addNewFee4.bmp")
   ClickIfImageSearch("images/firefly/fees/addNewFee1VM.bmp")
   MouseMove, 5, 5, , R
   Click

   ;Click third Field
   WFCIImageSearch(FixImagePathIfBot("images/firefly/fees/feeAmountField.bmp"))
   MouseMove, %dist%, 5, , R
   Click
   Send, ^a
   Sleep, 1000
   Send, %amount%
   Sleep, 2000

   ;Click on second field
   WFCIImageSearch(FixImagePathIfBot("images/firefly/fees/feeDescriptionField.bmp"))
   MouseMove, 120, 5, , R
   Click
   Send, ^a
   Sleep, 1000
   Send, %name%
   Sleep, 2000

   ;Click on first field (the troublesome reason why we fill out the field backwards)
   WFCIImageSearch(FixImagePathIfBot("images/firefly/fees/feeGroupField.bmp"))
   MouseMove, %dist%, 5, , R
   Click
   Send, ^a
   Sleep, 1000
   Send, %type%
   ;DO NOT SLEEP, CLICK QUICKLY

   ;FIXME why did I need two images here?
   ClickIfImageSearch(FixImagePathIfBot("images/firefly/fees/save1.bmp"))
   ClickIfImageSearch(FixImagePathIfBot("images/firefly/fees/save.bmp"))
   MouseMove, 5, 5, , R
   Click
   CloseFeesWindow()
   Sleep, 30000

   ;POLISH sanity check using GetFees()
   ;AllTheFeesJson := GetFees()
   ;result := json(AllTheFeesJson, name)
   ;if (result == amount)
      ;msg=fee added correctly
   ;else
      ;msg=ERROR-looks like bot failed to add the fee correctly

   ;ArrangeWindows()
   ;FindTopOfFirefoxPage()
   ;referenceNumber:=GetReferenceNumber()

   ;IniFolderWrite(iniFolder, referenceNumber, "FeesAddedMessage-" . name, msg)
}

GetFees()
{
   iniFolder:=GetPath("FireflyIniFolder")

   OpenFeesWindow()

   WFCIImageSearch(FixImagePathIfBot("images/firefly/fees/referenceNumber.bmp"))
   Sleep, 1000

   ;MouseMoveIfImageSearch("images/firefly/fees/feesWindow.bmp")
   ;Sleep, 3000
   ;MouseMove, 0, 35, , R
   ;Click

   Send, ^a
   rawFees:=CopyWait2()

   ;pull out the generic info
   RegExMatch(rawFees, "Reference \#  (\d+)", match)
   referenceNumber:=match1
   RegExMatch(rawFees, "(\d+) items in (\d+) pages", match)
   feesCount:=match1

   ;pull out the individual fees
   listFees:=ListFees()
   AllTheFeesJson:=GetSimpleFeesJson()
   Loop, parse, listFees, CSV
   {
      thisFee:=A_LoopField
      i:=A_Index
      thisFeeAmount:=FeeAmount%i%
      thisFeeType=Client
      if (i == 2)
         thisFeeType=Process Server

      t=\t+
      needle=%thisFeeType%%t%%thisFee%%t%.(\d+.\d+)%t%\d+%t%.\d+.\d+%t%.(\d+\.\d+)
      RegExMatch(rawFees, needle, match)
      thisFeeAmount:=match1

      FeeAmount%i%:=thisFeeAmount
      FeeType%i%:=thisFeeType
      FeeName%i%:=thisFee
      json(AllTheFeesJson, thisFee, thisFeeAmount)

      if (thisFeeAmount != "")
      {
         numberOfFeesCounted++
         IniFolderWrite(iniFolder, referenceNumber, "FeesOnFile-" . thisFee, thisFeeAmount)
      }
   }

   ;this probably isn't a big error, cause I wrote the stuff above to only account for some of the fees
   if (numberOfFeesCounted != feesCount)
   {
      errord("silent", "(error 31) fees counts did not match, might mean there are duplicate fees", referenceNumber, feesCount, numberOfFeesCounted)
      iniPP("(error 31) fees count mismatch")
   }

   ;errord("nolog notimeout", referenceNumber, feesCount, FeeAmount1, FeeAmount2, FeeAmount3, FeeAmount4)
   ;WFCIImageSearch(FixImagePathIfBot("images/firefly/fees/feesClose.bmp"))
   CloseFeesWindow()

   return AllTheFeesJson
}

OpenFeesWindow()
{
   ArrangeWindows()
   FindTopOfFirefoxPage()

   ClickIfImageSearch(FixImagePathIfBot("images/firefly/fees/feesClose.bmp"))
   Sleep, 500
   if NOT ClickIfImageSearch(FixImagePathIfBot("images/firefly/fees/feesButton.bmp"))
   {
      ;click down on scrollbar
      ScrollDownLarge()
      Sleep, 500
      ClickIfImageSearch(FixImagePathIfBot("images/firefly/fees/feesButton.bmp"))
   }

   WaitForImageSearch(FixImagePathIfBot("images/firefly/fees/referenceNumber.bmp"))
   Sleep, 1000
   WaitForImageSearch(FixImagePathIfBot("images/firefly/fees/feesWindow.bmp"))
}

CloseFeesWindow()
{
   WFCIImageSearch(FixImagePathIfBot("images/firefly/fees/feesClose.bmp"))
}

;TESTME
IsFeesWindowOpen()
{
   joe := ClickIfImageSearch(FixImagePathIfBot("images/firefly/fees/feesWindow.bmp"))
   bob := ClickIfImageSearch(FixImagePathIfBot("images/firefly/fees/referenceNumber.bmp"))
   return %joe% AND %bob%
}

IsFeeAddedCorrectly(referenceNumber, fee)
{
   iniFolder:=GetPath("FireflyIniFolder")
   thisKeySubmitted=DesiredFees-%fee%
   thisKeyAdded=FeesOnFile-%fee%

   ;checking if already added
   desiredValue := IniFolderRead(iniFolder, referenceNumber, thisKeySubmitted)
   actualValue := IniFolderRead(iniFolder, referenceNumber, thisKeyAdded)

   ;if there are additional fees, that's ok
   ;only fuss about fees that Melinda told the bot she wanted to add
   if (desiredValue == "ERROR")
      return true

   ;the fee is already there
   if (desiredValue == actualValue)
      return true
   else
      return false
}

ExitApp

/*

Reference #  2461358
Fee Group	Fee Description	Amount	Qty	Sales Tax	Total	Export Status	GP Import Date	Invoice #	Payee	Vendor Invoice	Override	PrePayment	PrePayment Check #
Add new record
1
Page size:
	select

    * 10
    * 20
    * 50

 1 items in 1 pages
Client	Pinellas County Sticker	$3.00	1	$0.00	$3.00	New	 	0


Reference #  2522980
Fee Group	Fee Description	Amount	Qty	Sales Tax	Total	Export Status	GP Import Date	Invoice #	Payee	Vendor Invoice	Override	PrePayment	PrePayment Check #
Add new record
1
Page size:
	select

    * 10
    * 20
    * 50

 4 items in 1 pages
Client	Pinellas County Sticker	$3.00	1	$0.00	$3.00	New	 	0
Client	Pinellas County Sticker	$3.00	1	$0.00	$3.00	New	 	0
Client	Pinellas County Sticker	$3.00	1	$0.00	$3.00	New	 	0
Client	Pinellas County Sticker	$3.00	1	$0.00	$3.00	New	 	0

*/

CopyWait2()
{
   Clipboard:=""
   ClipWait("")
   ss()
   copy()
   ;Send, {CTRLDOWN}c{CTRLUP}
   ss()
   ClipWaitNot("")

   returned:=Clipboard
   return returned
}

RefreshLogin()
{
   KillFirefox()

   ;start firefox again ; this method is a little difficult, imacros will be easier
   RunProgram("C:\Program Files\Mozilla Firefox\firefox.exe")
   panther:=SexPanther("melinda")
   melWorkEmail:=SexPanther("mel-work-email")
   imacro=
   (
   TAB CLOSEALLOTHERS
   URL GOTO=https://www.status-pro.biz/dashboard/Default.aspx
   TAG POS=1 TYPE=INPUT:TEXT FORM=NAME:form1 ATTR=ID:LoginUser_UserName CONTENT=AHmbaustian
   SET !ENCRYPTION NO
   TAG POS=1 TYPE=INPUT:PASSWORD FORM=NAME:form1 ATTR=ID:LoginUser_Password CONTENT=%panther%
   TAG POS=1 TYPE=INPUT:SUBMIT FORM=ID:form1 ATTR=ID:LoginUser_LoginButton
   TAG POS=1 TYPE=A ATTR=TXT:Click<SP>Here<SP>to<SP>Log<SP>Into<SP>FC
   )
   RunIMacro(imacro)
   WinWaitActive, %statusProMessage%
   if SimpleImageSearch("images/firefly/dialog/thereWasAnErrorHandlingYourCurrentAction.bmp")
      Click(170, 90, "control") ;center ok button
}
