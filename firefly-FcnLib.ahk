#include FcnLib.ahk
#include FcnLib-Clipboard.ahk
#include FcnLib-Nightly.ahk
#include FcnLib-IniStats.ahk
#include SendEmailSimpleLib.ahk
#include thirdParty\json.ahk
#include thirdParty\notify.ahk
#include thirdParty\OCR.ahk


;{{{ ghettoness
ss()
{
   Sleep, 100
}
;}}}

;{{{ Window Manipulation
ArrangeWindows()
{
   global
   if IsVM()
   {
      w=1281
      h=925
      ;FIXME these are the old values, switching to the new values above seems to break other things
      w=1280
      h=932
      WinRestore, Mozilla Firefox
      WinRestore, %firefox%
      ;WinRestore, %excel%
      WinMove, Mozilla Firefox, , 0, 0, %w%, %h%
      WinMove, %firefox%, , 0, 0, %w%, %h%
      ;WinMove, %excel%  , , 0, 0, %w%, %h%
      ;If InStr(WinGetActiveTitle(), excel) OR InStr(WinGetActiveTitle(), firefox)
         ;Send, ^!{NUMPAD5}
   }
   else
   {
      w=1766
      h=1020
      WinRestore, Mozilla Firefox
      WinRestore, %firefox%
      WinRestore, %excel%
      WinMove, Mozilla Firefox, , 0, 0, %w%, %h%
      WinMove, %firefox%, , 0, 0, %w%, %h%
      WinMove, %excel%  , , 0, 0, %w%, %h%
      If InStr(WinGetActiveTitle(), excel) OR InStr(WinGetActiveTitle(), firefox)
         Send, ^!{NUMPAD5}
   }
}

FocusNecessaryWindow(window)
{
   qd("started focus")
   if (window == "")
      RecoverFromMacrosGoneWild("Cameron did something wrong, the window variable was blank (error 42)")

   if NOT ForceWinFocusIfExist(window)
      RecoverFromMacrosGoneWild("couldn't find this window (error 41): " . window)
   qd("ended focus")
}

;seems to work really well for both manned and bot
FindTopOfFirefoxPage()
{
   global firefox

   qd("started find top")
   timerFcn := StartTimer()

   FocusNecessaryWindow(firefox)

   ScrollUpLarge()
   Sleep, 100

   ;used to be 3000
   if IsBot()
      Sleep, 200

   qd("before top")
   ;if we see these images, then we are already at the very top of the page and don't need to scroll up
   if SimpleImageSearch( FixImagePathIfBot("images/firefly/topOfPage.bmp") )
      return
   qd("after top")

   topOfPageIsVisible := SimpleImageSearch("images/firefly/HomeTab.bmp")
      OR SimpleImageSearch("images/firefly/AffidavitsTab.bmp")
      OR SimpleImageSearch("images/firefly/AffidavitsTab7.bmp")
      OR SimpleImageSearch("images/firefly/HomeTab7.bmp")
      OR SimpleImageSearch("images/firefly/topOfPage2.bmp")
      OR SimpleImageSearch("images/firefly/topOfPage-wrong.bmp")

   if NOT topOfPageIsVisible
      RecoverFromMacrosGoneWild("Can't find the top of the page in firefox")

   ;do a couple more clicks, just to make sure we're at the very, very top
   Loop 10
      ScrollUpSmall()

   FireflyBotEndTimer(timerFcn, A_ThisFunc, 1, 5)

   qd("end find top")
}
;}}}

;{{{ Prompts
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
;}}}

