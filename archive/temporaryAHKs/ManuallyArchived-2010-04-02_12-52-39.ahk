#include FcnLib.ahk

FileCopy, http://www.nascarsimworld.com/download/Daytona_TU_Day.zip, C:\DataExchange\Daytona_TU_Day.zip
if ERRORLEVEL
   debug("fail")
else
   debug("FTW!!")

;FIXME FTW??? this doesn't actually work, but it says it works... odd (need to investigate)
