#include FcnLib.ahk

timestamp := CurrentTime("hyphenated")
ahkText=
(
ProcessClose("vmware-vmx.exe")
ProcessClose("vmplayer.exe")
SleepSeconds(5)
addtotrace("red line - remotely closed VM (queued at %timestamp%)")
)

ScheduleRemoteAhk(ahkText, "baustian12")