;{{{ Logging / Debugging
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

   if IsBot()
   {
      options .= " silent"

      tracemsg=%A_ThisFunc% - faint orange line
      AddToTrace(tracemsg)
   }

   ;do I want errord? or do I want a msgbox? ;prolly not msgbox cause we might want to log it
   if message
   {
      iniPP(message)
      errord(options, message, A_ScriptName, A_ThisFunc, A_LineNumber)
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
   iniMostRecentTime("Firefly Panel Loaded (most recent time)") ;track the last time it was reloaded
   iniPP("Firefly Panel Loaded (number of times)") ;count all the times it was reloaded
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

ShortenForDebug(text)
{
   len:=strlen(text)
   start:=StringLeft(text, 10)
   if (len > 25)
   {
      text=(((Text was %len% characters long and started with %start%)))
      ;text.= full text stored at ... C:\fgakjldsfjlki
      ;TODO store the full text in a separate file and note the location of that file
      ;and perhaps that should be moved to the fcnlib
   }
   return text
}

;}}}

;{{{ Getting info from Status-Pro
GetEasyFileInfo()
{
   ;this one is not for bots
   if IsBot()
      return

   addtotrace(A_ThisFunc . " triggered")

   Click(1100, 165, "left double")
   ;I noticed that this is in the middle of the page, so it should work fine

   ss()
   Send, {CTRLDOWN}a{CTRLUP}
   ss()
   allTheText := CopyWait()

   timestamp := CurrentTime("hyphenated")
   filepath=C:\Dropbox\fastData\quickFileOutput\%timestamp%-%A_ComputerName%.txt
   FileAppend(allTheText, filepath)
}

GetFileNumber()
{
   if NOT IsBot()
      errord("I didn't make it so that Mel's macros could get the file number")

   Clipboard:="null"
   ;StatusProCopyField(323, 247)
   Click(323, 247, "double")
   Send, ^a
   Click(323, 247, "right")
   Send, {DOWN 3}
   Send, {ENTER}
   ClipWaitNot("null")
   fileNumber:=Clipboard

   ;if NOT RegExMatch(serverName, "[A-Za-z]{3}")
      ;RecoverFromMacrosGoneWild("I didn't get a server name (might have a long defendant name) (error 23)", serverName)
   if (fileNumber == "null")
   {
      AddToTrace("GetFileNumber failed (error 33) - faint orange line")
      RecoverFromMacrosGoneWild("I didnt get the file number (error 33)")
   }

   return fileNumber
}

GetReferenceNumber()
{
   ;Clipboard:=""
   ;ss()

   if IsBot()
      Click(1220, 182, "left double")
   else
      Click(1212, 173, "left double")
      ;Click(1100, 165, "left double") ;old compy

   if IsBot()
      Sleep, 200

   ;ss()
   ;Send, {CTRLDOWN}c{CTRLUP}
   ;ss()
   ;ClipWaitNot("")
   ;referenceNumber:=Clipboard

   referenceNumber:=CopyWait2()

   if NOT RegExMatch(referenceNumber, "[0-9]{5}")
      RecoverFromMacrosGoneWild("I didn't get the reference number (scroll up, maybe?) (error 14)", referenceNumber)

   return referenceNumber
}

GetServerName()
{
   Clipboard:=""
   ;StatusProCopyField(720, 237)
   StatusProCopyField(820, 250)
   ClipWaitNot("")
   serverName:=Clipboard

   if NOT RegExMatch(serverName, "[A-Za-z]{3}")
      RecoverFromMacrosGoneWild("I didn't get a server name (might have a long defendant name) (error 23)", serverName)

   ;TODO check if the name is in the server name list

   return serverName
}

;This is also known as the status
GetServiceManner()
{
   Clipboard:=""
   ;StatusProCopyField(958, 374) ;experimenting trying to get it a little more reliable
   StatusProCopyField(1060, 394)
   ClipWaitNot("")
   status:=Clipboard
   if NOT RegExMatch(status, "(Closed|Served|Cancelled|Personal|Substitute|Not Served|Found|Posted)")
   {
      if status
         iniPP("(yellow line) I have never seen this status before: " . status)
      RecoverFromMacrosGoneWild("Invalid status (might have a long defendant name) (error 24) " . status)
   }
   return status
}

;TODO put this sucker into the ASE macro
;TODO use OCR here
GetThatStupidDate()
{
   xDate := 494
   yDate := 508
   wDate := 112
   hDate := 20

   ;xDate := 700
   ;yDate := 400
   ;wDate := 300
   ;hDate := 200

   xSpacer := 50

   FindTopOfFirefoxPage()
   monthSeen := GetOCR(xDate, yDate, wDate, hDate, "activeWindow")

   ;months=January,February,March,April,May,June,July,August,September,October,November,December
   months=Jan__a y,Febru,Mar,April,My,June,Ju_,Augu,Se__emI_er,October,tIove mI_er,ecember
   Loop, parse, months, CSV
   {
      if InStr(monthSeen, A_LoopField)
         monthNumber := A_Index
   }
   ;returned .= GetOCR(xDate + xSpacer, yDate, wDate, hDate, "activeWindow numeric")
   ;returned .= GetOCR(xDate + xSpacer, yDate, wDate - xSpacer, hDate, "activeWindow numeric")

   Clipboard := monthSeen
   RegExMatch(monthSeen, "(\d+) *(2011|2012|2013|2014|2015|2016|2017|2018|2019) *$", match)
   ;daySeen := match2
   ;daySeen := match2
   debug(monthSeen, monthNumber, match1, match2)
   ;debug(monthSeen, monthNumber, returned)

   ;Loop, 12
   ;{
      ;file=images/firefly/date/monthWords%A_Index%.bmp
      ;if SimpleImageSearchWithDimensions(file, xDate, yDate, wDate, hDate)
      ;{
         ;sawMonth := A_Index
         ;break
      ;}
   ;}

   ;Loop, 31
   ;{
      ;file=images/firefly/date/%A_Index%.bmp
      ;if SimpleImageSearchWithDimensions(file, xDate, yDate, wDate, hDate)
      ;{
         ;sawDay := A_Index
         ;break
      ;}
   ;}

   ;Loop, 3
   ;{
      ;thisYear := 2010 + A_Index
      ;file=images/firefly/date/%thisYear%.bmp
      ;if SimpleImageSearchWithDimensions(file, xDate, yDate, wDate, hDate)
      ;{
         ;sawYear := thisYear
         ;break
      ;}
   ;}

   ;returned=%sawMonth%/%sawDay%/%sawYear%
   return returned
}
;}}}

;{{{ Generic things
ClickMultipleTimesWithPause(x, y, options, times)
{
   Loop %times%
   {
      Click(x, y, options)
      ss()
   }
}

SelectAll()
{
   Send, {CTRLDOWN}{END}{SHIFTDOWN}{HOME}{SHIFTUP}{CTRLUP}
}

;}}}

;{{{ Frequent low-level tasks in firefly
KillFirefox()
{
   ;kill firefox
   CustomTitleMatchMode("Contains")
   while ProcessExist("firefox.exe")
   {
      WinClose, Mozilla Firefox
      Sleep, 100
   }
}

ScrollUpSmall()
{
   if IsBot()
      Click(1267, 114, "left control")
   else
      Click(1753, 104, "")
}

ScrollUpLarge()
{
   if IsBot()
      Click(1267, 124, "left control")
   else
      Click(1753, 116, "")
}

ScrollDownSmall()
{
   if IsBot()
      Click(1267, 903, "left control")
   ;else
      ;Click(1753, 984, "control") ;TESTME educated guess... not sure if this is right
}

ScrollDownLarge()
{
   if IsBot()
      Click(1267, 894, "left control")
   else
      Click(1753, 974, "control")
}

CloseStatusProTabs()
{
   Loop 10
      ClickIfImageSearch("images/firefly/closeTab2.bmp", "control")
   Loop 10
      ClickIfImageSearch("images/firefly/closeTab.bmp", "control")
}

StatusProCopyField(xCoord, yCoord)
{
   Click(xCoord, yCoord, "left")
   Click(xCoord, yCoord, "right")
   Send, {DOWN 3}{ENTER}
}

;Send an email without doing any of the complex queuing stuff
;FIXME DEPRECATED - now send all emails through the outlook account
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

;{{{ Frequent high-level tasks in firefly
OpenReferenceNumber(referenceNumber)
{
   iniPP("Loading ref num")
   URLbar := GetURLbar("firefox")
   if NOT InStr( URLbar, "status-pro.biz/fc/Portal.aspx" )
      return

   FindTopOfFirefoxPage()

   CloseStatusProTabs()

   ss()

   if IsBot()
   {
      MouseMove, 33, 123
      Sleep, 500
   }
   else
      MouseMove, 33, 115

   ss()
   if IsBot()
      Click(33, 206, "left")
   else
      Click(33, 184, "left control")

   WaitForImageSearch(FixImagePathIfBot("images/firefly/fileSearchScreen.bmp"))

   if IsBot()
      Sleep, 500
   ;TODO may need to tweak this sleep a little (was between 0 - 500)

   if IsBot()
      Click(209, 400, "left")
   else
      ;Click(209, 372, "left control")
      Click(230, 390, "left control")
   SendViaClip(referenceNumber)

   ss()
   if IsBot()
      Sleep, 2500
   ;TODO may need to tweak this sleep a little (was between 400 - 1500 - 2500)

   if IsBot()
      Click(42, 212, "left double")
   else
      Click(42, 199, "left double")

   ;wait for all the elements of the page to load
   WaitForImageSearch(FixImagePathIfBot("images/firefly/servicePicturesButton.bmp"))
   WaitForImageSearch(FixImagePathIfBot("images/firefly/propertyInformationButton.bmp"))

   desiredReferenceNumber:=referenceNumber
   currentReferenceNumber:=GetReferenceNumber()

   if (currentReferenceNumber != desiredReferenceNumber)
   {
      RecoverFromMacrosGoneWild("Loaded the wrong file number")
      AddToTrace("Loaded the wrong file number " . currentReferenceNumber . " " . desiredReferenceNumber)
   }

   ;FIXME I don't have an image yet for if the file is in use on Baustian-09pc
   ;if ClickIfImageSearch(FixImagePathIfBot("images/firefly/fileInUse.bmp"))
   if ClickIfImageSearch("images/firefly/fileInUseVM.bmp")
   {
      ExitFireflyFile()
      iniPP("File Was In Use")
      OpenReferenceNumber(referenceNumber) ;recursion seems ok here, but I fear it is super-dangerous
   }
   iniPP("Successfully reloaded ref number")
}

ExitFireflyFile()
{
   Loop, 5
      ScrollUpLarge()

   Loop, 10
   {
      ScrollDownLarge()
      if ClickIfImageSearch(FixImagePathIfBot("images/firefly/exitFile.bmp"))
         return
   }

   Loop, 10
   {
      ScrollUpLarge()
      if ClickIfImageSearch(FixImagePathIfBot("images/firefly/exitFile.bmp"))
         return
   }
}
;}}}

;{{{ Not sure if these functions will be multi-use
CheckBotHealth()
{
   if NOT IsVM()
      return

   FreeSpace:=DriveSpaceFree("C:\")
   FreeSpace := FreeSpace / 1024
   message=%FreeSpace% GB free on %A_ComputerName%

   if (FreeSpace < 1.5)
      AddToTrace(message)

   ;TODO maybe this should be in the stats folder instead
   iniFolder:=GetPath("FireflyCheckinIniFolder")
   iniFolderWrite(iniFolder, "BotHealth", A_ComputerName . "FreeDiskSpace", FreeSpace)
   iniFolderWrite(iniFolder, "BotHealth", A_ComputerName . "LastChecked", CurrentTime("hyphenated"))
}

feesMatchForThisReferenceNumber(referenceNumber, fees1, fees2)
{
   listFees := ListFees()
   Loop, parse, listFees, CSV
   {
      thisFee:=A_LoopField
      feesValue1 := IniRead(fees1, referenceNumber, thisFee)
      feesValue2 := IniRead(fees2, referenceNumber, thisFee)
      if (feesValue1 != feesValue2)
         return false
   }
   return true
}

IsBot()
{
   global bot
   return %bot%
}

ReferenceNumberForTesting()
{
   return 2522980
   return 2461358
}

FixImagePathIfBot(path)
{
   if IsBot()
      path := RegExReplace(path, "\.", "VM.")
   return path
}

PrepIniKeyServerName(text)
{
   returned:=RegExReplace(text, "(\,|\.)")
   return returned
}
;}}}

;{{{ Stupid copywait attempts
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
;}}}

;{{{ Assign globals and set modes
AssignGlobals()
{
global
SetTitleMatchMode, RegEx

;get the contents for the DDL in ChangeQueue
cityChoices=Tampa|Ft. Lauderdale|Orlando|Jacksonville
clientChoices := IniRead( GetPath("MelFireflyConfig.ini"), "Lists", "ClientChoices")

;get the currently selected info for ReloadQueue
ini := GetPath("myconfig.ini")
city := IniRead(ini, "firefly", "city")
client := IniRead(ini, "firefly", "client")

;window titles
statusProMessage=The page at https://www.status-pro.biz says: ahk_class MozillaDialogClass
firefox=Status Pro Initial Catalog.*Firefox
excel=(In House Process Server Scorecard|Process Server Fee Determination).*(OpenOffice.org|LibreOffice) Calc

;this is for the retarded comboboxes...
slowSendPauseTime=130
;breaks at 100,110 reliable at 120,150

;Counters that should start at zero
feesAddedCountSoFar := 0

}
;}}}

;{{{ warnings
DoubleFeesWarning(referenceNumber)
{
   subject := "detected double fees " . CurrentTime("hyphendate")
   message := referenceNumber
   SendEmail(subject, message, "", "cameronbaustian@gmail.com")
   SendEmail(subject, message, "", "melindabaustian@gmail.com")
}

DoubleSMS(message)
{
   SendEmail("", message, "", "9723429753@txt.att.net")
   SendEmail("", message, "", "9724153698@txt.att.net")
}

DevModeDoubleSMS(message)
{
   SendEmail("", "DEV MODE " . message, "", "9723429753@txt.att.net")
   ;SendEmail("", message, "", "9724153698@txt.att.net")
}
;}}}

;{{{ These things are kinda like globals
GetSimpleFeesJson()
{
   ;only load it from the file if necessary
   global fireflySimpleFeesJson
   if NOT fireflySimpleFeesJson
      fireflySimpleFeesJson := FileRead(GetPath("FireflyFees.json"))
   return fireflySimpleFeesJson
}

ListFees()
{
   feesJson := GetSimpleFeesJson()
   returned := json(feesJson, "listFees")
   return returned
}
;}}}

;{{{ Bot Communication (things related to the fees, but can be used on both PCs)
GetNumberOfFeesNotYetAdded()
{
   timerFcn := StartTimer()

   iniFolder:=GetPath("FireflyIniFolder")
   uiSections := IniFolderListAllSections(iniFolder)
   feesJson := GetSimpleFeesJson()
   listFees := ListFees()
   feeNotYetAdded := 0

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

         status := FeeLookup2(thisReferenceNumber, thisFee)

         ;if (status == "NO SUCH FEE WAS SUBMITTED")
         ;{
            ;noSuchFee++
         ;}
         ;if (status == "FEE WAS THERE")
         ;{
            ;feeAdded++
         ;}
         if (status == "NOT_YET_ADDED")
         {
            feeNotYetAdded++
            lotsotext .= thisReferenceNumber . "," . thisFee . "`n"
         }

         totalFeesAdded++
         ;lotsotext .= thisReferenceNumber . ","
      }
   }

   FireflyBotEndTimer(timerFcn, A_ThisFunc, 0, 40)

   return feeNotYetAdded
}

;TODO statuses:
;ABORT           ABORT
;NOT_SUBMITTED   NO_SUCH
;ALREADY_ADDED
;BOT_ADDED       ADDED
;NOT_YET_ADDED   PENDING
FeeLookup2(referenceNumber, fee)
{
   iniFolder:=GetPath("FireflyIniFolder")
   thisKeyDesired=DesiredFees-%fee%
   thisKeyOnFile=FeesOnFile-%fee%

   ;checking if already added
   desiredValue := IniFolderRead(iniFolder, referenceNumber, thisKeyDesired)
   actualValue := IniFolderRead(iniFolder, referenceNumber, thisKeyOnFile)
   abortValue := IniFolderRead(iniFolder, referenceNumber, "ABORT")

   ;check if we put an emergency abort on it
   if InStr(abortValue, "TRUE")
      return "ABORTED"

   ;if there are additional fees, that's ok
   ;only fuss about fees that Melinda told the bot she wanted to add
   if (desiredValue == "ERROR")
      return "NO_SUCH_FEE"

   ;the fee is already there
   ;TODO make it so that we can tell if the fee was already there, or was added by the bot ( BOT_ADDED )
   if (desiredValue == actualValue)
      return "ALREADY_ADDED"
   else
      return "NOT_YET_ADDED"
}
;}}}

;{{{ Debug output, stopwatch timers
qd(text)
{
   return

   Sleep, 1000
   addToTrace(text)
   Sleep, 1000
}

FireflyBotEndTimer(timer, funcName, lowerBound, upperBound)
{
   lowerBound *= 1000
   upperBound *= 1000

   if ( IsBot() AND IsVM() )
   {
      elapsed := ElapsedTime(timer)
      if (elapsed < lowerBound)
      {
         status=- faint green line
         ppmsg=Timer-%funcName% was faster than expected %status%
         IniPP(ppmsg)
      }
      if (upperBound < elapsed)
      {
         status=- faint yellow line
         ppmsg=Timer-%funcName% was slower than expected %status%
         IniPP(ppmsg)
      }
      tracemsg=Took %elapsed%ms for %funcName% %status%

      if status
         AddToTrace(tracemsg)

      ;Write to verbose logs
      timestamp := CurrentTime("hyphenated")
      verbosemsg=%timestamp%: %tracemsg%
      FileAppendLine(verbosemsg, "C:\Dropbox\Public\logs\fireflyTimers.txt")
   }
}
;}}}

;{{{ former Firefly Check-Ins (monitoring the bot)
FireflyCheckin(whoIsCheckingIn, Status)
{
   iniFolder:=GetPath("FireflyCheckinIniFolder")

   ;doing the checkin with fewer arguments
   whoIsCheckingIn :=  A_ComputerName . "_" . A_ScriptName
   iniFolderWrite(iniFolder, "ReadableCheckin", whoIsCheckingIn, CurrentTime("hyphenated"))
   iniFolderWrite(iniFolder, "TickCheckin", whoIsCheckingIn, A_TickCount)
   iniFolderWrite(iniFolder, "Status", whoIsCheckingIn, Status)
}
;}}}
