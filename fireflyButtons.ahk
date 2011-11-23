#include FcnLib.ahk
#include SendEmailSimpleLib.ahk
#NoTrayIcon

;{{{ TODOs
;TODO make scorecard faster
;FIXME Auto-expand all pluses in the left-hand side
;WRITEME firefly: make paste paste without formatting in the MS-Word lookalike program
;TODO change text in the MS-Word lookalike program (cause their template is wrong)
;TODO make in-depth fees gui
;TODO make background blueish to match sidebar
;TODO default PS Fee to $10

;TODO make a macro that tests their site and determines if the site is going slower than normal and logs out/in again
;TODO make macros more robust so that I can upgrade firefox

;FIXME FIXME FIXME
;Can you see at the top, in the middle, above the Process Server Name, there is some info in blue? I think that sometimes there is alot of information there so the rest of the page is skewed and the macro ends up copypasting randomness all around.
;I don't know if this is really part of the issue but thought I would throw it out. I was trying to add a scorecard entry on this one when the macros went wild.
;end FIXME - from an email Mel sent on 11-22-2011 around 3:30pm

;TODO issues that melinda brought up:
;Reload Queue is not reliable when I am in a file
;Does not answer Y to first question on the scorecard (in Open Office)
;Sometimes the server's name in the file does not match the name in the scorecard, can you make it so that the macro still works and just leaves the name blank on the scorecard (right now it enters all the information one field off)?
;The "Would you like to approve?" box never shows up anymore. Don't know if you would want to remove that code?
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
Gui, Add, Button, , Reload Queue
Gui, Add, Button, , Change Queue
Gui, Add, Button, , Add Scorecard Entry
;Gui, Add, Button, , Ready To Invoice
Gui, Add, Button, , Add Fees
;Gui, Add, Button, , Refresh Login

Gui, Add, Button, x10  y190, Record for Cameron
Gui, Add, Button, x10  y220, Test Something
Gui, Add, Button, x110 y6  , x

Gui, Show, , Firefly Shortcuts
WinMove, Firefly Shortcuts, , %xLocation%, %yLocation%
;}}}

