#include firefly-FcnLib.ahk
#NoTrayIcon

;{{{ TODOs
;PRIORITIES:
;  Track invoices (maybe email erica when invoice is generated) (need to discuss with mel)


;email from melinda: 2012-02-16
;- a "Ready to Invoice" checkbox on my fees gui that exports the file number to a spreadsheet somewhere (maybe that little "Go to the next job" button that you made would work with this as long as we are only exporting one job number per file)
;- make sure that Add Scorecard is not trying to enter data into fields that cannot be modified (I think we need to work together to figure out the issue)
;- fix the "Load Reference Number" macro so that if I hit cancel or the "X" it won't still try to add it (I have started hitting Ctrl ~ when that pops up but my first instinct is to hit the "X" and it drives me crazy when I do that!!)
;- I also think I might want to change the layout of the buttons on the gui, but I am not quite sure what I want to do with it yet

;TODO add dates to "Add Scorecard Entry"
;FIXME Auto-expand all pluses in the left-hand side
;TODO make in-depth fees gui
;TODO default PS Fee to $10
;TODO use the StatusProCopyField() for all copies
;TODO changeall references of "Status" to "ServiceManner"

;TODO make a macro that tests their site and determines if the site is going slower than normal and logs out/in again
;TODO make macros more robust so that I can upgrade firefox
;TODO use the StatusProCopyField() for all copies
;TODO Do you think that you could make a macro that after I invoice a Gladstone file it automatically emails Erica?
;TODO Track number of invoiced files
;TODO Track number of approved files

;FIXME FIXME FIXME - I think I fixed this
;Can you see at the top, in the middle, above the Process Server Name, there is some info in blue? I think that sometimes there is alot of information there so the rest of the page is skewed and the macro ends up copypasting randomness all around.
;I don't know if this is really part of the issue but thought I would throw it out. I was trying to add a scorecard entry on this one when the macros went wild.
;end FIXME - from an email Mel sent on 11-22-2011 around 3:30pm

;Items that don't seem to be important anymore (or things that I think I've finished):
;WRITEME firefly: make paste paste without formatting in the MS-Word lookalike program
;REMOVEME - I think I did remove this part of the code (2011-11-10)... The "Would you like to approve?" box never shows up anymore. Don't know if you would want to remove that code?
;TODO move parts into functions (like GetReferenceNumber(), GetServerName(), GetStatus() )
;- change "Add Scorecard Entry" so that it puts my name (Melinda Baustian instead of AHMBaustian)
;TODO change text in the MS-Word lookalike program (cause their template is wrong)
;  Add fees button that works on background computer
;  Make FindTopOfFirefoxPage() more reliable (it used to be good)
;Mel said she had a bunch of issues with the bot adding fees twice... I thought she said that was not a big issue?

;ABANDONED:
;make background blueish to match sidebar
;}}}

;{{{Globals and making the gui (one-time tasks)
assignGlobals()

;figure out the coordinates where we will place the window
xLocation=1770
yLocation=550
if (A_ComputerName == "PHOSPHORUS")
{
   xLocation=3686
   yLocation=480
}
if (A_ComputerName == "T-800")
{
   xLocation=1129
   yLocation=171
}
xLocationApproval:= xLocation
yLocationApproval:= yLocation + 400

Gui, +LastFound -Caption +ToolWindow +AlwaysOnTop
;Gui, Color, 000032
Gui, Add, Button, , Reload Queue
Gui, Add, Button, , Change Queue
;Gui, Add, Button, , Add Scorecard Entry-new
;Gui, Add, Button, , Add Scorecard Entry-fw
Gui, Add, Button, , Add Scorecard Entry-yn
Gui, Add, Button, , Refresh Login
Gui, Add, Button, , Load Reference Number
Gui, Add, Button, , Add Fees
;Gui, Add, Button, , Fetch RefNums Csv

Gui, Add, Button, x10  y230, Record for Cameron
Gui, Add, Button, x10  y260, Test Something
Gui, Add, Button, x10  y290, Notes
;Gui, Add, Button, x10  y250, Report Undesired Error
Gui, Add, Button, x110 y6  , x

Gui, Show, , Firefly Shortcuts
WinMove, Firefly Shortcuts, , %xLocation%, %yLocation%

RecordSuccessfulStartOfFireflyPanel()
;}}}

