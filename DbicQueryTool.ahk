#include FcnLib.ahk
#include thirdParty/CmdRet.ahk

;a spiffy little DBIC query tool
;by camerb

filename    =C:\code\epms\script\epms_workbench2.pl
filename_tpl=C:\code\epms\script\epms_workbench_tpl.pl

code := prompt("Input your DBIC query")
if NOT code
   ExitApp

FileCopy(filename_tpl, filename, "overwrite")
;FileAppendLine("warn 'joe';", filename)
;FileAppendLine("Dwarn $schema->resultset('Survey')->search({ campaign_id => 11 })->count", filename)
FileAppendLine(code, filename)

;TODO maybe we could have this output to a csv file and then use openoffice to view it
;        OR we could output to CSV and make an AHK CSV viewer

results := CmdRet_RunReturn("perl " . filename)
debug(results)
