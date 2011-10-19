#include FcnLib.ahk

;Function lib for things that are too ghetto to happen during the day

;{{{Basic Functions ( like RunIMacro() )

;TODO turn this into something that is suitable to post as a lib
;TODO needs better paths
;TODO needs to depend on fewer libs
;TODO error message is imacros is not installed
;TODO error message if firefox is not installed
RuniMacro(script="URL GOTO=nascar.com")
{
   startTime := CurrentTime("hyphenated")
   lockfile := GetPath("imacro.lock")
   FileCreate(startTime, lockfile)
   script=
   (
   TAB CLOSE
   %script%
   FILEDELETE NAME=%lockfile%
   )

   if NOT ProcessExist("firefox.exe")
      RunProgram("Firefox")
   ForceWinFocus("Firefox")
   Sleep, 200
   WinRestore, Firefox
   Sleep, 200
   WinRestore, Firefox
   Sleep, 200
   WinMove, Firefox, , 0, 0, 1766, 924

   iMacroFile=%A_MyDocuments%\iMacros\Macros\ahkScripted.iim
   FileCreate(script, iMacroFile)
   ;FIXME something in here always makes it create a new firefox window on the home pc... why is that?

   ff1:="C:\Program Files\Mozilla Firefox\firefox.exe"
   ff2:="C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
   ff3:="C:\Program Files\Mozilla Firefox 4.0 Beta 4\firefox.exe"

   if FileExist(ff1)
      firefoxPath:=ff1
   else if FileExist(ff2)
      firefoxPath:=ff2
   else if FileExist(ff3)
      firefoxPath:=ff3
   else
      errord("", "cannot find path for firefox", A_LineNumber, A_ThisFunc, A_ScriptName)

   Run,  "%firefoxPath%" http://run.imacros.net/?m=ahkScripted.iim

   ;wait for the lockfile to disappear, then we'll know that the imacro is done
   WaitFileNotExist(lockfile)

   ;close the iMacros panel
   ToggleIMacrosPanel()
   FileDelete(iMacroFile)
}

iMacroUrlDownloadToVar(url="")
{
   if (url != "")
      GoToUrlCommand=URL GOTO=%url%

   folder=C:\Dropbox\AHKs\gitExempt\
   file=savedPageSource.html
   path=%folder%%file%
   imacro=
   (
   %GoToUrlCommand%
   SAVEAS TYPE=HTM FOLDER=%folder% FILE=%file%
   )
   RuniMacro(imacro)
   returned := FileRead(path)
   FileDelete(path)
   return returned
}

OpenIMacrosPanel()
{
   ForceWinFocus("Firefox")
   while NOT SimpleImageSearch("images/imacros/imacrosLargeLogo2.bmp")
   {
      ClickIfImageSearch("images/imacros/imacrosIcon.bmp")
      ClickIfImageSearch("images/imacros/imacrosIcon2.bmp")
      MouseMoveRandom() ;, 0, 0
      Sleep, 500
   }
}

CloseIMacrosPanel()
{
   ForceWinFocus("Firefox")
   OpenIMacrosPanel()
   ClickIfImageSearch("images/imacros/imacrosIcon.bmp")
   ClickIfImageSearch("images/imacros/imacrosIcon2.bmp")
}

ToggleIMacrosPanel()
{
   ControlSend, , {F8}, Mozilla Firefox
}
;}}}

;{{{ Mint Functions
MintLogIn()
{
   panther:=SexPanther()
   imacro=
   (
   VERSION BUILD=7300701 RECORDER=FX
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
   URL GOTO=https://wwws.mint.com/overview.event
   TAG POS=1 TYPE=A ATTR=ID:module-accounts-update
   )

   RuniMacro(imacro)
}
;}}}
