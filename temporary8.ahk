#include FcnLib.ahk



text=
(
ExitApp
CrazyNonExistantFunction()
)

;ahk=C:\Dropbox\AHKs\scheduled\BAUSTIAN-09PC\asap.ahk
ahk=C:\Dropbox\AHKs\asap.ahk

FileCreate(text, ahk)
exe:=CompileAhk(ahk)
;Run, %ahk%
;Run, %ahk%, , UseErrorLevel
Run, %exe%, , UseErrorLevel
debug(ERRORLEVEL)

;Run, Target [, WorkingDir, Max|Min|Hide|UseErrorLevel, OutputVarPID]
