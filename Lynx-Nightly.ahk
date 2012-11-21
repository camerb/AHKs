;#singleinstance force
#include FcnLib.ahk
#include Lynx-FcnLib.ahk
#include Lynx-UpdateParts.ahk
;#singleinstance force
Lynx_MaintenanceType := "Nightly"

notify("running lynx nightly")
DownloadLynxFile("7.12.zip")

ExitApp

