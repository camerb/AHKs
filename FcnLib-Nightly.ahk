#include FcnLib.ahk

;Function lib for things that are too ghetto to happen during the day

;{{{Basic Functions ( like RunIMacro() )
RuniMacro(script="URL GOTO=nascar.com")
{
   if NOT ProcessExist("firefox.exe")
      RunProgram("Firefox")
   ForceWinFocus("Firefox")
   Sleep, 200
   Send, ^!{NUMPAD4}
   Sleep, 200
   Send, ^!{NUMPAD5}
   Sleep, 200
   WinMove, Firefox, , , , 1766, 1020
   Sleep, 200
   WinMove, Firefox, , , , 1766, 1020
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

GetFirefoxPageSource()
{
   folder=C:\Dropbox\AHKs\gitExempt\
   file=savedPageSource.html
   path=%folder%%file%
   imacro=
   (
   SAVEAS TYPE=CPL FOLDER=%folder% FILE=%file%
   )
   RuniMacro(imacro)
   returned := FileRead(path)
   FileDelete(path)
   return returned
}

;some sites require a /real/ login, so we aren't able to do a
;   simple request. Instead we should use a browser, view source,
;   and copy the source to the clipboard.
;TODO maybe have a browser param to choose which browser you
;   want to use to request the page.
;FIXME doesn't work quite right yet. Sometimes it doesn't copy
GetFirefoxPageSource2()
{
   ;number to verify that the clipboard was never assigned to
   null:=Random(100000,999999)
   Clipboard:=null

   ;opera save page source
   WinGetActiveTitle, oldTitle
   ForceWinFocus("ahk_class Mozilla(UI)?WindowClass", "RegEx")

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
   count=0
   Loop
   {
      count++
      if (Clipboard != null)
         break
      ShortSleep()
   }
   ShortSleep()
   ;Send, ^w
   ;ShortSleep()

   while ForceWinFocusIfExist("Source.* ahk_class Mozilla(UI)?WindowClass", "RegEx")
      WinClose

   return Clipboard
}
;}}}

;{{{ Mint Functions
MintLogIn()
{
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
}

MintGetTransactionCsvs()
{
   imacro=
   (
   VERSION BUILD=7300701 RECORDER=FX
   TAB T=1
   URL GOTO=https://wwws.mint.com/transaction.event
   TAG POS=1 TYPE=A ATTR=TXT:Transactions
   ONDOWNLOAD FOLDER=C:\Dropbox\AHKs\GitExempt\mint_export\ FILE={{!NOW:yyyy-mm-dd}}.csv WAIT=YES
   TAG POS=1 TYPE=A ATTR=ID:transactionExport
   )

   RuniMacro(imacro)
}

MintTouch()
{
   imacro=
   (
   VERSION BUILD=7300701 RECORDER=FX
   TAB T=1
   URL GOTO=https://wwws.mint.com/overview.event
   TAG POS=1 TYPE=A ATTR=ID:module-accounts-update
   )

   RuniMacro(imacro)
}
;}}}


