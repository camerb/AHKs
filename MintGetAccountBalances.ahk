#include FcnLib.ahk

panther:=SexPanther()
imacro=
(
VERSION BUILD=7300701 RECORDER=FX
TAB T=1
URL GOTO=https://wwws.mint.com/login.event?task=L
TAG POS=1 TYPE=INPUT:TEXT FORM=ACTION:loginUserSubmit.xevent ATTR=ID:form-login-username CONTENT=cameronbaustian@gmail.com
SET !ENCRYPTION NO
TAG POS=1 TYPE=INPUT:PASSWORD FORM=ACTION:loginUserSubmit.xevent ATTR=ID:form-login-password CONTENT=%panther%
TAG POS=1 TYPE=LI ATTR=ID:log_in
TAG POS=1 TYPE=INPUT:SUBMIT FORM=ID:form-login ATTR=VALUE:Log<SP>In
TAG POS=1 TYPE=A ATTR=TXT:Transactions
URL GOTO=https://wwws.mint.com/transaction.event
)

RuniMacro(imacro)
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
   balance := StringReplace(balance, "–", "-")
   balance := RegExReplace(balance, oneXML)

   nickname := IniRead(ini, default, id)
   if NOT RegExMatch(id, "^527155")
      nickname .= "zzz" . id

   NightlyStats(nickname, balance)
}

RuniMacro(script="URL GOTO=nascar.com")
{
   if NOT ProcessExist("firefox.exe")
      RunProgram("Firefox")
   ForceWinFocus("Firefox")
   Sleep, 200
   Send, ^!{NUMPAD5}
   Sleep, 200
   WinMove, Firefox, , , , 1766, 1020
   Sleep, 200
   while NOT SimpleImageSearch("images/imacros/imacrosLargeLogo2.bmp")
   {
      ClickIfImageSearch("images/imacros/imacrosIcon.bmp")
      ClickIfImageSearch("images/imacros/imacrosIcon2.bmp")
      Sleep, 500
   }

   Click(89, 680) ;rec tab
   Click(89, 760) ;load button

   file=C:\Dropbox\AHKs\gitExempt\iMacros\ahkScripted.iim
   FileCreate(script, file)

   ForceWinFocus("Select file to load")
   Sleep, 200
   Send, %file%{ENTER}

   Sleep, 200
   ;Click(71, 171) ;click on the file
   Click(100, 500) ;click in the window, then navigate to the file we want to run
   Send, {UP 50}
   sleep, 200
   Send {DOWN}
   sleep, 200
   Send {DOWN}

   Sleep, 200
   Click(46, 673) ;click on play tab

   ;click on the play button and monitor the color
   previousColor:=PixelGetColor(60, 709)
   Sleep, 200
   Click(60, 709)
   MouseMove, 400, 709

   Loop
   {
      currentColor:=PixelGetColor(60, 709)
      if (previousColor == currentColor)
         break
   }

   ;debug("looks like the imacro is done")
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
