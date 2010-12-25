#include FcnLib.ahk
#include ThirdParty/json.ahk

currentMonth=12
reTransCount=1
reTrans1=^%currentMonth%.*CHECK.*99.*176.10
reTransCount++
reTrans2=^%currentMonth%.*TIME WARNER
;debug(reTrans)
;debug(reTransCount)

path=C:\My Dropbox\ahk-REFP\
infile=%path%out1.txt
;outfile

Loop, Read, %infile%
{
   historyLine=%A_LoopReadLine%
   Loop, %reTransCount%
   {
      i=%A_Index%
      if RegExMatch(historyLine, reTrans%i%)
      {
         debug("found it", historyLine)
         ;TODO mark it as found
      }
   }
}

`:: ExitApp

;myJson(var, key, value="EMPTY")
;{
   ;if (value == "EMPTY")
      ;return json(var, key)
   ;json(var, key, value)
   ;;sucks! there seems to be no nice way to set the element (only change existing elements)
;}
