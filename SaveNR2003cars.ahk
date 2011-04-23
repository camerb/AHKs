#include FcnLib.ahk

page:=UrlDownloadToVar("http://www.blazinpedals.com/cfm/SNRS.php?action=download")
path=C:\Papyrus\NASCAR Racing 2003 Season\series\cupcts\cars\

Loop, parse, page, <>
{
   if RegExMatch(A_LoopField, "a href..(http.*snrs.(.*.cts.car)).", match)
   {
      carUrl := match1
      carFilename := match2
      carLocalFullPath=%path%%carFilename%
      ;if RegexMatch(carFilename, "^42")
         ;break
      ;carFile := UrlDownloadToVar(carUrl)
      FileDelete(carLocalFullPath)
      ;FileAppend(carFile, carLocalFullPath)
      UrlDownloadToFile, %carUrl%, %carLocalFullPath%

      count++
      msg=%count% cars downloaded
      ;debug(msg)
   }
}
;debug(msg)
;msgbox, finished downloading cars
