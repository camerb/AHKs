#include FcnLib.ahk
#include ThirdParty/CmdRet.ahk

param=%1%

if (A_ComputerName <> "PHOSPHORUS")
   ExitApp

date:=CurrentTime("slashdate")
subj=Minutes for %date%

if (param = "reminder")
{
   subj:="Update your jira tasks (completed and workmorrow)"
   returned.="http://jira.mitsi.com/`nMessage sent by bot`n`n"
}

command=perl C:\code\mtsi-scripts\jira-status.pl
returned .= "Auto:  `n" . CmdRet_RunReturn( command . "    " ) . "`n`n"
;returned .= "2 days:`n" . CmdRet_RunReturn( command . " -2d" ) . "`n`n"
;returned .= "3 days:`n" . CmdRet_RunReturn( command . " -3d" ) . "`n`n"
;returned .= "4 days:`n" . CmdRet_RunReturn( command . " -4d" ) . "`n`n"
;returned .= "5 days:`n" . CmdRet_RunReturn( command . " -5d" ) . "`n`n"

if InStr(returned, "exception.RemoteAuthenticationException")
   returned := "Login exceptions detected (likely an incorrect username/password)`n`n" . returned
else if (param = "reminder")
   SendEmail(subj, returned)
else
   SendEmail(subj, returned, "", "nathan@mitsi.com,cameronbaustian@gmail.com", "cameronbaustian@gmail.com")

file=C:\Dropbox\Public\JiraWorkmorrow.txt
fileContents=%subj%`n%returned%
FileDelete(file)
FileAppend(fileContents, file)
