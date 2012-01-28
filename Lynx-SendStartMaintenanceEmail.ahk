;#singleinstance force
#include FcnLib.ahk
#include Lynx-FcnLib.ahk
#include Lynx-UpgradeParts.ahk
#NoTrayIcon
;#singleinstance force
Lynx_MaintenanceType := "upgrade"

SendStartMaintenanceEmail()
ExitApp
