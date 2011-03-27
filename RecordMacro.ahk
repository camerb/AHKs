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

;TODO Sometimes it doesn't detect that we pressed it (need to detect this better)
;Sleep 100
;ControlClick, X56 Y55
;Sleep 500
;ControlClick, X56 Y55

;this is attempt at the better detection
while (WinGetHeight(aswWindow) > 70)
{
   ControlClick, X56 Y55
   Sleep 100
}

;Wait for the appskey to be pressed (to end recording)
KeyWait, ``, D
ForceWinFocus("AutoScriptWriter II - ( by Larry Keys ) ahk_class ASW_Dev_01", "Exact")
;ControlClick, X66 Y27

;this is attempt at the better detection
while (WinGetHeight(aswWindow) < 70)
{
   ControlClick, X66 Y27
   Sleep 100
}

;Save as temporary.ahk and close
ForceWinFocus(aswWindow, "Exact")
while NOT ForceWinFocusIfExist(SaveWindow)
{
   ControlClick, X19 Y305
   Sleep, 100 ;is this one really necessary?
}
ForceWinFocus(SaveWindow)
Send, ^a
ss()
ForceWinFocus(SaveWindow)
SendInput, %tempFile%
ss()
SendInput, {ENTER}
ss()
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
