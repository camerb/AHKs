#include FcnLib.ahk
#include FcnLib-Nightly.ahk

MintLogIn()
mintPage := iMacroUrlDownloadToVar("https://wwws.mint.com/overview.event")

;AddToTrace(mintPage)
;mintPage:=FileRead(GetPath("trace"))

ini=C:\Dropbox\AHKs\gitExempt\mintIDs.ini

keylist := IniListAllKeys(ini, "default")
Loop, parse, keylist, CSV
   GrabDataFromPage(mintPage, A_LoopField)

ExitApp

GetRegEx(tag, contents="")
{
   none=[^<>]*
   if contents
      returned=<%none%%tag%%none%>((%none%%contents%%none%)</%none%>)
   else
      returned=<%none%%tag%%none%>((%none%)</%none%>)?
   return returned
}

GrabDataFromPage(page, id)
{
   none=[^<>]*
   oneXML=<%none%>
   smallXML=<[^<>]{0,3}>
   smallOrNone=(%smallXML%|%none%)*
   ;balanceRE:=GetRegEx("balance")
   ;accountRE:=GetRegEx("accountName")
   ;updatedRE:=GetRegEx("last-updated")
   ;nicknameRE:=GetRegEx("nickname")
   accountIdRE:=GetRegEx("accountId=" . id) . smallOrNone
   imageRE:=GetRegEx("img") . smallOrNone
   balanceRE:=GetRegEx("balance") . smallOrNone
   accountRE:=GetRegEx("accountName") . smallOrNone
   updatedRE:=GetRegEx("last-updated") . smallOrNone
   nicknameRE:=GetRegEx("nickname") . smallOrNone

   regex=(?P<id>%accountIdRE%)%imageRE%(?P<balance>%balanceRE%)%accountRE%(?P<updated>%updatedRE%)(?P<nickname>%nicknameRE%)
   ;regex=last-updated.*?(second|minute|hour|day|week).*?FOUR STAR CHECKING.*?balance...([0-9,.]+)
   ;TODO don't update the numbers if the last updated date is old

   if NOT RegExMatch(page, regex, match)
      return

   ini=C:\Dropbox\AHKs\gitExempt\mintIDs.ini
   balance := StringReplace(match9, "$")
   balance := StringReplace(balance, ",")
   balance := StringReplace(balance, "–", "-") ;replace the stylish emdash with normal minus
   balance := RegExReplace(balance, oneXML)
   balance := RegExReplace(balance, "[^0-9.]{3}", "-") ;replace the stylish emdash with normal minus

   nickname := IniRead(ini, default, id)
   if NOT RegExMatch(id, "^527155")
      nickname .= "zzz" . id

   ;debug(matchid, nickname, balance)

   NightlyStats(nickname, balance, "noemail")
}
