#include FcnLib.ahk

#Persistent
SetTimer, Persist, 500
ScriptCheckin("Started")
return

Persist:

ScriptCheckin("Working")
;end of Persist subroutine
return

;fcns (for this file only) will go here
