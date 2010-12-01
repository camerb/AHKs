#include FcnLib.ahk
#include thirdParty\ping.ahk

StartTime:=StartTimer()
ping("google.com")
ElapsedTime:=ElapsedTime(StartTime)

debug("ping finished")
debug(ElapsedTime)