;{{{Persistent items (things that are checked repetitively)
Loop
{
   ;expand all pluses
   ;ClickIfImageSearch("images/firefly/expandJob.bmp")

   ;Stuff for annoying firefly boxes that are always cancelled out of
   IfWinActive, %statusProMessage%
   {
      ;;REMOVEME if Mel doesn't complain (2011-11-10)
      ;if SimpleImageSearch("images/firefly/dialog/wouldYouLikeToApproveThisJob.bmp")
         ;Click(200, 90, "control") ;no button
      if SimpleImageSearch("images/firefly/dialog/pleaseSelectAnOptionFromTheDropDown.bmp")
         Click(170, 90, "control") ;center ok button
      if SimpleImageSearch("images/firefly/dialog/selectedFeesEntryHasBeenDeletedSuccessfully.bmp")
         Click(170, 90, "control") ;center ok button
      if SimpleImageSearch("images/firefly/dialog/thereWasAnErrorHandlingYourCurrentAction.bmp")
         Click(170, 90, "control") ;center ok button
   }

   if (Mod(A_Sec, 5)==0)
   {
      if NOT didThisOnce
      {
         didThisOnce:=true
         IfWinActive, %statusProMessage%
         {
            if SimpleImageSearch("images/firefly/dialog/wouldYouLikeToApproveThisJob.bmp")
               continue
            if SimpleImageSearch("images/firefly/dialog/wouldYouLikeToContinueToApproveThisJob.bmp")
               continue
            if SimpleImageSearch("images/firefly/dialog/thereWasAnErrorHandlingYourCurrentAction.bmp")
               continue
            if SimpleImageSearch("images/firefly/dialog/selectedFeesEntryHasBeenDeletedSuccessfully.bmp")
               continue
            if SimpleImageSearch("images/firefly/dialog/pleaseSelectAnOptionFromTheDropDown.bmp")
               continue
            if SimpleImageSearch("images/firefly/dialog/areYouSureYouWantToDeleteThisFeesEntry.bmp")
               continue
            SaveScreenShot("fireflyDialog", "dropbox", "activeWindow")
         }
         ;AddToTrace(CurrentTime("hyphenated") . "hoping that this does not trigger more than once a second")
      }
   }
   else
   {
      didThisOnce:=false
   }

   Sleep, 100
}

return
;}}}

