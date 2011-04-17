#include FcnLib.ahk
;#include FcnLib-Opera.ahk
;#include gitExempt/MonsterLogin.ahk

;MonsterLogin()

GetProcessMemory_Private("firefox.exe")
GetProcessMemory_Private(ProcName, Units="K") {
    Process, Exist, %ProcName%
    pid := Errorlevel

    ; get process handle
    hProcess := DllCall( "OpenProcess", UInt, 0x10|0x400, Int, false, UInt, pid )

    ; get memory info
    PROCESS_MEMORY_COUNTERS_EX := VarSetCapacity(memCounters, 44, 0)
    DllCall( "psapi.dll\GetProcessMemoryInfo", UInt, hProcess, UInt, &memCounters, UInt, PROCESS_MEMORY_COUNTERS_EX )
    DllCall( "CloseHandle", UInt, hProcess )

    SetFormat, Float, 0.0 ; round up K

    PrivateBytes := NumGet(memCounters, 40, "UInt")
    if (Units == "B")
        return PrivateBytes
    if (Units == "K")
        Return PrivateBytes / 1024
    if (Units == "M")
        Return PrivateBytes / 1024 / 1024
}
