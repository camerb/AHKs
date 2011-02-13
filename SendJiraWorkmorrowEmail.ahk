#include FcnLib.ahk
#include ThirdParty/CmdRet.ahk

if (A_ComputerName <> "PHOSPHORUS")
   ExitApp

command=perl C:\code\mtsi-scripts\jira-status.pl
returned .= "Auto:  `n" . CmdRet_RunReturn( command . "    " ) . "`n`n"
returned .= "2 days:`n" . CmdRet_RunReturn( command . " -2d" ) . "`n`n"
returned .= "3 days:`n" . CmdRet_RunReturn( command . " -3d" ) . "`n`n"
returned .= "4 days:`n" . CmdRet_RunReturn( command . " -4d" ) . "`n`n"
returned .= "5 days:`n" . CmdRet_RunReturn( command . " -5d" ) . "`n`n"

;debug(returned)
;ExitApp

date:=CurrentTime("slashdate")
subj=Minutes for %date%
;debug(subj)
SendEmail(subj, returned)
