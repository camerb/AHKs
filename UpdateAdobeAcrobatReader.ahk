#include FcnLib.ahk

RunProgram("C:\Program Files\Adobe\Reader 10.0\Reader\AcroRd32.exe")
RunProgram("AcroRd32.exe")
ForceWinFocus("Adobe Reader")
Send, {ALT}hu

timeToQuit:=AddDatetime(CurrentTime(), 4, "minutes")

Loop
{
   if ForceWinFocusIfExist("Adobe Reader Updater")
   {
      wintext := WinGetText()

      if InStr(wintext, "Update is available")
         Send, !d
      else if InStr(wintext, "Update is ready to install")
         Send, !i
      else if InStr(wintext, "Update successful")
         exit()
      else if InStr(wintext, "No updates available")
         exit()
      else if InStr(wintext, "Checking for updates")
         { } ;nothing, just wait
   }

   IfWinExist, ahk_class tooltips_class32, install
   {
      ForceWinFocus("Adobe Reader")
      Send, {ALT}hu
   }

   if CurrentlyAfter(timeToQuit)
      Exit()

   Sleep 100
}

Exit()

;if AcrobatNeedsUpdate()
;{

   ;;SleepSeconds(20)
   ;;wait for tooltip to pop up
   ;WinWait, ahk_class tooltips_class32, install, 20
   ;delog("yellow line", "Found this tooltip. Maybe it means acrobat update is ready for install", A_ScriptName, A_LineNumber, WinGetText("ahk_class tooltips_class32"))

   ;ForceWinFocus("Adobe Reader Updater")
   ;Send, {ALT}hu
   ;WinWaitActive, , Update is ready to install, 15
   ;Send, !i
   ;WinWaitActive, , Update successful, 60
   ;WinClose

   ;Pause
;}


;AcrobatNeedsUpdate()
;{
   ;ForceWinFocus("Adobe Reader")
   ;Send, {ALT}hu

   ;ForceWinFocus("Adobe Reader Updater")
   ;WinWaitActive, , No updates available, 15
   ;;MultiWinWait("", "No updates available", "", "Update is available")
   ;ForceWinFocus("Adobe Reader Updater")
   ;CheckForUpdateResults := WinGetText()

   ;if InStr(CheckForUpdateResults, "Update is available")
      ;return true
   ;else if !InStr(CheckForUpdateResults, "No updates available")
      ;delog("yellow line", "Checked for Adobe Acrobat Reader updates and this is what I got:", A_ScriptName, A_LineNumber, A_ThisFunc, CheckForUpdateResults)
   ;return false
;}

exit()
{
   ;Close the affected windows
   Process, Close, AcroRd32.exe
   Process, Close, AdobeARM.exe
   ExitApp
}
