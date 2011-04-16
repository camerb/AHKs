#include FcnLib.ahk

time:=CurrentTime("hyphenated")
tempFile=%A_WorkingDir%\temp\raw_recorded.ahk
finalFile=%A_WorkingDir%\temporary.ahk
archiveFile=%A_WorkingDir%\archive\temporaryAHKs\%time%.ahk

aswWindow=AutoScriptWriter II - ( by Larry Keys ) ahk_class ASW_Dev_01
saveWindow=Save AutoHotkey Script

RunProgram("C:\Program Files\AutoHotkey\AutoScriptWriter\AutoScriptWriter.exe")

Send {SHIFT UP}{ALT UP}{CTRL UP}{APPSKEY UP}
ForceWinFocus(aswWindow, "Exact")

;this is attempt at the better detection
while (WinGetHeight(aswWindow) > 70)
{
   ControlClick, X56 Y55
   Sleep 100
}

;Wait for the appskey to be pressed (to end recording)
KeyWait, ``, D
FileDelete(tempFile)
ForceWinFocus("AutoScriptWriter II - ( by Larry Keys ) ahk_class ASW_Dev_01", "Exact")

;this is attempt at the better detection
while (WinGetHeight(aswWindow) < 70)
{
   ControlClick, X66 Y27
   Sleep 100
}

;Save as temporary.ahk and close
ForceWinFocus(aswWindow, "Exact")
WinMove, 10, 10
ss()
while NOT ForceWinFocusIfExist(SaveWindow)
{
   WinMove, 10, 10
   ControlClick, X19 Y305
   Sleep, 900 ;is this one really necessary?
}
if NOT (WinGetActiveTitle() == saveWindow)
   fatalErrord("the save window didn't activate correctly", A_ScriptName, A_LineNumber)
ss()
SendInput, ^a
ss()
SendInput, %tempFile%
ss()
SendInput, {ENTER}
ss()
sleepseconds(1)
while ForceWinFocusIfExist(SaveWindow)
   WinClose, %SaveWindow%
Loop 10
{
   if FileExist(tempFile)
      break
   ss()
}

if NOT FileExist(tempFile)
   fatalErrord("the script file was not saved properly", A_ScriptName, A_LineNumber)
WinClose, %aswWindow%
ss()

path=C:\My Dropbox\AHKs\REFP\
infile=%path%in1.txt
refile2=%path%regex-rawmacro.txt
outfile=%path%out1.txt

;FileCopy(tempFile, inFile, "overwrite")
ss()

;REFP(infile, refile2, outfile)
REFP(tempFile, refile2, finalFile)
SleepSeconds(1)

;TODO allow an option for putting a short sleep on every other line
FileCopy(finalFile, archiveFile, "overwrite")
return

ss()
{
   Sleep, 100
}

WinGetHeight(wintitle)
{
   WinGetPos, no, no, no, returned, %wintitle%
   return returned
}
