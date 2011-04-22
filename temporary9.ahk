#include FcnLib.ahk
;#include FcnLib-Opera.ahk
;#include gitExempt/MonsterLogin.ahk

;MonsterLogin()

ram:=GetRamUsage("firefox.exe")
cpu:=GetCpuUsage("firefox.exe")
debug(ram, cpu)
