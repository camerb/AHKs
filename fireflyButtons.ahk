#include FcnLib.ahk
#include SendEmailSimpleLib.ahk
#NoTrayIcon

;{{{ TODOs
;TODO make scorecard faster
; Delete filler text from Magic Faux MS_Word
; Auto-expand all pluses in the left-hand side
;WRITEME firefly: make paste paste without formatting in the MS-Word lookalike program
;TODO change text in the MS-Word lookalike program (cause their template is wrong)
;TODO make basic fees gui
;TODO make in-depth fees gui

;TODO make ready to invoice button yellow
;TODO make background blueish to match sidebar
;TODO make x button red (pale)

;TODO deactivate capslock at the beginning of each macro
;TODO make a macro that tests their site and determines if the site is going slower than normal
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

Gui, +LastFound -Caption +ToolWindow +AlwaysOnTop
Gui, Add, Button, , Reload Queue
Gui, Add, Button, , Change Queue
Gui, Add, Button, , Add Scorecard Entry
Gui, Color, 0xdd0000, ;0x00dd00
Gui, Add, Button, -Background0x0000dd, Ready To Invoice
Gui, Add, Button, x10  y160, Record for Cameron
Gui, Add, Button, x10  y190, Test Something
Gui, Add, Button, x110 y6  , x

Gui, Show, , Firefly Shortcuts
WinMove, Firefly Shortcuts, , 1770, 550
;}}}

;{{{Persistent items (things that are checked repetitively)
Loop
{
   ;expand all pluses
   ;ClickIfImageSearch("images/firefly/expandJob.bmp")

   ;Stuff for annoying firefly boxes that are always cancelled out of
   IfWinActive, %statusProMessage%
   {
      if SimpleImageSearch("images/firefly/dialog/wouldYouLikeToApproveThisJob.bmp")
         Click(200, 90, "control") ;no button
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


;{{{ButtonReadyToInvoice:
ButtonReadyToInvoice:
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
   msgbox, ERROR: I didn't get the client file number (scroll up, maybe?)
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
Click(982, 409, "left")
ss()
SendInput, Emailed Office: Ready to Invoice?
ss()
;Sleep, 3000

;possible issues with note being typed in wrong
;TODO perhaps we should copy the fields or OCR them to ensure it looks good
;however, if I do OCR I will need to be careful, because it is possible that that text is elsewhere on the same page
;if NOT SimpleImageSearch("images/firefly/ghettoReadyToInvoiceNoteIsCorrect.bmp")
;{
   ;RecoverFromMacrosGoneWild()
   ;msgbox, it looks like the note wasn't typed in right
   ;return
;}
if NOT SimpleImageSearch("images/firefly/InterOfficeNote.bmp")
{
   RecoverFromMacrosGoneWild()
   msgbox, it looks like the note type wasn't typed in right
   return
}
;if NOT SimpleImageSearch("images/firefly/ReadyToInvoiceNote.bmp")
;{
   ;RecoverFromMacrosGoneWild()
   ;msgbox, it looks like the note text wasn't typed in right
   ;return
;}


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
;Click(1100, 165, "left")
ss()
Send, {CTRLDOWN}c{CTRLUP}
ss()
Click(620, 237, "left double")
;Click(620, 237, "left")
ss()
referenceNumber:=Clipboard
if NOT RegExMatch(referenceNumber, "[0-9]{4}")
{
   msgbox, ERROR: I didn't get the reference number (scroll up, maybe?)
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
;Click(922, 374, "left")
ss()
server:=Clipboard
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
   msgbox, ERROR: It looks like this one was cancelled: %status%
   return
}

IfWinExist, The page at https://www.status-pro.biz says: ahk_class MozillaDialogClass
{
   msgbox, ERROR: The website gave us an odd error
   return
}


;;;;;;;;;;;;;;;;
if CantFocusNecessaryWindow(excel)
   return

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
Send, %server%{ENTER}
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
   msgbox, ERROR: It looks like you need a Service County - it says: %ServiceCounty% %Clipboard%
;ss()

EndOfMacro()
return
;}}}

;{{{ButtonChangeQueue:
ButtonChangeQueue:

;Gui, 2: +LastFound
;HWND := WinExist()
;msgbox % hwnd

Gui, 2: Add, ComboBox, vCityNew, %cityChoices%
Gui, 2: Add, ComboBox, vClientNew, %clientChoices%
Gui, 2: Add, Button, Default, Change To This Queue
Gui, 2: Show
return
2ButtonChangeToThisQueue:
Gui, 2: Submit
city:=cityNew
client:=clientNew
IniWrite(ini, "firefly", "city", city)
IniWrite(ini, "firefly", "client", client)
Gui, 2: Destroy
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

;{{{ ButtonX:
ButtonX:
ExitApp
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
CantFindTopOfFirefoxPage()
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
      Click(1753, 104, "control")
}

RecoverFromMacrosGoneWild()
{
   EndOfMacro()
   ;do I want errord? or do I want a msgbox? ;prolly not msgbox cause we might want to log it
   ;do I want to take a screenshot?
}

StartOfMacro()
{
   SetCapsLockState, Off
   ArrangeWindows()
}

EndOfMacro()
{
   BlockInput, MouseMoveOff
   ;should I log some stuff to an INI?
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
;}}}
