Run, NewTempAhk.ahk
;#include FcnLib.ahk

;;IsFileEqual(1, 2)
;loop 9
;{
   ;file=temporary%A_Index%.ahk
   ;;debugbool(IsFileEqual("template.ahk",file))
   ;if IsFileEqual("template.ahk",file)
   ;{
      ;;debug(A_Index)
      ;break
   ;}
;}

;if ForceWinFocusIfExist("AHKs.*GVIM", "Contains")
;{
   ;Send, {ESC 6}
   ;Send, {;}
   ;SendInput, split %file%{ENTER}
;}
