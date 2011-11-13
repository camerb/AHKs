#include FcnLib.ahk

name := Prompt("This will create a quick backup of the atlassian install`n`nDescribe the current state of the atlassian install")
time := CurrentTime("hyphenated") . "-"

cDir=\\copper\c$\
;jira
;sourceInstall=%cdir%Jira-4.4
;sourceHome=%cdir%Jira-4.4-home
;destInstall=%cdir%%time%Jira-4.4  %name%
;destHome=%cdir%%time%Jira-4.4-home  %name%

;confluence
;\\copper\c$\atlassian-confluence-3.5.13-std
;c:/confluence-3.5-home
sourceInstall=%cdir%atlassian-confluence-3.5.13-std
sourceHome=%cdir%confluence-3.5-home
destInstall=%cdir%%time%atlassian-confluence-3.5.13-std  %name%
destHome=%cdir%%time%confluence-3.5-home  %name%

FileCopyDir, %sourceInstall%, %destInstall%, 1
FileCopyDir, %sourceHome%, %destHome%, 1

msgbox, done copying atlassian files
exitapp
