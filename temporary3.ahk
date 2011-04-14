#include FcnLib.ahk

FileGetTime, timestamp, C:\code\report.txt
FormatTime, returned, timestamp, yyyy-MM-dd_HH-mm-ss
debug(timestamp, returned)

