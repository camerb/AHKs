#include FcnLib.ahk
#include thirdParty\CMDret.ahk


;Run, systeminfo | find `"OS V`"
;cmd=ping google.com
;cmd=systeminfo | find "OS V"
;debug(cmd)
;joe := CMDret_RunReturn(cmd)
;debug(joe)
Getos()
RegRead, vista7, HKLM, SOFTWARE\Microsoft\Windows NT\CurrentVersion, CurrentVersion
debug("OS using regread", vista7)
