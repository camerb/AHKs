#include FcnLib.ahk


;filedelete, %a_scriptdir%\zzz1.txt
;fileread, in, %a_scriptdir%\pos2.txt

out:=RegExReplace("hello`tqwretuyiyui`tasdf`t`nafsdqwerafds`t`n", ".*\t{0,1}\w{8,}\t{0,1}.*", "`t", count)

FileAppend, %out%, %a_scriptdir%\zzz1.txt

ToolTip done - %count%
sleep, 2000
exitapp
Return

esc::ExitApp
