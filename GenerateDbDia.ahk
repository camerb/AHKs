#include FcnLib.ahk
#include thirdParty/CmdRet.ahk

;proj := Prompt("Which project do you want to make a Dia for? epms/fl")
proj=epms
proj=fl

workingDir=C:\Dropbox\Documentation\scripts\
script=C:\Dropbox\Documentation\scripts\schema_to_dia-%proj%.pl
dia=C:\Dropbox\Documentation\scripts\%proj%.dia

if NOT FileExist(script)
{
   errord(A_ThisFunc, script, "the aforementioned file does not exist")
   exitapp
}

cmd=perl "%script%" > "%proj%"

;cmd=perl "%script%"
results:=CmdRet_RunReturn(cmd, workingDir)
;cmd=perl "%script%" > "%proj%"
;RunWait, %cmd%
;FileCreate(results, dia)
debug("finished creating dia")
