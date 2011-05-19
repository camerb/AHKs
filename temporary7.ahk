#include FcnLib.ahk

;investigating OnExit to improve queued AHKs
;QueuedAhkManager.ahk

;maybe we can write to a file when we have been interrupted while in the middle of an ahk
;maybe we can also have a list of ahks that are exempt from the queue (like keylogger, widget, intellisense, autohotkey.ahk)

OnExit, ExitSub

Loop
   SleepSeconds(1)

ExitSub:
debug("", A_ExitReason)
;note that the exitreason is single if the same ahk was launched again
;note that it is close if another ahk closed it
ExitApp
return

