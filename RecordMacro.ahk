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
   Sleep 1000
}

;Save as raw_recorded.ahk and close
ForceWinFocus(aswWindow, "Exact")
ss()
Click(200, 200, "control")
ss()
SendInput, {CTRLDOWN}{HOME}{CTRLUP}
ss()
SendInput, {CTRLDOWN}{SHIFTDOWN}{END}{SHIFTUP}{CTRLUP}
ss()
SendInput, ^c
ss()
WinClose, %aswWindow%

FileAppend(Clipboard, tempFile)

;prepare for the transformation
path=C:\Dropbox\AHKs\REFP\
refile2=%path%regex-rawmacro.txt
REFP(tempFile, refile2, finalFile)
SleepSeconds(1)

;TODO allow an option for putting a short sleep on every other line
;TODO allow an option for relaxed ForceWinFocus (replaces file names with .*)
;TODO allow an option for putting a "die if 'Confluence' is not in Active Title" on every other line
FileCopy(finalFile, archiveFile, "overwrite")
ExitApp

ss()
{
   Sleep, 100
}

WinGetHeight(wintitle)
{
   WinGetPos, no, no, no, returned, %wintitle%
   return returned
}
