#include FcnLib.ahk
#include FcnLib-Clipboard.ahk
#include FcnLib-Nightly.ahk
#include SendEmailSimpleLib.ahk
#NoTrayIcon

;{{{ TODOs
;TODO add dates to "Add Scorecard Entry"
;FIXME Auto-expand all pluses in the left-hand side
;TODO change text in the MS-Word lookalike program (cause their template is wrong)
;TODO make in-depth fees gui
;TODO make background blueish to match sidebar
;TODO default PS Fee to $10

;TODO make a macro that tests their site and determines if the site is going slower than normal and logs out/in again
;TODO make macros more robust so that I can upgrade firefox
;TODO fix how it changes the server name in add scorecard entry by picking other items in the dropdown
;TODO restore the name substitution feature that was once in add scorecard entry

;FIXME FIXME FIXME
;Can you see at the top, in the middle, above the Process Server Name, there is some info in blue? I think that sometimes there is alot of information there so the rest of the page is skewed and the macro ends up copypasting randomness all around.
;I don't know if this is really part of the issue but thought I would throw it out. I was trying to add a scorecard entry on this one when the macros went wild.
;end FIXME - from an email Mel sent on 11-22-2011 around 3:30pm

;Items that don't seem to be important anymore (or things that I think I've finished):
;WRITEME firefly: make paste paste without formatting in the MS-Word lookalike program
;Reload Queue is not reliable when I am in a file
;REMOVEME - I think this is working well now - Sometimes the server's name in the file does not match the name in the scorecard, can you make it so that the macro still works and just leaves the name blank on the scorecard (right now it enters all the information one field off)?
;REMOVEME - I think I did remove this part of the code (2011-11-10)... The "Would you like to approve?" box never shows up anymore. Don't know if you would want to remove that code?
;TODO make scorecard faster
;}}}

;{{{Globals and making the gui (one-time tasks)
cityChoices=Tampa|Ft. Lauderdale|Orlando|Jacksonville
clientChoices=Albertelli Law|FDLG|Florida Foreclosure Attorneys, PLLC|Gladstone Law Group, P.A.|Marinosci Law Group, PC - Florida|Pendergast & Morgan, P.A.|Shapiro & Fishman, LLP|Law Offices of Douglas C. Zahm, P.A.

ini := GetPath("myconfig.ini")
city := IniRead(ini, "firefly", "city")
client := IniRead(ini, "firefly", "client")

statusProMessage=The page at https://www.status-pro.biz says: ahk_class MozillaDialogClass
firefox=Status Pro Initial Catalog.*Firefox
excel=(In House Process Server Scorecard|Process Server Fee Determination).*(OpenOffice.org|LibreOffice) Calc

;this is for the retarded comboboxes...
slowSendPauseTime=130
;breaks at 100,110 reliable at 120,150

;figure out the coordinates where we will place the window
xLocation=1770
yLocation=550
if (A_ComputerName == "T-800")
{
   xLocation=1129
   yLocation=171
}

Gui, +LastFound -Caption +ToolWindow +AlwaysOnTop
;Gui, Color, 000032
Gui, Add, Button, , Reload Queue
Gui, Add, Button, , Change Queue
;Gui, Add, Button, , Add Scorecard Entry-ns
;Gui, Add, Button, , Add Scorecard Entry-sub2
Gui, Add, Button, , Add Scorecard Entry-sub3
Gui, Add, Button, , Add Scorecard Entry-fcn
Gui, Add, Button, , Add Fees
Gui, Add, Button, , Refresh Login

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

;this seems to fail
;pid:=GetPID("firefox.exe")
;debug(pid)
;Process, Close, %pid%
;Loop 10
   ;Process, Close, firefox.exe

;this seems to work
CustomTitleMatchMode("Contains")
while ProcessExist("firefox.exe")
{
   WinClose, Mozilla Firefox
   Sleep, 100
}

;other attempts to kill FF
;Process, Close, Plugin_container.exe
;Process, Close, firefox.exe
;Process, Close, Plugin_container.exe
;Process, Close, firefox.exe

;start firefox again ; this method is a little difficult, imacros will be easier
RunProgram("C:\Program Files\Mozilla Firefox\firefox.exe")
panther:=SexPanther("melinda")
imacro=
(
TAB CLOSEALLOTHERS
URL GOTO=gmail.com
TAG POS=1 TYPE=INPUT:TEXT FORM=ACTION:https://accounts.google.com/ServiceLoginAuth ATTR=ID:Email CONTENT=melindabaustian@gmail.com
SET !ENCRYPTION NO
TAG POS=1 TYPE=INPUT:PASSWORD FORM=ACTION:https://accounts.google.com/ServiceLoginAuth ATTR=ID:Passwd CONTENT=%panther%
TAG POS=1 TYPE=INPUT:SUBMIT FORM=ID:gaia_loginform ATTR=ID:signIn
TAB OPEN
TAB T=2
URL GOTO=https://www.status-pro.biz/dashboard/Default.aspx
TAG POS=1 TYPE=INPUT:TEXT FORM=NAME:form1 ATTR=ID:LoginUser_UserName CONTENT=ICmbaustian
SET !ENCRYPTION NO
TAG POS=1 TYPE=INPUT:PASSWORD FORM=NAME:form1 ATTR=ID:LoginUser_Password CONTENT=%panther%
TAG POS=1 TYPE=INPUT:SUBMIT FORM=ID:form1 ATTR=ID:LoginUser_LoginButton
TAG POS=1 TYPE=A ATTR=TXT:Click<SP>Here<SP>to<SP>Log<SP>Into<SP>FC
)
RunIMacro(imacro)
;Sleep 500
WinWaitActive, %statusProMessage%
;Sleep 500
if SimpleImageSearch("images/firefly/dialog/thereWasAnErrorHandlingYourCurrentAction.bmp")
   Click(170, 90, "control") ;center ok button
;Sleep 500
GoSub, ButtonReloadQueue
return
;}}}

