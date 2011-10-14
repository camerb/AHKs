#include FcnLib.ahk

;Function lib for things that are too ghetto to happen during the day

;{{{Basic Functions ( like RunIMacro() )
RuniMacro(script="URL GOTO=nascar.com")
{
   startTime := CurrentTime("hyphenated")
   lockfile := GetPath("imacro.lock")
   FileCreate(startTime, lockfile)
   script .= "`n`n`'end of the imacro`nFILEDELETE NAME=" . lockfile

   if NOT ProcessExist("firefox.exe")
      RunProgram("Firefox")
   ForceWinFocus("Firefox")
   Sleep, 200
   WinRestore, Firefox
   ;Send, ^!{NUMPAD4}
   ;Sleep, 200
   ;Send, ^!{NUMPAD5}
   ;Sleep, 200
   ;WinMove, Firefox, , , , 1766, 1020
   ;Sleep, 200
   ;WinMove, Firefox, , , , 1766, 1020
   Sleep, 200
   WinMove, Firefox, , , , 1766, 1020
   Sleep, 200
   while NOT SimpleImageSearch("images/imacros/imacrosLargeLogo2.bmp")
   {
      ClickIfImageSearch("images/imacros/imacrosIcon.bmp")
      ClickIfImageSearch("images/imacros/imacrosIcon2.bmp")
      MouseMove, 0, 0
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

   ;click in the window, then navigate to the file we want to run
   Click(100, 500)
   Send, {UP 50}
   sleep, 200
   Send {DOWN}
   sleep, 200
   Send {DOWN}

   Sleep, 200
   Click(46, 673) ;click on play tab

   ;click on the play button
   Click(60, 709)

   ;wait for the lockfile to disappear, then we'll know that the imacro is done
   WaitFileNotExist(lockfile)
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
