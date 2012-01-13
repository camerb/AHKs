#include FcnLib.ahk

;if it isn't a VM, we'll run these ahks
;  but wait, do we really want to run these on Toshimi?
if NOT (IsVM() OR A_ComputerName = "TOSHIMI")
{
   RunAhk("RemoteWidget.ahk")
   RunAhk("IntelliSense2.ahk")
   RunAhk("Keylogger.ahk")
}

;RunAhk("ModifierKeysUp.ahk")
RunAhk("AutoHotkey.ahk")
