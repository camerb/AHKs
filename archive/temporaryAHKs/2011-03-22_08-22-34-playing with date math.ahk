#include FcnLib.ahk

dt:=CurrentTime()
joe:=dt
joe += -2, days

debug(dt, joe)
joe := FormatTime(joe, "yyyyMMdd")
debug(dt, joe)
