#include FunctionLibrary.ahk

;var:=urldownloadtovar("https://www.att.com/olam/gotoDataDetailsAction.olamexecute?reportActionEvent=A_UMD_DATA_DETAILS")
;debug(var)
datestamp:=CurrentTime("hyphenated")

line1=git add --all
line2=git commit -am "%datestamp%"
;##git checkout master
line3=git push git@github.com:camerb/AHKs.git master
line4:=SexPanther()

Run, C:\WINDOWS\system32\cmd.exe /c ""C:\Program Files\Git\bin\sh.exe" --login -i"

Loop 4
{
   Sleep, 1000
   ;ForceWinFocus("MINGW32:/c/AHKs ahk_class ConsoleWindowClass", "Exact")
   ForceWinFocus("MINGW32:/c/My Dropbox/AHKs ahk_class ConsoleWindowClass", "Exact")
   thisLine:=line%A_Index%
   Send, %thisLine%{ENTER}
}
