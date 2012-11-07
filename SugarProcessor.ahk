#include FcnLib.ahk

;process the data from sugar spy so we can get some names and lists going

;process each sugar view
Loop, C:\DataExchange\Sugar\*.txt
{
   thisFile := A_LoopFileFullPath
   urlPart := FileReadLine(thisFile, 1)
   url=http://sugar.mitsi.com/index.php?%urlPart%

   module := ""
   action := ""
   record := ""

   ;process each param
   ;StringSplit, param
   Loop, parse, urlPart, &
   {
      StringSplit, part, A_LoopField, =
      if InStr(part1, "sugar")
      {
         if (part1 = "sugar.mitsi.com/index.php")
         {
            ;A file that says they visited the home page is useless... I don't care if they visited the home page
            FileDelete(thisFile)
            iniPP("Deleted a file with a home page")
            continue, 2
         }
         else
            debug("notimeout", "here are part 1 and 2", part1, part2, thisFile, thisLine)
      }
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

ExitApp
Esc::ExitApp
