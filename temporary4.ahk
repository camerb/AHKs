#include FcnLib.ahk

name := Prompt("This will create a quick backup of the jira install`n`nDescribe the current state of the Jira install")
time := CurrentTime("hyphenated") . "-"

cDir=\\copper\c$\
sourceInstall=%cdir%Jira-4.4
sourceHome=%cdir%Jira-4.4-home
destInstall=%cdir%%time%Jira-4.4  %name%
destHome=%cdir%%time%Jira-4.4-home  %name%

FileCopyDir, %sourceInstall%, %destInstall%, 1
FileCopyDir, %sourceHome%, %destHome%, 1

msgbox, done copying jira files
exitapp
