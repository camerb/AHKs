#include FcnLib.ahk
#include ThirdParty\CmdRet.ahk

debug("silent log", "hi blue line")

;debug("silent log", FileExist("C:\code\epms\script\epms_workbench.pl"))
;FileCopy, C:\code\epms\script\epms_workbench.pl, C:\Dropbox\epms_workbench.pl
;FileCopy, C:\code\epms\cgi\controller\timecard.pm, C:\Dropbox\controller-timecard.pm
SleepSeconds(5)
FileCopy, C:\Dropbox\epms_workbench.pl, C:\code\epms\script\epms_workbench.pl, 1
SleepSeconds(1)
;RunWait, DebugAgain.ahk
debug("silent log", cmdret_runreturn("perl C:\code\epms\script\epms_workbench.pl"))

;Run, ForceReloadAll.exe
