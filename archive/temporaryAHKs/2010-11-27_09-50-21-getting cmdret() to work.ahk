#include FcnLib.ahk
#include Third Party\CMDret.ahk

;Run, systeminfo | find `"OS V`"
cmd=ping google.com
;cmd=systeminfo | find "OS V"
debug(cmd)
joe := CMDret_RunReturn(cmd)
debug(joe)
