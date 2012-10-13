#include FcnLib.ahk
#include firefly-FcnLib.ahk

;works ok on manned
;works great on bot
AddFees(name, amount)
{
   timerFcn := StartTimer()
   ;addToTrace("adding fees: $" . amount . " " . name)

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
   Sleep, 300
   Send, %amount%
   Sleep, 200
   ;Sleep, 500

   ;Click on second field
   WFCIImageSearch(FixImagePathIfBot("images/firefly/fees/feeDescriptionField.bmp"))
   MouseMove, 120, 5, , R
   Click
   Send, ^a
   Sleep, 300
   Send, %name%
   Sleep, 200
   ;Sleep, 500

   ;Click on first field (the troublesome reason why we fill out the field backwards)
   WFCIImageSearch(FixImagePathIfBot("images/firefly/fees/feeGroupField.bmp"))
   MouseMove, %dist%, 5, , R
   Click
   Send, ^a
   Sleep, 300
   Send, %type%
   ;do not sleep, click quickly
   ClickIfImageSearch(FixImagePathIfBot("images/firefly/fees/save1.bmp"))

   CloseFeesWindow()
   Sleep, 5000
   ;was 20000 (may want to try smaller amounts)
   ;wait for the request to be processed by their site

   ;IniFolderWrite(iniFolder, referenceNumber, "FeesAddedMessage-" . name, msg)

   ;elapsed := ElapsedTime(timerFcn)
   ;tracemsg=Took %elapsed%ms for %A_ThisFunc%
   ;AddToTrace(tracemsg)

   FireflyBotEndTimer(timerFcn, A_ThisFunc, 9, 25)
}

GetFees()
{
   timerFcn := StartTimer()

   iniFolder:=GetPath("FireflyIniFolder")

   OpenFeesWindow()

   WFCIImageSearch(FixImagePathIfBot("images/firefly/fees/referenceNumber.bmp"))
   Sleep, 200
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

   ;test for double fees in a better way
   Loop, parse, listFees, CSV
   {
      thisFee:=A_LoopField
      count := RegExMatchCount(rawFees, thisFee)
      if (count > 1)
      {
         addToTrace("(red line) noticed double fees: " . referenceNumber)
         QuickFileOutput(rawFees)
         errord("silent", "(error 32) double fees", referenceNumber, thisFee, count)
         iniPP("(error 32) double fees")
         ;DoubleSMS("detected double fees " . referenceNumber)
         DoubleFeesWarning(referenceNumber)
         IniFolderWrite(iniFolder, referenceNumber, "error-doubleFees", "(red line) saw double fees")
         IniFolderWrite(iniFolder, referenceNumber, "ABORT", "(orange line) TRUE (saw double fees)")
      }
   }

   CloseFeesWindow()

   ;elapsed := ElapsedTime(timerFcn)
   ;tracemsg=Took %elapsed%ms for %A_ThisFunc%
   ;AddToTrace(tracemsg)

   FireflyBotEndTimer(timerFcn, A_ThisFunc, 3, 12)
}

OpenFeesWindow()
{
   ArrangeWindows()
   FindTopOfFirefoxPage()

   ClickIfImageSearch(FixImagePathIfBot("images/firefly/fees/feesClose.bmp"))
   ;SEEIFTHISWORKS Sleep, 100
   Sleep, 500
   if NOT ClickIfImageSearch(FixImagePathIfBot("images/firefly/fees/feesButton.bmp"))
   {
      ;click down on scrollbar
      ScrollDownLarge()
      ;SEEIFTHISWORKS Sleep, 100
      Sleep, 500
      ClickIfImageSearch(FixImagePathIfBot("images/firefly/fees/feesButton.bmp"))
   }

   WaitForImageSearch(FixImagePathIfBot("images/firefly/fees/referenceNumber.bmp"))
   WaitForImageSearch(FixImagePathIfBot("images/firefly/fees/feesWindow.bmp"))
}

CloseFeesWindow()
{
   WFCIImageSearch(FixImagePathIfBot("images/firefly/fees/feesClose.bmp"))
}

;unused
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

;deprecate this eventually in favor of feelookup2()
IsFeeNotYetAdded(referenceNumber, fee)
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

;TODO statuses:
;ABORT           ABORT
;NOT_SUBMITTED   NO_SUCH
;ALREADY_ADDED
;BOT_ADDED       ADDED
;NOT_YET_ADDED   PENDING
FeeLookup(referenceNumber, fee)
{
   iniFolder:=GetPath("FireflyIniFolder")
   thisKeySubmitted=DesiredFees-%fee%
   thisKeyAdded=FeesOnFile-%fee%

   ;checking if already added
   desiredValue := IniFolderRead(iniFolder, referenceNumber, thisKeySubmitted)
   actualValue := IniFolderRead(iniFolder, referenceNumber, thisKeyAdded)
   abortValue := IniFolderRead(iniFolder, referenceNumber, "ABORT")

   ;check if we put an emergency abort on it
   if InStr(abortValue, "TRUE")
      return "ABORTED"

   ;if there are additional fees, that's ok
   ;only fuss about fees that Melinda told the bot she wanted to add
   if (desiredValue == "ERROR")
      return "NO SUCH FEE WAS SUBMITTED"

   ;the fee is already there
   ;TODO make it so that we can tell if the fee was already there, or was added by the bot
   if (desiredValue == actualValue)
      return "FEE WAS THERE"
   else
      return "FEE NOT YET ADDED"
}

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

/* moved to fcnlib-clipboard (2012-03-24)
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
*/

RefreshLogin()
{
   timerFcn := StartTimer()

   KillFirefox()

   ;start firefox again ; this method is a little difficult, imacros will be easier
   RunProgram("C:\Program Files\Mozilla Firefox\firefox.exe")
   panther:=SexPanther("melinda")
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

   ;TODO not sure, but I think the helper will need to take care of this
   WinWaitActive, %statusProMessage%
   if SimpleImageSearch("images/firefly/dialog/thereWasAnErrorHandlingYourCurrentAction.bmp")
      Click(170, 90, "control") ;center ok button

 ;(changed on 2012-05-02)
   ;elapsed := ElapsedTime(timerFcn)
   ;if (elapsed > 120000)
      ;status=red line
   ;else if (elapsed > 100000)
      ;status=orange line
   ;tracemsg=Took %elapsed%ms for %A_ThisFunc% %status%
   ;AddToTrace(tracemsg)

   FireflyBotEndTimer(timerFcn, A_ThisFunc, 15, 100)
}

PlayDead()
{
   addtotrace("started " . A_ScriptName . ", playing dead - faint red line")
   SleepMinutes(99)
}