;{{{ButtonRefreshLogin:
ButtonRefreshLogin:
StartOfMacro()

KillFirefox()

;start firefox again ; this method is a little difficult, imacros will be easier
RunProgram("C:\Program Files\Mozilla Firefox\firefox.exe")
panther:=SexPanther("melinda")
melWorkEmail:=SexPanther("mel-work-email")
imacro=
(
TAB CLOSEALLOTHERS
URL GOTO=http://www.gmail.com
TAG POS=1 TYPE=INPUT:TEXT FORM=ACTION:https://accounts.google.com/ServiceLoginAuth ATTR=ID:Email CONTENT=melindabaustian@gmail.com
SET !ENCRYPTION NO
TAG POS=1 TYPE=INPUT:PASSWORD FORM=ACTION:https://accounts.google.com/ServiceLoginAuth ATTR=ID:Passwd CONTENT=%panther%
TAG POS=1 TYPE=INPUT:SUBMIT FORM=ID:gaia_loginform ATTR=ID:signIn
TAB OPEN
TAB T=2
URL GOTO=https://mail.fireflylegal.com/owa
TAG POS=1 TYPE=INPUT:TEXT FORM=NAME:logonForm ATTR=ID:username CONTENT=excel/m.baustian
SET !ENCRYPTION NO
TAG POS=1 TYPE=INPUT:PASSWORD FORM=NAME:logonForm ATTR=ID:password CONTENT=%melWorkEmail%
TAG POS=1 TYPE=INPUT:SUBMIT FORM=NAME:logonForm ATTR=VALUE:Log<SP>On
TAB OPEN
TAB T=3
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

EndOfMacro()
GoSub, ButtonReloadQueue
return
;}}}

;{{{ ButtonFetchRefNumsCsv:
ButtonFetchRefNumsCsv:
StartOfMacro()

fees1SubmittedIni:=GetPath("Firefly-1-Submitted.ini")
fees2AddedIni:=GetPath("Firefly-2-Added.ini")
fees3FetchedIni:=GetPath("Firefly-3-Fetched.ini")
referenceNumbersToReview := IniListAllSections(fees2AddedIni)
listFees := ListFees()
currentlyReviewingReferenceNumber:=""
Loop, parse, referenceNumbersToReview, CSV
{
   thisReferenceNumber:=A_LoopField

   ;verify that all of the fees from 1 and 2 match, otherwise don't put them in the spreadsheet
   if NOT feesMatchForThisReferenceNumber(thisReferenceNumber, fees1SubmittedIni, fees2AddedIni)
      continue

   ;TESTME this kinda seems like it is working, then sometimes it seems to break
   ;don't put reference numbers in the spreadsheet twice
   isSaved := IniRead(fees3FetchedIni, "", thisReferenceNumber)
   ;debug(isSaved)
   if (isSaved == 1)
      continue

   ;add to reviewed file
   IniWrite(fees3FetchedIni, "", thisReferenceNumber, "1")

   ;add to csv
   csvFile := "C:\Documents and Settings\Baustian\Desktop\Firefly\RefNums\" . CurrentTime("hyphenated") . "-ReferenceNumbersToReview.csv"
   ;debug(csvfile)
   ;Clipboard := csvFile
   FileAppendLine(thisReferenceNumber, csvFile)

   countOfFetched++
}

quote="
csvFile:=EnsureStartsWith(csvFile, quote)
csvFile:=EnsureEndsWith(csvFile, quote)
;Open the file for melinda to see it
if countOfFetched
   CmdRet_RunReturn("C:\Dropbox\Programs\SnapDB\SnapDB.exe " . csvFile)
else
   debug("No reference numbers are ready to review at this time")

EndOfMacro()
return
;}}}

;{{{ ButtonFetchRefNumsCsv-2:
ButtonFetchRefNumsCsv-2:
StartOfMacro()

;vs UI
;vs VM
feesUIini:=GetPath("Firefly-UI.ini")
feesVMini:=GetPath("Firefly-VM.ini")
referenceNumbersToReview := IniListAllSections(feesVMini)
listFees := ListFees()
currentlyReviewingReferenceNumber:=""
Loop, parse, referenceNumbersToReview, CSV
{
   thisReferenceNumber:=A_LoopField

   ;verify that all of the fees from 1 and 2 match, otherwise don't put them in the spreadsheet
   if NOT feesMatchForThisReferenceNumber(thisReferenceNumber, feesUIini, feesVMini)
      continue

   ;TESTME this kinda seems like it is working, then sometimes it seems to break
   ;don't put reference numbers in the spreadsheet twice
   isSaved := IniRead(feesUIini, "AlreadyFetched", thisReferenceNumber)
   ;debug(isSaved)
   if (isSaved == 1)
      continue

   isReadyToInvoice := IniRead(feesUIini, thisReferenceNumber, "ReadyToInvoice")
   if (isReadyToInvoice == 1)
      continue

   ;add to reviewed file
   IniWrite(feesUIini, "AlreadyFetched", thisReferenceNumber, "1")

   ;add to csv
   csv .= thisReferenceNumber
   csv .= "`n"

   countOfFetched++
}

;Open the file for melinda to see it
if countOfFetched
   PreviewCsv(csv)
else
   debug("No reference numbers are ready to review at this time")

EndOfMacro()
return
;}}}

;{{{ButtonAddFees:
ButtonAddFees:
StartOfMacro()

FindTopOfFirefoxPage()
referenceNumber := GetReferenceNumber()

Gui, 2: Destroy
listFees := ListFees()
Loop, parse, listFees, CSV
{
   thisFee:=A_LoopField
   Gui, 2: Add, Text,, %thisFee%
}
;Gui, 2: Add, Text,, Ready To Invoice
Gui, 2: Add, Edit, vFeesVar1 x100 y2
Gui, 2: Add, Edit, vFeesVar2
Gui, 2: Add, Edit, vFeesVar3
Gui, 2: Add, Edit, vFeesVar4
;Gui, 2: Add, Edit, vReadyToInvoice
Gui, 2: Add, Button, Default x190 y110, Go Add Fees
Gui, 2: Show, , Firefly Fees AHK Dialog
Gui, 2: Show
return
;;;;;;;;;;;;;;;;;;;;;;;; WAIT FOR USER TO PRESS THE BUTTON
2ButtonGoAddFees:
Gui, 2: Submit
Gui, 2: Destroy

;REMOVEME
ReadyToInvoice:=true
;feesvar1=10
;feesvar2=20
;feesvar3=30
;feesvar4=3

if NOT (feesVar4 == "" or feesVar4 == 3)
{
   errord("notimeout", "Pinellas County Sticker Fee should be either blank or 3")
   return
}

iniFolder:=GetPath("FireflyIniFolder")
;feesUIini := GetPath("Firefly-UI.ini")
;botFile := GetPath("Firefly-2-Added.ini")
Loop, parse, listFees, CSV
{
   i:=A_Index
   thisFee:=A_LoopField
   thisFeeAmount:=FeesVar%i%
   thisKeySubmitted=DesiredFees-%thisFee%

   if thisFeeAmount
      IniFolderWrite(iniFolder, referenceNumber, thisKeySubmitted, thisFeeAmount)
   ;if thisFeeAmount
      ;IniWrite(feesUIini, referenceNumber, thisFee, thisFeeAmount)
}

if ReadyToInvoice
   IniFolderWrite(iniFolder, referenceNumber, "ReadyToInvoice", "1")
;if ReadyToInvoice
   ;IniWrite(feesUIini, referenceNumber, "ReadyToInvoice", "1")

if NOT IsVmRunning()
   OpenVM()

EndOfMacro()
return
;}}}

;{{{ButtonAddScorecardEntry-Experimental:
ButtonAddScorecardEntry-Experimental:
StartOfMacro()
iniPP("AddScorecardEntry-01")

FindTopOfFirefoxPage()
iniPP("AddScorecardEntry-03")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; new way
;ss()
;Click(1100, 165, "left double")
;iniPP("AddScorecardEntry-04")
;ss()

;;NOTE if she gets error 14, it probably means we need to use a slower CopyWait()
;iniPP("AddScorecardEntry-05")

;;referenceNumber:=CopyWaitMultipleAttempts("slow")
;referenceNumber:=CopyWait("slow")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; old way
ss()
Click(1100, 165, "left double")
;Click(1100, 165, "left")
iniPP("AddScorecardEntry-04-new")
ss()
Send, {CTRLDOWN}c{CTRLUP}
ss()
iniPP("AddScorecardEntry-05-new")
Click(620, 237, "left double")
;Click(620, 237, "left")
ss()
referenceNumber:=Clipboard
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

iniPP("AddScorecardEntry-06")
if NOT RegExMatch(referenceNumber, "[0-9]{4}")
   RecoverFromMacrosGoneWild("I didn't get the reference number (scroll up, maybe?) (error 14)", referenceNumber)
iniPP("AddScorecardEntry-07")

Click(620, 237, "left double")
Send, {CTRLDOWN}a{CTRLUP}
iniPP("AddScorecardEntry-08")
serverName:=CopyWait("slow")
iniPP("AddScorecardEntry-09")
if (serverName == "test3 test3") ;we're in testing mode
   serverName=testing testing testing
if ( StrLen(serverName) > 25 )
   RecoverFromMacrosGoneWild("I got too much text for the server name (error 10)")
if RegExMatch(serverName, "[^a-zA-Z .,-]")
   RecoverFromMacrosGoneWild("The server name has weird characters in it (error 11)", serverName)
iniPP("AddScorecardEntry-10")

Click(620, 237, "left")
Click(612, 254, "left")
Click(1254, 167, "left")
Click(922, 374, "left double")
Send, {CTRLDOWN}a{CTRLUP}
iniPP("AddScorecardEntry-11")
status:=CopyWait("slow")
iniPP("AddScorecardEntry-12")
FormatTime, today, , M/d/yyyy

;if we're in testing mode
if (serverName == "testing testing testing")
   status=testing testing testing

if RegExMatch(status, "[^a-zA-Z ]")
   RecoverFromMacrosGoneWild("The status has weird characters in it (error 12)", serverName)
if InStr(status, "Cancelled")
   RecoverFromMacrosGoneWild("It looks like this one was cancelled (error 5)", status)

;TODO add the dates to this macro
;take the Issue Date and put it into  the SPS field of the excel sheet
;take the Case Status Date and put it in the Status Closed field of the Excel Sheet

Click(911, 371, "left")
Click(867, 397, "left")
Click(1264, 399, "left")
IfWinExist, The page at https://www.status-pro.biz says: ahk_class MozillaDialogClass
   RecoverFromMacrosGoneWild("The website gave us an odd error (error 6)", "screenshot")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FocusNecessaryWindow(excel)

;translate server name, if they go by something else
namesIni:=GetPath("FireflyConfig.ini")
replacementName := IniRead(namesIni, "NameTranslations", serverName)
if (replacementName != "ERROR")
   serverName := replacementName

;DELETEME remove this before moving live
ss()
Send, {UP 50}{LEFT}{UP 50}{LEFT}
ss()
Send, {RIGHT}
ss()
Send, {DOWN}
ss()
iniPP("AddScorecardEntry-13")

;Loop to find the first empty column
Loop
{
   Send, {RIGHT}
   sleep, 100
   thisCell:=CopyWait("slow")
   sleep, 100
   if NOT RegExMatch(thisCell, "[A-Za-z]")
      break
}

if (serverName == "testing testing testing")
   serverName=Michael Hollihan

;ss()
iniPP("AddScorecardEntry-14")
Send, %serverName%{ENTER}
Send, AHmbaustian{ENTER}
Send, %today%{ENTER}
Send, %referenceNumber%{ENTER}
iniPP("AddScorecardEntry-15")
;ServiceCountyRequired:=CopyWaitMultipleAttempts("slow")
ServiceCountyRequired := CopyWait("slow")
iniPP("AddScorecardEntry-16")
;perhaps the error 17 should be moved here in case if macros go wild...

Send, {ENTER}
Send, {DOWN}
Send, {ENTER}
Send, {ENTER}
Send, {ENTER}
Send, {ENTER}
Send, {ENTER}
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
Send, {ENTER}
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
Send, {ENTER}
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
Send, {ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}
Send, {SHIFTDOWN}n{SHIFTUP}{DEL}{ENTER}
iniPP("AddScorecardEntry-17")
if NOT RegExMatch(ServiceCountyRequired, "[A-Za-z]")
   RecoverFromMacrosGoneWild("The sevice county required field seems to be empty (error 17)", ServiceCountyRequired)
if NOT InStr(ServiceCountyRequired, "Service County Not Required")
{
   msg=It looks like you need a Service County - it says: %ServiceCountyRequired%
   msgbox, , , %msg%, 0.5
   AddToTrace("grey line ServiceCountyRequired was: ", ServiceCountyRequired)
}

;TODO maybe we should save the excel sheet right here and make a backup, too

EndOfMacro()
return
;}}}

;{{{ButtonAddScorecardEntry-yn:
ButtonAddScorecardEntry-yn:
timer:=StartTimer()
StartOfMacro()

;notify us of possible issues in the alias names ini
namesIni:=GetPath("FireflyConfig.ini")
allNames:=IniListAllKeys(namesIni, "NameTranslations")
;Loop, parse, allNames, CSV
;{
   ;if RegExMatch(A_LoopField, "[,.]")
      ;RecoverFromMacrosGoneWild("Found commas or periods in the " . namesIni . " (error 22) specifically:", A_LoopField)
;}

FindTopOfFirefoxPage()

referenceNumber:=GetReferenceNumber()
serverName:=GetServerName()
status:=GetStatus()

time:=ElapsedTime(timer)
;FOR TESTING PURPOSES
;debug(referenceNumber, serverName, status, time)
;RecoverFromMacrosGoneWild("Testing (error 00)")

if InStr(status, "Cancelled")
   RecoverFromMacrosGoneWild("It looks like this one was cancelled (error 5)", status)

IfWinExist, The page at https://www.status-pro.biz says: ahk_class MozillaDialogClass
   RecoverFromMacrosGoneWild("The website gave us an odd error (error 6)", "screenshot")

;translate server name, if they go by something else
replacementName := IniRead(namesIni, "NameTranslations", PrepIniKeyServerName(serverName))
if (replacementName != "ERROR")
   serverName := replacementName


FormatTime, today, , MM/dd/yyyy
;#############################################################
FocusNecessaryWindow(excel)

;DELETEME remove this before moving live
ss()
Send, {UP 50}{LEFT}
;TODO try removing one of these first
Send, {UP 50}{LEFT}
ss()
Send, {DOWN}
ss()

;Loop to find the first empty column
Loop
{
   Send, {RIGHT}
   Send, ^c
   Sleep, 100
   if NOT RegExMatch(Clipboard, "[A-Za-z]")
      break
}

Clipboard := "null"
ss()
SendInput, %serverName%{ENTER}
SendInput, Melinda Baustian{ENTER}
SendInput, %today%{ENTER}
SendInput, %referenceNumber%{ENTER}
Sleep, 100
Send, ^c
Sleep, 100
loop
{
   ServiceCountyRequired := Clipboard
   if (ServiceCountyRequired != "null")
      break
   sleep, 100
}

Send, {ENTER}
Send, {DOWN}
Send, {ENTER}
Send, {ENTER}
Send, {ENTER}
Send, {ENTER}
Send, {ENTER}
Send, {ENTER}
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
Send, {ENTER}
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
Send, {ENTER}
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
;Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
Send, {ENTER}
Send, {ENTER}
;Send, {SHIFTDOWN}-{SHIFTUP}{DEL}{ENTER}
Send, {ENTER}
Send, {ENTER}
;Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
;Send, {ENTER}{ENTER}{ENTER}{ENTER}
Send, {SHIFTDOWN}n{SHIFTUP}{DEL}{ENTER}

;TODO
if (ServiceCountyRequired == "`r`n")
   {} ;iniPP("(error 26)-ServiceCountyRequired-was-blank-" . ServiceCountyRequired) ; {} ;do nothing
else if InStr(ServiceCountyRequired, "Service County Not Required")
   {} ;iniPP("(error 27)-ServiceCountyRequired-was-not-req" . ServiceCountyRequired) ; {} ;do nothing
else if InStr(ServiceCountyRequired, "Service County Required")
{
   msg=It looks like you need a Service County - it says: %ServiceCountyRequired%
   msgbox, , , %msg%, 0.5
   ;AddToTrace("grey line ServiceCountyRequired was: " . ServiceCountyRequired)
   ;iniPP("(error 28)-ServiceCountyRequired-was-" . ServiceCountyRequired)
}
else
{
   AddToTrace("grey line (error 29) ServiceCountyRequired was: " . ServiceCountyRequired)
   iniPP("(error 29)-ServiceCountyRequired-was-" . ServiceCountyRequired)
}

;REMOVEME once the portion above is finished and working well
;if NOT InStr(ServiceCountyRequired, "Service County Not Required")
;{
   ;msg=It looks like you need a Service County - it says: %ServiceCountyRequired%
   ;;msgbox, , , %msg%, 0.5
   ;;AddToTrace("grey line ServiceCountyRequired was: " . ServiceCountyRequired)
   ;iniPP("(error 21)-ServiceCountyRequired-was-" . ServiceCountyRequired)
;}
;note that this should be true: the number of 26+28+29 = (error 21)

EndOfMacro()
return
;}}}

;{{{ButtonChangeQueue:
ButtonChangeQueue:

;Gui, 2: +LastFound
;HWND := WinExist()
;msgbox % hwnd

Gui, 2: Destroy
Gui, 2: Add, ComboBox, vCity, %cityChoices%
Gui, 2: Add, ComboBox, vClient, %clientChoices%
Gui, 2: Add, Button, Default, Change To This Queue
Gui, 2: Show
return
2ButtonChangeToThisQueue:
Gui, 2: Submit
Gui, 2: Destroy
IniWrite(ini, "firefly", "city", city)
IniWrite(ini, "firefly", "client", client)
GoSub, ButtonReloadQueue

return
;}}}

;{{{ButtonReloadQueue:
ButtonReloadQueue:
StartOfMacro()

;make this into its own function
URLbar := GetURLbar("firefox")
if NOT InStr( URLbar, "status-pro.biz/fc/Portal.aspx" )
   return

FindTopOfFirefoxPage()

BlockInput, MouseMove

CloseStatusProTabs()

ss()
MouseMove, 33, 115
ss()
Click(33, 132, "left control")
Sleep, 200
MouseMove, 33, 198
;ClickIfImageSearch("images/firefly/fileSearch.bmp", "control") ;TODO for reliability
WaitForImageSearch("images/firefly/queueIsLoaded.bmp")
Click(259, 182, "left control")
Sleep, 200
SendSlow(city, slowSendPauseTime)
ss()
Click(284, 206, "left control")
ss()
Click(278, 230, "left control")
Sleep, 200
SendSlow(client, slowSendPauseTime)
ss()
Click(280, 250, "left control")
ss()
;Click(241, 255, "left control")
ss()
ss()
Click(241, 255, "left control")
Sleep, 500
Click(855, 282, "left control")
ss()
Click(855, 282, "left control")

;if ForceWinFocusIfExist(statusProMessage)
;{
   ;;if the message is "error... current action" then we should try again slowly, but only try it again once...
   ;WinClose ;this also makes the webapp freak out so maybe we shouldn't do it
   ;;Send, ^{F5} ;this makes the webapp freak out... press the reload button in FF instead
   ;;GoSub, ButtonReloadQueue
;}

EndOfMacro()
return
;}}}

;{{{ ButtonLoadReferenceNumber:
ButtonLoadReferenceNumber:
StartOfMacro()

referenceNumber:=Prompt("Which reference number would you like to load?")
if NOT referenceNumber
   referenceNumber=2461358

;strip off excess chars
RegExMatch(referenceNumber, "(\d+)", match)
referenceNumber:=match1

BlockInput, MouseMove
OpenReferenceNumber(referenceNumber)

EndOfMacro()
return
;}}}

;{{{ ButtonX: and 2ButtonX:
ButtonX:
ExitApp
return

;FIXME not sure why this is broken
;   this should now be fixed
2GuiClose:
Gui, 2: Destroy
return
;}}}

;{{{ButtonRecordForCameron:
ButtonRecordForCameron:
if NOT ProcessExist("HyCam2.exe")
{
   RunProgram("C:\Program Files\HyCam2\HyCam2.exe")
   ForceWinFocus("HyperCam")
   SleepSeconds(1)
   Send, {F2}
}
else
{
   Send, {F2}
   WinWait, HyperCam, , 1
   WinClose, HyperCam
   SleepSeconds(1)
   ProcessCloseAll("HyCam2.exe")
}
return
;}}}

;{{{ ButtonTestSomething:
ButtonTestSomething:
;StartOfMacro()
;debug("starting to test something")


;debug("finished testing something")
;EndOfMacro()
return
;}}}

;{{{ ButtonNotes:
ButtonNotes:
StartOfMacro()
notes=
(
Here's an overview of the different versions of the buttons at the moment (newest is at the bottom):

ASE-st: Ok... I did a couple things here... I made it a bit better at copying the status, and I also made the macro faster. I think that the earlier versions are super-reliable, so I decided I would try to make them faster now.

ASE-mf: More functions... this should make things easier on me. You shouldn't notice a difference.

ASE-sc: Tried a different way to detect the Service County... this should make things a little easier on me.

ASE-new: for the new scorecard

ASE-fw: fewer messages are sent to Cameron, plus the first few fields of the scorecard should be typed in faster (hopefully that is reliable)

ASE-yn: Trying to get the yesses and nos in the correct places... if I'm wrong, email me a screenshot of what it should look like instead.

Load Reference Number: It loads a specified file with the reference number that you give it.

Fetch RefNums Csv: Opens the Reference Numbers CSV of all of the files that you have to go back through and review/approve.
)
debug("notimeout", "`n" . notes)
EndOfMacro()
return
;}}}

;{{{ ButtonReportUndesiredError:
ButtonReportUndesiredError:
StartOfMacro()

lastError:=IniRead(GetPath("MyStats.ini"), CurrentTime("hyphendate"), "FireflyMostRecentError")
;message=This will send a message letting Cameron know that the most recent error should not have occurred
message=This will send a message letting Cameron know that the most recent error should not have occurred, do you want to continue?`n`nThe error that will be reported is:`n%lastError%`n`n
if UserDoesntWantToRunMacro(message)
   return

delog("red line", "Melinda thinks that the error that just happened should not have occurred", "The error was:", lastError)
debug("nolog", "Thanks! This issue has been reported to Cameron")
EndOfMacro()
return
;}}}

