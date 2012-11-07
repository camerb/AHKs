#include FcnLib.ahk

ahk=InfiniteLoop.ahk
if IsAhkRunning(ahk)
   errord("test ahk was running")
Run, %ahk%
SleepSeconds(1)
if NOT IsAhkRunning(ahk)
   errord("test ahk was NOT running")
SleepSeconds(1)
if IsAhkRunning(ahk)
   errord("test ahk was running")



