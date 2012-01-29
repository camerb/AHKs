#include FcnLib.ahk

fatalIfNotThisPc("BAUSTIAN-09PC")

repoPath=/c/Dropbox/Projects/Hatchling-IRC
gitRepoName=Hatchling-IRC

datestamp:=CurrentTime("hyphenated")
gitWindow=MINGW32:%repoPath% ahk_class ConsoleWindowClass

line1=git add --all
line2=git commit -am"%datestamp%"
;##git checkout master ; don't checkout, cause we don't care at all about contributions from others. ;TODO change this for Hatchling!!!
line3=git push git@github.com:camerb/%gitRepoName%.git master
line4:=SexPanther()

Run, C:\WINDOWS\system32\cmd.exe /c ""C:\Program Files\Git\bin\sh.exe" --login -i"
ForceWinFocus("MINGW32", "Contains")
Send, cd "%repoPath%"{ENTER}

Loop 4
{
   Sleep, 5000
   ForceWinFocus(gitWindow, "Exact")
   thisLine:=line%A_Index%
   Send, %thisLine%{ENTER}
}

WinMinimize, %gitWindow%
SleepMinutes(2)
WinClose, %gitWindow%
