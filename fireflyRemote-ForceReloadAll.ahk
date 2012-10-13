#include FcnLib.ahk

timestamp := CurrentTime("hyphenated")
ahkText=
(
addtotrace("yellow line - remote ForceReloadAll (queued at %timestamp%)")
HowManyAhksAreRunning()
Run, ForceReloadAll.exe
)

ScheduleRemoteAhk(ahkText, "baustianvm")
