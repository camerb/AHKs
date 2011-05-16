#include FcnLib.ahk
#include ThirdParty\CmdRet.ahk

;debug("silent log", "hi blue line")

;debug("silent log", FileExist("C:\code\epms\script\epms_workbench.pl"))
;FileCopy, C:\code\epms\script\epms_workbench.pl, C:\My Dropbox\epms_workbench.pl
;FileCopy, C:\code\epms\cgi\controller\timecard.pm, C:\My Dropbox\controller-timecard.pm
SleepSeconds(5)
FileCopy, C:\My Dropbox\epms_workbench.pl, C:\code\epms\script\epms_workbench.pl, 1
SleepSeconds(1)
;RunWait, DebugAgain.ahk
addtotrace(cmdret_runreturn("perl C:\code\epms\script\epms_workbench.pl"))
;addtotrace("green line")

;Run, ForceReloadAll.exe
