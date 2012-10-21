#include FcnLib.ahk

;process the data from sugar spy so we can get some names and lists going

Loop, C:\DataExchange\Sugar\*.txt
{
   thisFile := A_LoopFileFullPath
   urlPart := FileReadLine(thisFile, 1)
   url=http://sugar.mitsi.com/index.php?%urlPart%

   ;StringSplit, param
   Loop, parse, urlPart, &
   {
      StringSplit, part, A_LoopField, =
      %part1% := part2
   }

   prettyUrl=http://sugar.mitsi.com/index.php?module=Accounts&action=DetailView&record=%record%
   ;if (module = "Accounts" AND action = "DetailView")
      ;Run, %prettyUrl%


   hi=%module%`t%action%`t%record%
   msg .= hi

   ;Run, %url%
   ;msg .= url
   msg .= "`n"
}
;debug(msg)
;Clipboard := msg
