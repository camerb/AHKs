#include FcnLib.ahk

LynxCompyName:="LynxGuide-R410"

if NOT (A_ComputerName = LynxCompyName)
{
   ;set computer name

   command=netdom.exe renamecomputer %A_ComputerName% /newname:%LynxCompyName% /userd:LAN\administrator /passwordd:Password1! /usero:administrator /passwordo:Password1! /reboot:5
   joe:= CmdRet_RunReturn(command)
   debug(joe)
}

;install IIS (clickin' around)


;turn off firewall
;SleepSend("#r")
;ForceWinFocus("Run")
;SleepSend("control firewall.cpl")

;turn on windows updates
;SleepSend("#r")
;ForceWinFocus("Run")
;SleepSend("control wuaucpl.cpl")

;install lynx messenger (cmd)