;{{{ButtonAddFees:
ButtonAddFees:
StartOfMacro()

if CantFocusNecessaryWindow(firefox)
   return
if CantFindTopOfFirefoxPage()
   return

Gui, 2: Add, Text,, Service of Process
Gui, 2: Add, Text,, Process Server Fees
Gui, 2: Add, Text,, Locate
Gui, 2: Add, Text,, Pinellas County Sticker
Gui, 2: Add, Edit, vFeesVar1 x100 y2
Gui, 2: Add, Edit, vFeesVar2
Gui, 2: Add, Edit, vFeesVar3
Gui, 2: Add, Edit, vFeesVar4
Gui, 2: Add, Button, Default x190 y110, Go
Gui, 2: Show, , Firefly Fees AHK Dialog
Gui, 2: Show
return
2ButtonGo:
Gui, 2: Submit
Gui, 2: Destroy

;REMOVEME
;feesvar1=10
;feesvar2=20
;feesvar3=30
;feesvar4=3
;timer:=startTimer()

if NOT (feesVar4 == "" or feesVar4 == 3)
{
   errord("notimeout", "Pinellas County Sticker Fee should be either blank or 3")
   return
}

if CantFocusNecessaryWindow(firefox)
   return
if CantFindTopOfFirefoxPage()
   return

OpenFeesWindow()

;Sleep, 200 ;this seems to work sometimes... kinda
;Sleep, 500
   Sleep, 500

list=Service of Process,Process Server Fees,Locate,Pinellas County Sticker
Loop, parse, list, CSV
{
   thisFee:=A_LoopField
   i:=A_Index
   thisFeeAmount:=FeesVar%i%
   thisFeeType=Client
   if (i == 2)
      thisFeeType=Process Server
   if (thisFeeAmount == "")
     continue

   ;TODO reliability would increase in this fcn if the sleeps were larger (perhaps this could run in the background bot)
   Click(600, 667, "left control")
   Send, %thisFeeType%
   Send, {TAB}
   Send, %thisFee%
   Send, {TAB}
   Send, %thisFeeAmount%
   Click(611, 476, "left control") ;Click Add


   ;ugh, this sleep is huge... maybe we should wait for it to appear in the list
   Sleep, 900
   ;Sleep, 500
   ;Sleep, 500
}

;this should be done after the loop
Click(1246, 425, "left control") ;Click the X

;TODO might want to sanity check this to ensure that the fees were added correctly by checking the "Client Fees" and "Process Server Fees"
;debug(elapsedTime(timer))

EndOfMacro()
return
;}}}

