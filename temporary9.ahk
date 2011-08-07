#include FcnLib.ahk

Loop 9
{
   file=temporary%A_Index%.ahk
   header=#### %file% ####`n
   allText .= header
   linesIncluded=0
   Loop 15
   {
      includeLine:=true
      thisLine := FileReadLine(file, A_Index)
      if RegExMatch(thisLine, "^;*\#include")
         includeLine:=false
      if (linesIncluded >= 5)
         includeLine:=false
      if (thisLine == "")
         includeLine:=false

      if includeLine
      {
         linesIncluded++
         allText .= thisLine . "`n"
         includeLine:=false
      }
   }
   allText .= "`n`n"
}

Gui, Add, Edit, r65 c10 vMyEdit Disabled, %allText%
Gui, Show, x10 y10
;Gui, Show, W100 H300 X10 Y10
