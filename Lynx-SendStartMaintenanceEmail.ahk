;#singleinstance force
#include FcnLib.ahk
#include Lynx-FcnLib.ahk
#NoTrayIcon
;#singleinstance force
Lynx_MaintenanceType := "upgrade"

SendStartMaintenanceEmail()
ExitApp
#include Lynx-Update.ahk
#include Lynx-Install.ahk
