#include FcnLib.ahk

if NOT A_ComputerName = "BAUSTIAN-09PC"
   return

;var:=urldownloadtovar("https://www.att.com/olam/gotoDataDetailsAction.olamexecute?reportActionEvent=A_UMD_DATA_DETAILS")
;debug(var)
datestamp:=CurrentTime("hyphenated")
gitWindow=MINGW32:/c/Dropbox/AHKs ahk_class ConsoleWindowClass

line1=git add --all
line2=git commit -am "%datestamp%"
;##git checkout master
line3=git push git@github.com:camerb/AHKs.git master
line4:=SexPanther()

Run, C:\WINDOWS\system32\cmd.exe /c ""C:\Program Files\Git\bin\sh.exe" --login -i"

Loop 4
{
   Sleep, 5000
   ForceWinFocus(gitWindow, "Exact")
   thisLine:=line%A_Index%
   Send, %thisLine%{ENTER}
}

SleepMinutes(2)
WinClose, %gitWindow%
