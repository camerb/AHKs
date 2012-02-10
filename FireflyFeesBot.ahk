#include FcnLib.ahk
#include firefly-FcnLib.ahk
#include thirdParty\json.ahk
assignGlobals()
bot:=true

if NOT IsVM()
   fatalerrord("this macro is only for VMs")

uiini:=GetPath("Firefly-1-Submitted.ini")
botini:=GetPath("Firefly-2-Added.ini")
uiSections := IniListAllSections(uiini)
feesJson := GetSimpleFeesJson()
listFees := ListFees()
Loop, parse, uiSections, CSV
{
   thisReferenceNumber:=A_LoopField

   Loop, parse, listFees, CSV
   {
      thisFee:=A_LoopField

      botValue:=IniRead(botini, thisReferenceNumber, thisFee)
      uiValue:=IniRead(uiini, thisReferenceNumber, thisFee)

      if (botValue == uiValue)
         continue

      ;if ( Mod(feesAddedCountSoFar, 5) == 0)
         RefreshLogin()
      arrangeWindows()
      OpenReferenceNumber(thisReferenceNumber)
      AddFees(thisFee, uiValue)
      IniWrite(botIni, thisReferenceNumber, thisFee, uiValue)
      feesAddedCountSoFar++
   }
}
Sleep, 1000
KillFirefox()
Reload()

ExitApp

;works ok on manned
;works great on bot
AddFees(name, amount)
{
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

   ;TODO sanity check using GetFees()
}

GetFees()
{
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
   listFees=ListFees()
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
      if (thisFeeAmount != "")
         numberOfFeesCounted++
   }

   ;this probably isn't a big error, cause I wrote the stuff above to only account for some of the fees
   if (numberOfFeesCounted != feesCount)
   {
      errord("silent", "(error 31) fees counts did not match, might mean there are duplicate fees", referenceNumber, feesCount, numberOfFeesCounted)
      iniPP("(error 31) fees count mismatch")
   }

   errord("nolog notimeout", referenceNumber, feesCount, FeeAmount1, FeeAmount2, FeeAmount3, FeeAmount4)
   ;WFCIImageSearch(FixImagePathIfBot("images/firefly/fees/feesClose.bmp"))
   CloseFeesWindow()
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
