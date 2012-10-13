;#singleinstance force
#include FcnLib.ahk
#include Lynx-FcnLib.ahk
#include Lynx-UpdateParts.ahk
#NoTrayIcon
;#singleinstance force
Lynx_MaintenanceType := "upgrade"

SendStartMaintenanceEmail()
ExitApp
