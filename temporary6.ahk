#include FcnLib.ahk
#include thirdParty/cmdret.ahk

;test if the internet is down

timer:=starttimer()
url:=cycle("google.com", "dl.dropbox.com/u/789954/logs/trace.txt")
joe:=urldownloadtovar("google.com")
joe:=urldownloadtovar("dl.dropbox.com/u/789954/logs/trace.txt")
elapsed:=elapsedtime(timer)
addtotrace(joe, elapsed)

;if InternetIsDown()
   ;errord("the internets are down")
;else
   ;debug("the internet is working fine")

InternetIsDown()
{
   if ( CantContact("google.com")
         AND CantContact("usaa.com")
         AND CantContact("amazon.com")
         AND CantContact("yahoo.com") )
      return true
   else
      return false
}

CantContact(url)
{
   cmd=ping %url%
   result := cmdret_runreturn("ping google.com")
   if InStr(result, "Ping request could not find host")
      return true
   return false
}