;{{{Persistent items (things that are checked repetitively)
Loop
{
   ;expand all pluses
   ;ClickIfImageSearch("images/firefly/expandJob.bmp")

   ;Stuff for annoying firefly boxes that are always cancelled out of
   IfWinActive, %statusProMessage%
   {
      ;REMOVEME if Mel doesn't complain (2011-11-10)
      ;if SimpleImageSearch("images/firefly/dialog/wouldYouLikeToApproveThisJob.bmp")
         ;Click(200, 90, "control") ;no button
      if SimpleImageSearch("images/firefly/dialog/pleaseSelectAnOptionFromTheDropDown.bmp")
         Click(170, 90, "control") ;ok button
      if SimpleImageSearch("images/firefly/dialog/selectedFeesEntryHasBeenDeletedSuccessfully.bmp")
         Click(170, 90, "control") ;ok button
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
;Process, Close, firefox.exe

;if CantFocusNecessaryWindow(firefox)
   ;return
ForceWinFocus("Mozilla Firefox")

Loop
{
   IfWinActive, FireFly Dashboard - Main - Mozilla Firefox ahk_class MozillaUIWindowClass
      break
   if NOT InStr(WinGetActiveTitle(), "Mozilla Firefox")
   {
      errord("", "for some reason all of the firefox windows closed (error 10)")
      return
   }
   Send, ^w
   Sleep, 100
}
;RunProgram("C:\Program Files\Mozilla Firefox\firefox.exe")
Sleep, 500
Click(1730, 1110, "left mouse")
Sleep, 500
Click(50, 375)
WinWaitActive, Mozilla Firefox
Sleep, 200
Send, !d
Sleep, 200
Send, https://www.status-pro.biz/dashboard/Default.aspx
Send, {ENTER}
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
feesvar1=10
feesvar2=20
feesvar3=30
feesvar4=3
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

;{{{ButtonReadyToInvoice:
ButtonReadyToInvoice:

if DoesntWantToRunMacro()
   return

StartOfMacro()

BlockInput, MouseMove

if CantFocusNecessaryWindow(firefox)
   return
if CantFindTopOfFirefoxPage()
   return

Clipboard:=""
ss()
Click(248, 223)
ss()
Send, {CTRLDOWN}a{CTRLUP}
Send, {CTRLDOWN}c{CTRLUP}
ss()
clientFileNumber:=Clipboard
length := strlen(clientFileNumber)
if ( length > 10 || NOT clientFileNumber )
{
   msgbox, ERROR: I didn't get the client file number (scroll up, maybe?) (error 3)
   return
}

;insert note in the file
ss()
;ForceWinFocus("Status Pro Initial Catalog=StatusPro; - Portal - Mozilla Firefox")
Click(391, 166, "left")
ss()
Send, {PGDN 20}
ss()
Click(1120, 975, "left")
ss()
WaitForImageSearch("images/firefly/NoteWizardWindow.bmp")
;Sleep, 1000
sendEmailFromMelinda(clientFileNumber, "Ready To Invoice?")
;debug(clientFileNumber)

ss()
Click(789, 320, "left")
ss()
Send, InterOfficeNote
;SendSlow("InterOfficeNote", slowSendPauseTime)
ss()
Click(828, 338, "left")
ss()
;click into the box so we can type the message body
ClickMultipleTimesWithPause(982, 409, "left control", 3)
ss()
SendInput, Emailed Office: Ready to Invoice?
ss()
;Sleep, 3000

;possible issues with note being typed in wrong
;TODO perhaps we should copy the fields or OCR them to ensure it looks good
;however, if I do OCR I will need to be careful, because it is possible that that text is elsewhere on the same page
if NOT SimpleImageSearch("images/firefly/InterOfficeNote.bmp")
{
   RecoverFromMacrosGoneWild()
   iniPP("ReadyToInvoice-Error-NoteTypedIncorrectly111")
   msgbox, it looks like the note type wasn't typed in right (error 1)
   return
}
;this seems to cause some issues... odd situation... always thinks the note is typed incorrectly
else if NOT SimpleImageSearch("images/firefly/ReadyToInvoiceNote.bmp")
{
   ;RecoverFromMacrosGoneWild()
   iniPP("ReadyToInvoice-Error-NoteTypedIncorrectly222")
   ;msgbox, it looks like the note text wasn't typed in right (error 2)
   ;return
}


;Click(700, 634, "left") ;Save Note
;Click(1095, 285, "left") ;click the X

EndOfMacro()
return
;}}}

;{{{ButtonAddScorecardEntry:
ButtonAddScorecardEntry:
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
Click(620, 237, "left double")
ss()
referenceNumber:=Clipboard
if NOT RegExMatch(referenceNumber, "[0-9]{4}")
{
   msgbox, ERROR: I didn't get the reference number (scroll up, maybe?) (error 4)
   return
}
Send, {CTRLDOWN}a{CTRLUP}{CTRLDOWN}c{CTRLUP}
Click(620, 237, "left")
ss()
Click(612, 254, "left")
ss()
Click(1254, 167, "left")
ss()
Click(922, 374, "left double")
ss()
serverName:=Clipboard
if ( StrLen(serverName) > 25 )
   RecoverFromMacrosGoneWild("ERROR: I got too much text for the server name (error 10)")
if NOT RegExMatch(serverName, "[a-zA-Z .,]+")
   RecoverFromMacrosGoneWild("ERROR: The server name has weird characters in it (error 11)`n" . serverName)
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
{
   msgbox, ERROR: It looks like this one was cancelled: %status% (error 5)
   return
}

IfWinExist, The page at https://www.status-pro.biz says: ahk_class MozillaDialogClass
{
   msgbox, ERROR: The website gave us an odd error (error 6)
   return
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if CantFocusNecessaryWindow(excel)
   return

;translate server name
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
Send, %serverName%{ENTER}
;ss()
Send, ICMbaustian{ENTER}
;ss()
Send, %today%{ENTER}
;ss()
Send, %referenceNumber%{ENTER}
;ss()
Sleep, 100
Send, ^c
Sleep, 100
;ss()
loop
{
   ServiceCounty := Clipboard
   ;debug(ServiceCounty)
   if (ServiceCounty != "null")
      break
   sleep, 100
}
Send, {ENTER}
;ss()
Send, {DOWN}
;ss()
Send, {ENTER}
;ss()
Send, {ENTER}
;ss()
Send, {ENTER}{ENTER}{ENTER}{ENTER}
;ss()
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
;ss()
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
;ss()
Send, {ENTER}
;ss()
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
;ss()
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
;ss()
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
;ss()
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
;ss()
Send, {ENTER}
;ss()
Send, {SHIFTDOWN}y{SHIFTUP}{DEL}{ENTER}
;ss()
Send, {ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}{ENTER}
;ss()
Send, {SHIFTDOWN}n{SHIFTUP}{DEL}{ENTER}
;ss()
if NOT InStr(ServiceCounty, "Service County Not Required")
   msgbox, , , ERROR: It looks like you need a Service County - it says: %ServiceCounty% %Clipboard%, 0.5
;ss()

EndOfMacro()
return
;}}}

;{{{ButtonChangeQueue:
ButtonChangeQueue:

;Gui, 2: +LastFound
;HWND := WinExist()
;msgbox % hwnd

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
2ButtonX:
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
debug("finished testing something")
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
   WinMove, %firefox%, , 0, 0, 1766, 1020
   WinMove, %excel%  , , 0, 0, 1766, 1020
   If InStr(WinGetActiveTitle(), excel) OR InStr(WinGetActiveTitle(), firefox)
      Send, ^!{NUMPAD5}
}

CantFocusNecessaryWindow(window)
{
   if (window == "")
   {
      errord("", "Cameron did something wrong, the window variable was blank")
      RecoverFromMacrosGoneWild()
      return true
   }

   if NOT ForceWinFocusIfExist(window)
   {
      errord("", "couldn't find this window", window)
      RecoverFromMacrosGoneWild()
      return true
   }
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
   {
      errord("", "can't find the top of the page in firefox")
      RecoverFromMacrosGoneWild()
      return true
   }

   ;do a couple more clicks, just to make sure we're at the very, very top
   Loop 10
      Click(1760, 124, "control")
      ;Click(1753, 104, "control")
}


DoesntWantToRunMacro(macroName="")
{
   if NOT macroName
      macroName:=GetButtonName()
   message=You clicked the %macroName% button, do you really want to continue?

   MsgBox, 4, , %message%
   IfMsgBox, No
   {
      RecoverFromMacrosGoneWild("aborting macro (user decided they didn't want to run it)", "nolog")
      return true
   }
}

;TODO maybe this should be moved into the fcn lib?
GetButtonName()
{
   returned:=RegExReplace(A_ThisLabel, "([A-Z])", " $1")
   returned:=StringReplace(returned, "Button")
   returned:=RegExReplace(returned, "^ +")
   return returned
}

RecoverFromMacrosGoneWild(message="", options="")
{
   iniPP(A_ThisFunc)
   EndOfMacro()

   ;take a screenshot, if desired
   if InStr(options, "screenshot")
      SaveScreenShot(A_ScriptName . "-" . message)

   ;do I want errord? or do I want a msgbox? ;prolly not msgbox cause we might want to log it
   if message
   {
      iniPP(message)
      errord(options, message, A_ScriptName, A_ThisFunc, A_LineNumber)
   }

   Reload
}

StartOfMacro()
{
   ;ini:=ini()
   ;time:=CurrentTime("hyphenated")
   ;IniWrite(ini, "tracelogs", time, A_ThisLabel)

   iniPP("PressedAButton") ;yeah, we're basically denoting this twice in a row (PressedAButton will always equal StartOfMacro), but this will make the stats file more readable
   iniPP(A_ThisFunc)
   iniPP(A_ThisLabel) ;make a note that we pressed the button to start this macro
   SetCapsLockState, Off
   ArrangeWindows()
}

EndOfMacro()
{
   iniPP(A_ThisFunc)
   BlockInput, MouseMoveOff
   ;should I log some stuff to an INI?
}

ini()
{
   return GetPath("FireflyStats.ini")
}

iniPP(itemTracked)
{
   ;I'm thinking that the section should either be the computer name or the date
   ini:=ini()
   section:=A_ComputerName
   key:=itemTracked

   value := IniRead(ini, section, key)
   value++
   IniWrite(ini, section, key, value)
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
;}}}
