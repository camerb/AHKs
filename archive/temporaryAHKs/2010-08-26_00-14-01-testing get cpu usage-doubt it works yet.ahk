#include FcnLib.ahk

Process, Exist, Chrome.exe
joe=ErrorLevel
yo:=getcpuusage(joe)
debug(yo)
