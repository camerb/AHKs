#include FcnLib.ahk
#include FcnLib-Clipboard.ahk
#include FcnLib-Nightly.ahk
#include SendEmailSimpleLib.ahk


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
GetReferenceNumber()
{
   Clipboard:=""
   ss()
   Click(1100, 165, "left double")
   ss()
   Send, {CTRLDOWN}c{CTRLUP}
   ss()
   ClipWaitNot("")

   referenceNumber:=Clipboard
   if NOT RegExMatch(referenceNumber, "[0-9]{5}")
      RecoverFromMacrosGoneWild("I didn't get the reference number (scroll up, maybe?) (error 14)", referenceNumber)

   return referenceNumber
}

GetServerName()
{
   Clipboard:=""
   StatusProCopyField(720, 237)
   ClipWaitNot("")
   serverName:=Clipboard

   if NOT RegExMatch(serverName, "[A-Za-z]{3}")
      RecoverFromMacrosGoneWild("I didn't get a server name (might have a long defendant name) (error 23)", serverName)

   ;TODO check if the name is in the server name list

   return serverName
}

GetStatus()
{
   Clipboard:=""
   ;StatusProCopyField(958, 374) ;experimenting trying to get it a little more reliable
   StatusProCopyField(953, 374)
   ClipWaitNot("")
   status:=Clipboard
   if NOT RegExMatch(status, "(Closed|Served|Cancelled|Personal|Substitute|Not Served|Found)")
   {
      ;iniPP("status-" . status)
      RecoverFromMacrosGoneWild("Invalid status (might have a long defendant name) (error 24) " . status)
   }
   return status
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

StatusProCopyField(xCoord, yCoord)
{
   Click(xCoord, yCoord, "left")
   Click(xCoord, yCoord, "right")
   Send, {DOWN 3}{ENTER}
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

;{{{ Not sure if these functions will be multi-use
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


