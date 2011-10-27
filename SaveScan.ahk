#include FcnLib.ahk

timestamp:=CurrentTime("hyphenated")
file=%A_MyDocuments%\%timestamp%.jpg
finalDest=C:\Dropbox\AHKs\gitExempt\scans\%timestamp%.jpg

ProcessClose("wiaacmgr.exe")

Run, C:\WINDOWS\system32\wiaacmgr.exe -SelectDevice
ForceWinFocus("Scanner and Camera Wizard", "Exact")
Sleep, 100
ClickButton("&Next")
ClickButton("&Next")
Send, %timestamp%
ClickButton("&Next")
ClickButton("&Next")
WinMinimize, Scanner and Camera Wizard
WinWait, , Picture progress`: 100`% complete
;FileWaitNotExist(file)
Loop
{
   if FileGetSize(file)
      break
}
Sleep, 500
FileMove(file, finalDest)
WinClose
ExitApp
