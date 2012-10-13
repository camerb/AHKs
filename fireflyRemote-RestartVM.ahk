#include FcnLib.ahk

timestamp := CurrentTime("hyphenated")
ahkText=
(
addtotrace("orange line - restarting VM remotely (queued at %timestamp%)")
Run, restart.ahk
)

ScheduleRemoteAhk(ahkText, "baustianvm")
