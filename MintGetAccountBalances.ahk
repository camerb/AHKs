#include FcnLib.ahk
#include FcnLib-Nightly.ahk

MintLogIn()
mintPage := GhettoUrlDownloadToVar("https://wwws.mint.com/overview.event")

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
   Clipboard:=regex
   ;regex=last-updated.*?(second|minute|hour|day|week).*?FOUR STAR CHECKING.*?balance...([0-9,.]+)
   ;TODO don't update the numbers if the last updated date is old

   if NOT RegExMatch(page, regex, match)
      return

   ini=C:\Dropbox\AHKs\gitExempt\mintIDs.ini
   balance := StringReplace(match9, "$")
   balance := StringReplace(balance, ",")
   balance := StringReplace(balance, "–", "-") ;replace the stylish emdash with normal minus
   balance := RegExReplace(balance, oneXML)

   nickname := IniRead(ini, default, id)
   if NOT RegExMatch(id, "^527155")
      nickname .= "zzz" . id

   ;debug(matchid, nickname, balance)

   NightlyStats(nickname, balance)
}

;some sites require a /real/ login, so we aren't able to do a
;   simple request. Instead we should use a browser, view source,
;   and copy the source to the clipboard.
;TODO maybe have a browser param to choose which browser you
;   want to use to request the page.
;FIXME doesn't work quite right yet. Sometimes it doesn't copy
GhettoUrlDownloadToVar(url="")
{
   ;number to verify that the clipboard was never assigned to
   null:=Random(100000,999999)
   Clipboard:=null

   ;opera save page source
   WinGetActiveTitle, oldTitle
   ForceWinFocus("ahk_class Mozilla(UI)?WindowClass", "RegEx")

   ;if there was no url provided, that means we wanted the page that is currently open in the browser window
   if (url != "")
   {
      Send, !d
      ShortSleep()
      Send, %url%
      Send, {ENTER}
      ShortSleep()

      WinWaitActiveTitleChange(oldTitle)
   }
   ShortSleep()

   ;Send, {CTRLDOWN}uacw{CTRLUP}

   ;press the button to launch the new window. but sometimes it doesn't pick it up
   Loop
   {
      Send, ^u
      Sleep, 200
      if ForceWinFocusIfExist("Source", "Contains")
         break
      Sleep, 200
   }
   ShortSleep()
   Send, ^a
   Send, ^a
   Send, ^a
   Send, ^a
   ShortSleep()
   Send, ^c
   Send, ^c
   Send, ^c
   Send, ^c
   ;ClipWait, 2
   ;debug("silent log", "just copied to clipboard")
   count=0
   Loop
   {
      count++
      if (Clipboard != null)
      {
         if (count >= 2)
            debug("silent log yellow line", "clipboard is no longer null after # of tries:", count)
         break
      }
      ShortSleep()
   }
   ShortSleep()
   Send, ^w
   ShortSleep()

   if (Clipboard == null)
   {
      debug("silent log", "candidate for deletion", "the clipboard should have a value by now")
      ;errord("silent", "clipboard never got any new contents")
      ;die("unable to get past alternative login screen", A_ScriptName, A_LineNumber, A_ThisFunc)
      return "empty"
   }

   return Clipboard
}

ShortSleep()
{
   Sleep, 100
}
