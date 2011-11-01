#include FcnLib.ahk

list:=GetProcesses()
Sort, list, CL U ; remove duplicates
debug(list)
