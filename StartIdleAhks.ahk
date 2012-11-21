#include FcnLib.ahk

;first do the ones that we definitely want to run, then do the conditionals
;DEPRECATEME and use the method below instead
;RunAhk("ModifierKeysUp.ahk")
RunAhk("AutoHotkey.ahk")
RunAhk("Persistent2.ahk")
RunAhk("ImageIt.ahk")

;instead, lets get the AHKs that are always idle from a list
;idleAhksList := AlwaysIdleAhks()
;Loop, parse, idleAhksList, CSV
   ;RunAhk(A_LoopFielr)

;if it isn't a VM, we'll run these ahks
;  but wait, do we really want to run these on Toshimi?
if NOT (IsVM() OR A_ComputerName = "TOSHIMI" OR A_ComputerName = "T-800")
{
   RunAhk("RemoteWidget.ahk")
   RunAhk("IntelliSense2.ahk")
   RunAhk("Keylogger.ahk")
}
