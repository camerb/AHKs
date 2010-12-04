#include FcnLib.ahk

;if it isn't a VM, we'll run these ahks
;  but wait, do we really want to run there on Toshimi?
if NOT IsVM()
{
   RunAhk("RemoteWidget.ahk")
   RunAhk("Intellisense.ahk")
}

RunAhk("AutoHotkey.ahk")
