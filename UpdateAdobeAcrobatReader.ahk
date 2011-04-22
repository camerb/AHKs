#include FcnLib.ahk

RunProgram("C:\Program Files\Adobe\Reader 9.0\Reader\AcroRd32.exe")
if AcrobatNeedsUpdate()
   debug("update adobe acrobat reader") ;TODO

;Close the affected windows
Process, Close, AcroRd32.exe
Process, Close, AdobeARM.exe
ExitApp

AcrobatNeedsUpdate()
{
   ForceWinFocus("Adobe Reader")
   Send, {ALT}hu

   ForceWinFocus("Adobe Reader Updater")
   WinWaitActive, , No updates available, 5
   ForceWinFocus("Adobe Reader Updater")
   CheckForUpdateResults := WinGetText()

   ;TODO... figure out what it actually says when there is an update
   if InStr(CheckForUpdateResults, "Update your friggin acrobat reader")
      return true
   else if !InStr(CheckForUpdateResults, "No updates available")
      delog("yellow line", "Checked for Adobe Acrobat Reader updates and this is what I got:", A_ScriptName, A_LineNumber, A_ThisFunc, CheckForUpdateResults)
   return false
}
