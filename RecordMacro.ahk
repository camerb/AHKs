#include FunctionLibrary.ahk

runPath:=ProgramFilesDir("\AutoHotkey\AutoScriptWriter\AutoScriptWriter.exe")
Run, %runPath%
Send {SHIFTUP}{CTRLUP}{AppsKey Up}
ForceWinFocus("AutoScriptWriter II - ( by Larry Keys ) ahk_class ASW_Dev_01", "Exact")

;TODO Sometimes it doesn't detect that we pressed it (need to detect this better)
Sleep 100
ControlClick, X56 Y55
Sleep 500
ControlClick, X56 Y55

;Wait for the appskey to be pressed (to end recording)
KeyWait, ``, D
ForceWinFocus("AutoScriptWriter II - ( by Larry Keys ) ahk_class ASW_Dev_01", "Exact")
ControlClick, X66 Y27

;Save as temporary.ahk and close
ForceWinFocus("AutoScriptWriter II - ( by Larry Keys ) ahk_class ASW_Dev_01", "Exact")
while true
{
   ControlClick, X19 Y305
   Sleep, 500
   IfWinExist, Save AutoHotkey Script
      break
   Sleep, 500 ;is this one really necessary?
}
ForceWinFocus("Save AutoHotkey Script")
ControlClick, X228 Y339
Sleep, 100
Send, ^a
Sleep, 100
SendInput, %A_WorkingDir%\temporary.ahk{ENTER}
;ControlClick, X471 Y409
Sleep, 100
WinClose, AutoScriptWriter II - ( by Larry Keys ) ahk_class ASW_Dev_01,
Sleep, 100

path="C:\My Dropbox\ahk-REFP\
infile=%path%in1.txt"
refile2=%path%regex-rawmacro.txt"
outfile=%path%out1.txt"

FileCopy, %A_WorkingDir%\temporary.ahk, C:\My Dropbox\ahk-REFP\in1.txt, 1
Sleep, 100

params := concatWithSep(" ", infile, refile2, outfile)
RunAhk("RegExFileProcessor.ahk", params)
Sleep, 200

;TODO allow an option for putting Sleep 100 on every other line
time:=CurrentTime("hyphenated")
FileCopy, C:\My Dropbox\ahk-REFP\out1.txt, %A_WorkingDir%\temporary.ahk, 1
FileCopy, %A_WorkingDir%\temporary.ahk, %A_WorkingDir%\archive\temporaryAHKs\%time%.ahk, 1
return
