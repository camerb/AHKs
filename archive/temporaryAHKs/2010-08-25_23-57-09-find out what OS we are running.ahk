#include FcnLib.ahk

joe:=GetOS()
;debug(joe)
;debug(A_OSVersion)
;debug(GetOS())

;WIN_VISTA
;WIN_XP

if ( GetOS() == "WIN_XP" )
   debug("using xp")
else if ( GetOS() == "WIN_VISTA" )
   debug("using vista")
else
   debug("other os")
