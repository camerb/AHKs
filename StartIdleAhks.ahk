#include FcnLib.ahk
;msgbox, %A_WorkingDir%

;if it isn't a VM, we'll run these ahks
;  but wait, do we really want to run these on Toshimi?
if NOT IsVM()
{
   RunAhk("RemoteWidget.ahk")
   RunAhk("IntelliSense2.ahk")
}

RunAhk("AutoHotkey.ahk")
