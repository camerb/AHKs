#include FcnLib.ahk
#include Lynx-FcnLib.ahk
#include Lynx-UpdateParts.ahk
#include Lynx-InstallParts.ahk

;debug(GetBackupPath())
;debug(GetDatabaseFilePath())
debug(GetLogPath())
CheckIfSubscriptionNeedsToBeTurnedOff()


;TESTME
;GetLogPath()
;{
   ;returned := LynxDatabaseQuerySingleItem("select * from Setup where type = 'log'", "Value")
   ;;returned := LynxDatabaseQuery("select * from Setup where type = 'log'", "Value")
   ;;lynx_log("DB File Path was |||" . returned . "|||")
   ;return returned
;}

ExitApp
#include Lynx-Update.ahk
