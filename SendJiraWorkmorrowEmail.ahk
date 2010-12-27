#include FcnLib.ahk
#include ThirdParty/CmdRet.ahk

if (A_ComputerName = "PHOSPHORUS")
{
   command=perl C:\code\mtsi-scripts\jira-status.pl
   returned := CmdRet_RunReturn(command)
   ;Run, %command%, C:\code\mtsi-scripts

   ;debug(returned)

   date:=CurrentTime("", "slashdate")
   subj=Minutes for %date%
   ;debug(subj)
   SendEmail(subj, returned)
)
