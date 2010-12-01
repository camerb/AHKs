#include FcnLib.ahk

dd=%1%
if (dd=="")
   debug("ASDFGASDFA")

number:=3
i:=1
parameters:="ZZZ"

bob()

bob()
{
dd=%1%
debug(dd)
dd=%2%
debug(dd)
dd=%3%
debug(dd)
}

;joe(%0%)

;joe(asdf)
;{
   ;debug(%0%)
   ;Loop %0%
   ;{
      ;parameter:=%A_Index%
      ;parameters+=parameter
      ;;debug(parameter)
      ;;if (number==i)
         ;debug(parameter)
         ;debug(parameters)
         ;;return %parameter%
      ;i++
   ;}
;}
;t(1, %0%)
;t(2, %0%)
;t(3, %0%)
;t(1, %0%)
;t(3, %0%)
;t(2, %0%)
;t(1, %0%)

t(num, p)
{
var:=getParam(num, p)
debug(var)
}

getParam(number, params)
{
   i:=1
   Loop %params%
   {
      parameter:=%A_Index%
      debug(parameter)
      if (number==i)
         return %parameter%
      i++
   }
}
