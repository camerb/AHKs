#include FcnLib.ahk

RunProgram("C:\Program Files\Adobe\Reader 9.0\Reader\AcroRd32.exe")
if AcrobatNeedsUpdate()
{
   Send, !d

   ;SleepSeconds(20)
   ;wait for tooltip to pop up
   WinWait, ahk_class tooltips_class32, install, 20
   delog("yellow line", "Found this tooltip. Maybe it means acrobat update is ready for install", A_ScriptName, A_LineNumber, WinGetText("ahk_class tooltips_class32"))

   ForceWinFocus("Adobe Reader Updater")
   Send, {ALT}hu
   WinWaitActive, , Update is ready to install, 15
   Send, !i
   WinWaitActive, , Update successful, 60
   WinClose

   Pause
}

;Close the affected windows
Process, Close, AcroRd32.exe
Process, Close, AdobeARM.exe
ExitApp

AcrobatNeedsUpdate()
{
   ForceWinFocus("Adobe Reader")
   Send, {ALT}hu

   ForceWinFocus("Adobe Reader Updater")
   WinWaitActive, , No updates available, 15
   ;MultiWinWait("", "No updates available", "", "Update is available")
   ForceWinFocus("Adobe Reader Updater")
   CheckForUpdateResults := WinGetText()

   if InStr(CheckForUpdateResults, "Update is available")
      return true
   else if !InStr(CheckForUpdateResults, "No updates available")
      delog("yellow line", "Checked for Adobe Acrobat Reader updates and this is what I got:", A_ScriptName, A_LineNumber, A_ThisFunc, CheckForUpdateResults)
   return false
}
