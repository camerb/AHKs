#include FcnLib.ahk

FileSelectFile , SaveAs ,S, , Save Script As, *.ahk
debug(SaveAs)
;If ( !SaveAs)
	;Return
;StringSplit , SaveAs , SaveAs , .
;if ( SaveAs0 > 1 )
	;SaveAs:=SaveAs
;else
	;Saveas:= SaveAs ".ahk"

