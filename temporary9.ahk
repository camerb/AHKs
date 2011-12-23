#include FcnLib.ahk

;making a zeropad function

SetFormat, float, 06.0

debug(zeropad2(31, 6))
;debug(11zeropad2(31, 6))

;format can be like 6
zeropad(number, format)
{
   numberBeforeDecimal := format
   zeroes=00000000000000000000000
   needle=(\d{%zeroes%})$
   RegExMatch(number, needle, match)
   return match1
}

;this will probably have some ugly repercussions
zeropad2(num, digits)
{
   prevFormat:=A_FormatFloat
   tempFormat=0%digits%.0
   SetFormat, float, %tempFormat%
   ;SetFormat, float, 06.0
   ;returned:=num
   returned:=num+1.0
   SetFormat, float, %prevFormat%
   return returned
}