;{{{ButtonAddScorecardEntry-Experimental:
ButtonAddScorecardEntry-Experimental:
StartOfMacro()
iniPP("AddScorecardEntry-01")

if CantFocusNecessaryWindow(firefox)
   return
iniPP("AddScorecardEntry-02")
if CantFindTopOfFirefoxPage()
   return
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
if CantFocusNecessaryWindow(excel)
   return

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
Send, ICMbaustian{ENTER}
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

;{{{ButtonAddScorecardEntry-ns:
ButtonAddScorecardEntry-ns:
StartOfMacro()

if CantFocusNecessaryWindow(firefox)
   return
if CantFindTopOfFirefoxPage()
   return

ss()
Click(1100, 165, "left double")
ss()
Send, {CTRLDOWN}c{CTRLUP}
ss()

referenceNumber:=Clipboard
if NOT RegExMatch(referenceNumber, "[0-9]{5}")
   RecoverFromMacrosGoneWild("I didn't get the reference number (scroll up, maybe?) (error 14)", referenceNumber)

;old
;Click(620, 237, "left double")
StatusProCopyField(720, 237)
ss()
;Send, {CTRLDOWN}a{CTRLUP}{CTRLDOWN}c{CTRLUP}
;copy the server
;TODO use the StatusProCopyField() for all copies

Click(620, 237, "left")
ss()
Click(612, 254, "left")
ss()
Click(1254, 167, "left")
ss()
Click(922, 374, "left double")
ss()
server:=Clipboard

;for testing purposes
;debug(referenceNumber, server)
;RecoverFromMacrosGoneWild("Testing (error 00)")

Send, {CTRLDOWN}a{CTRLUP}{CTRLDOWN}c{CTRLUP}
Click(911, 371, "left")
ss()
Click(867, 397, "left")
ss()
Click(1264, 399, "left")
ss()
status:=Clipboard
FormatTime, today, , M/d/yyyy
if InStr(status, "Cancelled")
   RecoverFromMacrosGoneWild("It looks like this one was cancelled (error 5)", status)

IfWinExist, The page at https://www.status-pro.biz says: ahk_class MozillaDialogClass
   RecoverFromMacrosGoneWild("The website gave us an odd error (error 6)", "screenshot")


;;;;;;;;;;;;;;;;
if CantFocusNecessaryWindow(excel)
   return

;DELETEME remove this before moving live
ss()
Send, {UP 50}{LEFT}{UP 50}{LEFT}
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
iniPP("server-" . server)

Clipboard := "null"
ss()
Send, %server%{ENTER}
Send, ICMbaustian{ENTER}
Send, %today%{ENTER}
Send, %referenceNumber%{ENTER}
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

;Send, {ENTER}
;Send, {DOWN}
;Send, {ENTER}
;Send, {ENTER}
;Send, {ENTER}{ENTER}{ENTER}{ENTER}
;Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
;Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
;Send, {ENTER}
;Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
;Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
;Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}

;Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
;Send, {ENTER}
;Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
;Send, {ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}
;Send, {SHIFTDOWN}n{SHIFTUP}{DEL}{ENTER}
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

ss()

if NOT RegExMatch(ServiceCountyRequired, "[A-Za-z]")
{
   SaveScreenShot("firefly-error-17")
   AddToTrace("The sevice county required field seems to be empty (error 17)", ServiceCountyRequired)
   iniPP("error 17")
   ;UNSURE this was throwing so many errors that I just decided I wanted to investigate it a little
   ;RecoverFromMacrosGoneWild("The sevice county required field seems to be empty (error 17)", ServiceCountyRequired)
}

;if NOT InStr(ServiceCounty, "Service County Not Required")
   ;msgbox, , , It looks like you need a Service County - it says: %ServiceCounty% %Clipboard%, 0.5
if NOT InStr(ServiceCountyRequired, "Service County Not Required")
{
   msg=It looks like you need a Service County - it says: %ServiceCountyRequired%
   msgbox, , , %msg%, 0.5
   AddToTrace("grey line ServiceCountyRequired was: ", ServiceCountyRequired)
}
;ss()

EndOfMacro()
return
;}}}

;{{{ButtonAddScorecardEntry-sub2:
ButtonAddScorecardEntry-sub2:
StartOfMacro()

if CantFocusNecessaryWindow(firefox)
   return
if CantFindTopOfFirefoxPage()
   return

ss()
Click(1100, 165, "left double")
ss()
Send, {CTRLDOWN}c{CTRLUP}
ss()

referenceNumber:=Clipboard
if NOT RegExMatch(referenceNumber, "[0-9]{5}")
   RecoverFromMacrosGoneWild("I didn't get the reference number (scroll up, maybe?) (error 14)", referenceNumber)

StatusProCopyField(720, 237)
ss()
;TODO use the StatusProCopyField() for all copies

Click(620, 237, "left")

ss()
Click(612, 254, "left")
ss()
Click(1254, 167, "left")
ss()
Click(922, 374, "left double")
ss()
serverName:=Clipboard

Send, {CTRLDOWN}a{CTRLUP}{CTRLDOWN}c{CTRLUP}
Click(911, 371, "left")
ss()
Click(867, 397, "left")
ss()
Click(1264, 399, "left")
ss()
status:=Clipboard
FormatTime, today, , M/d/yyyy
if InStr(status, "Cancelled")
   RecoverFromMacrosGoneWild("It looks like this one was cancelled (error 5)", status)

IfWinExist, The page at https://www.status-pro.biz says: ahk_class MozillaDialogClass
   RecoverFromMacrosGoneWild("The website gave us an odd error (error 6)", "screenshot")


;for testing purposes
;debug(referenceNumber, serverName)
;RecoverFromMacrosGoneWild("Testing (error 00)")

;#############################################################
if CantFocusNecessaryWindow(excel)
   return

;translate server name, if they go by something else
namesIni:=GetPath("FireflyConfig.ini")
replacementName := IniRead(namesIni, "NameTranslations", serverName)
if (replacementName != "ERROR")
   serverName := replacementName

;DELETEME remove this before moving live
ss()
Send, {UP 50}{LEFT}{UP 50}{LEFT}
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
;iniPP("server-" . server)

Clipboard := "null"
ss()
Send, %serverName%{ENTER}
Send, ICMbaustian{ENTER}
Send, %today%{ENTER}
Send, %referenceNumber%{ENTER}
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

ss()

if NOT RegExMatch(ServiceCountyRequired, "[A-Za-z]")
{
   SaveScreenShot("firefly-error-17")
   AddToTrace("The sevice county required field seems to be empty (error 17)", ServiceCountyRequired)
   iniPP("(error 17)-BlankServiceCountyRequired")
   ;UNSURE this was throwing so many errors that I just decided I wanted to investigate it a little
   ;RecoverFromMacrosGoneWild("The sevice county required field seems to be empty (error 17)", ServiceCountyRequired)
}

;if NOT InStr(ServiceCounty, "Service County Not Required")
   ;msgbox, , , It looks like you need a Service County - it says: %ServiceCounty% %Clipboard%, 0.5
if NOT InStr(ServiceCountyRequired, "Service County Not Required")

{
   msg=It looks like you need a Service County - it says: %ServiceCountyRequired%
   msgbox, , , %msg%, 0.5
   AddToTrace("grey line ServiceCountyRequired was: ", ServiceCountyRequired)
   iniPP("(error 21)-ServiceCountyRequired-was-" . ServiceCountyRequired)
}
;ss()

EndOfMacro()
return
;}}}

;{{{ButtonAddScorecardEntry-sub3:
ButtonAddScorecardEntry-sub3:
StartOfMacro()

;notify us of possible issues in the alias names ini
namesIni:=GetPath("FireflyConfig.ini")
allNames:=IniListAllKeys(namesIni, "NameTranslations")
Loop, parse, allNames, CSV
{
   if RegExMatch(A_LoopField, "[,.]")
      RecoverFromMacrosGoneWild("Found commas or periods in the " . namesIni . " (error 22) specifically:", A_LoopField)
}

if CantFocusNecessaryWindow(firefox)
   return
if CantFindTopOfFirefoxPage()
   return

;start of getting reference number
ss()
Click(1100, 165, "left double")
ss()
Send, {CTRLDOWN}c{CTRLUP}
ss()

referenceNumber:=Clipboard
if NOT RegExMatch(referenceNumber, "[0-9]{5}")
   RecoverFromMacrosGoneWild("I didn't get the reference number (scroll up, maybe?) (error 14)", referenceNumber)

StatusProCopyField(720, 237)
ss()
;TODO use the StatusProCopyField() for all copies

Click(620, 237, "left")

ss()
Click(612, 254, "left")
ss()
Click(1254, 167, "left")
ss()
Click(922, 374, "left double")
ss()
serverName:=Clipboard

Send, {CTRLDOWN}a{CTRLUP}{CTRLDOWN}c{CTRLUP}
Click(911, 371, "left")
ss()
Click(867, 397, "left")
ss()
Click(1264, 399, "left")
ss()
status:=Clipboard
FormatTime, today, , M/d/yyyy
if InStr(status, "Cancelled")
   RecoverFromMacrosGoneWild("It looks like this one was cancelled (error 5)", status)

IfWinExist, The page at https://www.status-pro.biz says: ahk_class MozillaDialogClass
   RecoverFromMacrosGoneWild("The website gave us an odd error (error 6)", "screenshot")

;translate server name, if they go by something else
replacementName := IniRead(namesIni, "NameTranslations", PrepIniKeyServerName(serverName))
if (replacementName != "ERROR")
   serverName := replacementName



;for testing purposes
;debug(referenceNumber, serverName)
;RecoverFromMacrosGoneWild("Testing (error 00)")

;#############################################################
if CantFocusNecessaryWindow(excel)
   return

;DELETEME remove this before moving live
ss()
Send, {UP 50}{LEFT}{UP 50}{LEFT}
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
;iniPP("server-" . server)

Clipboard := "null"
ss()
Send, %serverName%{ENTER}
Send, ICMbaustian{ENTER}
Send, %today%{ENTER}
Send, %referenceNumber%{ENTER}
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

ss()

if NOT RegExMatch(ServiceCountyRequired, "[A-Za-z]")
{
   SaveScreenShot("firefly-error-17")
   AddToTrace("The sevice county required field seems to be empty (error 17)" . ServiceCountyRequired)
   iniPP("(error 17)-BlankServiceCountyRequired")
   ;UNSURE this was throwing so many errors that I just decided I wanted to investigate it a little
   ;RecoverFromMacrosGoneWild("The sevice county required field seems to be empty (error 17)", ServiceCountyRequired)
}

if NOT InStr(ServiceCountyRequired, "Service County Not Required")

{
   msg=It looks like you need a Service County - it says: %ServiceCountyRequired%
   msgbox, , , %msg%, 0.5
   AddToTrace("grey line ServiceCountyRequired was: " . ServiceCountyRequired)
   iniPP("(error 21)-ServiceCountyRequired-was-" . ServiceCountyRequired)
}
;ss()

EndOfMacro()
return
;}}}

;{{{ButtonAddScorecardEntry-fcn:
ButtonAddScorecardEntry-fcn:
StartOfMacro()

;notify us of possible issues in the alias names ini
namesIni:=GetPath("FireflyConfig.ini")
allNames:=IniListAllKeys(namesIni, "NameTranslations")
Loop, parse, allNames, CSV
{
   if RegExMatch(A_LoopField, "[,.]")
      RecoverFromMacrosGoneWild("Found commas or periods in the " . namesIni . " (error 22) specifically:", A_LoopField)
}

if CantFocusNecessaryWindow(firefox)
   return
if CantFindTopOfFirefoxPage()
   return

;start of getting reference number
referenceNumber:=GetReferenceNumber()

;start of getting server name
StatusProCopyField(720, 237)
ss()
;TODO use the StatusProCopyField() for all copies

Click(620, 237, "left")

ss()
Click(612, 254, "left")
ss()
Click(1254, 167, "left")
ss()
Click(922, 374, "left double")
ss()
serverName:=Clipboard

Send, {CTRLDOWN}a{CTRLUP}{CTRLDOWN}c{CTRLUP}
Click(911, 371, "left")
ss()
Click(867, 397, "left")
ss()
Click(1264, 399, "left")
ss()
status:=Clipboard
FormatTime, today, , M/d/yyyy
if InStr(status, "Cancelled")
   RecoverFromMacrosGoneWild("It looks like this one was cancelled (error 5)", status)

IfWinExist, The page at https://www.status-pro.biz says: ahk_class MozillaDialogClass
   RecoverFromMacrosGoneWild("The website gave us an odd error (error 6)", "screenshot")

;translate server name, if they go by something else
replacementName := IniRead(namesIni, "NameTranslations", PrepIniKeyServerName(serverName))
if (replacementName != "ERROR")
   serverName := replacementName



;for testing purposes
debug(referenceNumber, serverName)
RecoverFromMacrosGoneWild("Testing (error 00)")

;#############################################################
if CantFocusNecessaryWindow(excel)
   return

;DELETEME remove this before moving live
ss()
Send, {UP 50}{LEFT}{UP 50}{LEFT}
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
;iniPP("server-" . server)

Clipboard := "null"
ss()
Send, %serverName%{ENTER}
Send, ICMbaustian{ENTER}
Send, %today%{ENTER}
Send, %referenceNumber%{ENTER}
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

ss()

if NOT RegExMatch(ServiceCountyRequired, "[A-Za-z]")
{
   SaveScreenShot("firefly-error-17")
   AddToTrace("The sevice county required field seems to be empty (error 17)" . ServiceCountyRequired)
   iniPP("(error 17)-BlankServiceCountyRequired")
   ;UNSURE this was throwing so many errors that I just decided I wanted to investigate it a little
   ;RecoverFromMacrosGoneWild("The sevice county required field seems to be empty (error 17)", ServiceCountyRequired)
}

if NOT InStr(ServiceCountyRequired, "Service County Not Required")

{
   msg=It looks like you need a Service County - it says: %ServiceCountyRequired%
   msgbox, , , %msg%, 0.5
   AddToTrace("grey line ServiceCountyRequired was: " . ServiceCountyRequired)
   iniPP("(error 21)-ServiceCountyRequired-was-" . ServiceCountyRequired)
}
;ss()

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

URLbar := GetURLbar("firefox")
if NOT InStr( URLbar, "status-pro.biz/fc/Portal.aspx" )
   return

if CantFocusNecessaryWindow(firefox)
   return
if CantFindTopOfFirefoxPage()
   return

BlockInput, MouseMove

;move to top of page
;Click(1160, 200, "control")
;ss()
;Send, {PGUP 20}
;ss()

Loop 10
   ClickIfImageSearch("images/firefly/closeTab.bmp", "control")

ss()
MouseMove, 33, 115
ss()
Click(33, 132, "left control")
Sleep, 200
MouseMove, 33, 198
;ClickIfImageSearch("images/firefly/fileSearch.bmp", "control") ;TODO for reliability
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
debug("starting to test something")
iniPP(A_ThisLabel)
RecoverFromMacrosGoneWild("Worse Than Failure")
debug("finished testing something")
return
;}}}

;{{{ ButtonNotes:
ButtonNotes:
StartOfMacro()
notes=
(
Here's an overview of the different versions of the buttons at the moment (newest is at the bottom):

ASE-sub2: (I got rid of this because it conflicted with sub3. Let me know if sub3 is broken, and I can restore sub2. ... My second attempt of fixing the "alias" feature. (Changes aliases like: Micky F. Hollihan --> Michael Hollihan)

ASE-sub3: I changed the alias feature so that you don't need commas or periods in the key. This should make it more adaptive.

ASE-fcn: This is something I started experimenting with to make programming easier on me. This might make getting the reference number more or less reliable. Not sure.
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


;{{{ functions

ss()
{
   Sleep, 100
}

ArrangeWindows()
{
   global
   WinRestore, Mozilla Firefox
   WinRestore, %firefox%
   WinRestore, %excel%
   WinMove, Mozilla Firefox, , 0, 0, 1766, 1020
   WinMove, %firefox%, , 0, 0, 1766, 1020
   WinMove, %excel%  , , 0, 0, 1766, 1020
   If InStr(WinGetActiveTitle(), excel) OR InStr(WinGetActiveTitle(), firefox)
      Send, ^!{NUMPAD5}
}

CantFocusNecessaryWindow(window)
{
   if (window == "")
      RecoverFromMacrosGoneWild("Cameron did something wrong, the window variable was blank")

   if NOT ForceWinFocusIfExist(window)
      RecoverFromMacrosGoneWild("couldn't find this window: " . window)
}

CantFindTopOfFirefoxPage()
{
   ;TODO do some clicking to scroll up

   topOfPageIsVisible := SimpleImageSearch("images/firefly/HomeTab.bmp")
      OR SimpleImageSearch("images/firefly/AffidavitsTab.bmp")
      OR SimpleImageSearch("images/firefly/AffidavitsTab7.bmp")
      OR SimpleImageSearch("images/firefly/HomeTab7.bmp")
      OR SimpleImageSearch("images/firefly/topOfPage.bmp")
      OR SimpleImageSearch("images/firefly/topOfPage2.bmp")

   if NOT topOfPageIsVisible
      RecoverFromMacrosGoneWild("can't find the top of the page in firefox")

   ;do a couple more clicks, just to make sure we're at the very, very top
   Loop 10
      Click(1760, 124, "control")
      ;Click(1753, 104, "control")
}


UserDoesntWantToRunMacro(macroName="")
{
   if NOT macroName
      macroName:=GetButtonName()

   if (strlen(macroName) < 25)
      message=You clicked the %macroName% button
   else
      message:=macroName

   message.=", do you really want to continue?"

   MsgBox, 4, , %message%
   IfMsgBox, No
   {
      ;This isn't an error at all! they just decided they didn't want to run it
      ;RecoverFromMacrosGoneWild("aborting macro (user decided they didn't want to run it)")

      EndOfMacro(A_ThisFunc)
      return true
   }
}

;TODO maybe this should be moved into the fcn lib?
; Then again, maybe this is such a stupid, annoying Ghetto-hack that we don't want to
GetButtonName()
{
   returned:=RegExReplace(A_ThisLabel, "([A-Z])", " $1")
   returned:=StringReplace(returned, "Button")
   returned:=RegExReplace(returned, "^ +")
   return returned
}

PrepIniKey(text)
{
   returned:=RegExReplace(text, "(\r|\n)")
   return returned
}

PrepIniKeyServerName(text)
{
   returned:=RegExReplace(text, "(,|.|\n|\r)")
   return returned
}

RecoverFromMacrosGoneWild(message="", options="")
{
   iniPP(A_ThisFunc)
   EndOfMacro(A_ThisFunc)
   ini:=GetPath("MyStats.ini")
   section:=CurrentTime("hyphendate")
   MostRecentError=%message% %options%
   IniWrite(ini, section, "FireflyMostRecentError", message)

   ;take a screenshot, if desired
   if InStr(options, "screenshot")
      SaveScreenShot(A_ScriptName . "-" . message)

   ;do I want errord? or do I want a msgbox? ;prolly not msgbox cause we might want to log it
   if message
   {
      ;UNSURE Not sure, maybe this should be at the top of the function? (2011-12-02) ;removed 2011-12-10
      ;message=ERROR: %message%

      iniPP(message)
      errord(message, A_ScriptName, A_ThisFunc, A_LineNumber, options)
   }

   Reload()
}

StartOfMacro()
{
   ;time:=CurrentTime("hyphenated")
   ;IniWrite(ini, "tracelogs", time, A_ThisLabel)

   iniPP("PressedAButton") ;yeah, we're basically denoting this twice in a row (PressedAButton will always equal StartOfMacro), but this will make the stats file more readable
   iniPP(A_ThisFunc)
   iniPP(A_ThisLabel) ;make a note that we pressed the button
   iniPP(A_ThisFunc . "-" . A_ThisLabel) ;make a specific note that this macro started/got to the end
   SetCapsLockState, Off
   ArrangeWindows()
}

EndOfMacro(howItEnded="EndOfMacro")
{
   iniPP(howItEnded)
   iniPP(howItEnded . "-" . A_ThisLabel) ;make a specific note that this macro started/got to the end
   if NOT RegExMatch(howItEnded, "^(EndOfMacro|RecoverFromMacrosGoneWild|UserDoesntWantToRunMacro)$")
      IncorrectUsage("noticed you passed an odd param to EndOfMacro(): " . howItEnded)
   BlockInput, MouseMoveOff
}

;note items here that I didn't intend on happening (kinda like a weak compile error)
IncorrectUsage(message)
{
   iniPP("red line-IncorrectUsage")
   delog(A_LineNumber, A_ScriptName, A_ThisFunc, A_ThisLabel, "Noticed an incorrect Usage", message)
}

RecordSuccessfulStartOfFireflyPanel()
{
   iniMostRecentTime("Firefly Panel Loaded (last loaded time)") ;track the last time it was reloaded
   iniPP("Firefly Panel Loaded (number of times)") ;count all the times it was reloaded
}

;Send an email without doing any of the complex queuing stuff
SendEmailFromMelinda(sSubject, sBody, sAttach="", sTo="Erica.Jordan@fireflylegal.com")
{
   if (A_ComputerName != "BAUSTIAN-09PC")
   {
      errord(A_ComputerName, "The macro would normally send an email at this point, but since this is not the home computer, sending the email will be skipped", A_ThisFunc, A_LineNumber, A_ScriptName)
      return
   }
   sUsername := "melindabaustian"
   sPassword := SexPanther("melinda")
   sReplyTo:="melindabaustian@gmail.com"

   sFrom     := sUsername . "@gmail.com"

   sServer   := "smtp.gmail.com" ; specify your SMTP server
   nPort     := 465 ; 25
   bTLS      := True ; False
   nSend     := 2   ; cdoSendUsingPort
   nAuth     := 1   ; cdoBasic

   SendTheFrigginEmail(sSubject, sAttach, sTo, sReplyTo, sBody, sUsername, sPassword, sFrom, sServer, nPort, bTLS, nSend, nAuth)
}

ClickMultipleTimesWithPause(x, y, options, times)
{
   Loop %times%
   {
      Click(x, y, options)
      ss()
   }
}

OpenFeesWindow()
{
   Loop 3
   {
      ClickIfImageSearch("images/firefly/feesButton.bmp")
      ss()
   }
   WaitForImageSearch("images/firefly/feesWizardWindow.bmp")
}

SelectAll()
{
   Send, {CTRLDOWN}{END}{SHIFTDOWN}{HOME}{SHIFTUP}{CTRLUP}
}

;FIXME MAYBE? copypasta was the wrong decision
;  however, I think writing a function would involve some ugly globals, and stuff like that
CopyWaitMultipleAttempts(options="")
{
   success=success

   ;attempt
   returned := CopyWait(options)
   if (NOT (returned == "" OR returned == "") )
   {
      tries++
      msg=CopyWait %success% after %tries% tries
      delog(A_LineNumber, A_ThisFunc, msg, "length was:", strlen(returned) )
      iniPP(msg)
      return returned
   }

   ;attempt
   Sleep, 10
   returned := CopyWait(options)
   if (NOT (returned == "" OR returned == "") )
   {
      tries++
      msg=CopyWait %success% after %tries% tries
      delog(A_LineNumber, A_ThisFunc, msg, "length was:", strlen(returned) )
      iniPP(msg)
      return returned
   }

   ;attempt
   Sleep, 100
   returned := CopyWait(options)
   if (NOT (returned == "" OR returned == "") )
   {
      tries++
      msg=CopyWait %success% after %tries% tries
      delog(A_LineNumber, A_ThisFunc, msg, "length was:", strlen(returned) )
      iniPP(msg)
      return returned
   }

   ;attempt
   Sleep, 250
   returned := CopyWait(options)
   if (NOT (returned == "" OR returned == "") )
   {
      tries++
      msg=CopyWait %success% after %tries% tries
      delog(A_LineNumber, A_ThisFunc, msg, "length was:", strlen(returned) )
      iniPP(msg)
      return returned
   }
   else ;FAILURE
   {
      success=failed
      tries++
      msg=CopyWait %success% after %tries% tries
      delog(A_LineNumber, A_ThisFunc, msg, "length was:", strlen(returned) )
      iniPP(msg)
      return returned
   }

   ;attempt
   ;Sleep, 250
   ;returned := CopyWait(options)
   ;tries++
   ;success=failed
   ;if CanReturnFromCopyWaitMultipleAttempts(A_LineNumber, A_ThisFunc, success, tries, returned)
   ;   return returned
}

CopyWaitMultipleAttempts222(options="")
{
   success=success

   ;attempt
   returned := CopyWait(options)
   if (NOT (returned == "" OR returned == "") )
   {
      tries++
      msg=CopyWait %success% after %tries% tries
      delog(A_LineNumber, A_ThisFunc, msg, "length was:", strlen(returned) )
      iniPP(msg)
      return returned
   }

   ;attempt
   Sleep, 10
   returned := CopyWait(options)
   if (NOT (returned == "" OR returned == "") )
   {
      tries++
      msg=CopyWait %success% after %tries% tries
      delog(A_LineNumber, A_ThisFunc, msg, "length was:", strlen(returned) )
      iniPP(msg)
      return returned
   }
}

StatusProCopyField(xCoord, yCoord)
{
   Click(xCoord, yCoord, "left")
   Click(xCoord, yCoord, "right")
   Send, {DOWN 3}{ENTER}
}

ShortenForDebug(text)
{
   len:=strlen(text)
   start:=StringLeft(text, 10)
   if (len > 25)
   {
      text=(((Text was %len% characters long and started with %start%)))
      ;text.= full text stored at ... C:\fgakjldsfjlki
      ;TODO store the full text in a separate file and note the location of that file
   }
   return text
}

GetReferenceNumber()
{
   Clipboard:=""
   ss()
   Click(1100, 165, "left double")
   ss()
   Send, {CTRLDOWN}c{CTRLUP}
   ;ss()
   ;ss()
   ;sleep, 1000
   ClipWaitNot("")

   referenceNumber:=Clipboard
   if NOT RegExMatch(referenceNumber, "[0-9]{5}")
      RecoverFromMacrosGoneWild("I didn't get the reference number (scroll up, maybe?) (error 14)", referenceNumber)

   return referenceNumber
}

;}}}
