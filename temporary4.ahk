#include FcnLib.ahk

name := Prompt("This will create a quick backup of the jira install`n`nDescribe the current state of the Jira install")
time := CurrentTime("hyphenated") . "-"

cDir=\\copper\c$\
sourceInstall=%cdir%Jira-4.4
sourceHome=%cdir%Jira-4.4-home
destInstall=%cdir%%time%Jira-4.4
destHome=%cdir%%time%Jira-4.4-home

FileCopyDir, %sourceInstall%, %destInstall%, 1
FileCopyDir, %sourceHome%, %destHome%, 1

