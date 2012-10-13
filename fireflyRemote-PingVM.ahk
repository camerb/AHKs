#include FcnLib.ahk

timestamp := CurrentTime("hyphenated")
ahkText=
(
addtotrace("green line - pinged VM (queued at %timestamp%)")
)

ScheduleRemoteAhk(ahkText, "baustianvm")
