#include FcnLib.ahk

;Function lib for things that are too ghetto to happen during the day

;{{{Basic Functions ( like RunIMacro() )

;TODO turn this into something that is suitable to post as a lib
;TODO needs better paths
;TODO needs to depend on fewer libs
;TODO error message is imacros is not installed
;TODO error message if firefox is not installed
;TODO add in a "hide" option that will winhide the window
;TODO needs unit tests
RuniMacro(script="URL GOTO=nascar.com", options="")
{
   ;vars we'll use later
   firefoxWindow=Mozilla Firefox ahk_class Mozilla(UI)?WindowClass

   ;make the lockfile
   startTime := CurrentTime("hyphenated")
   lockfile := GetPath("imacro.lock")
   FileCreate(startTime, lockfile)

   ;tweak the script so that is will cooperate/communicate with AHK
   iMacroFile=%A_MyDocuments%\iMacros\Macros\ahkScripted.iim
   /*
   TAB CLOSEALLOTHERS
   TAB CLOSE
   TAB T=1
   */
   script=
   (
   TAB CLOSE
   %script%
   FILEDELETE NAME=%lockfile%
   )

   ;figure out where the firefox install is
   ;ffList:="C:\Program Files\Mozilla Firefox 4.0 Beta 4\firefox.exe,C:\Program Files\Mozilla Firefox\firefox.exe,C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
   ;ffList:="C:\Dropbox\Programs\FirefoxPortable\FirefoxPortable.exe,C:\Program Files\Mozilla Firefox 4.0 Beta 4\firefox.exe,C:\Program Files\Mozilla Firefox\firefox.exe,C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
   ffList:="C:\Program Files\Mozilla Firefox\firefox.exe,C:\Program Files (x86)\Mozilla Firefox\firefox.exe,C:\Dropbox\Programs\FirefoxPortable\FirefoxPortable.exe,C:\Program Files\Mozilla Firefox 4.0 Beta 4\firefox.exe"
   Loop, parse, ffList, CSV
   {
      if FileExist(A_LoopField)
      {
         firefoxPath:=A_LoopField
         break
      }
   }

   ;error out if there were issues finding the FF path
   if NOT firefoxPath
      errord("", "cannot find path for firefox", A_LineNumber, A_ThisFunc, A_ScriptName)

   ;get firefox version
   firefoxVersion:=GetFirefoxVersion(firefoxPath)

   ;are we using the portable version?
   ;TODO ugh... the portable version causes so many problems
   if InStr(firefoxPath, "FirefoxPortable")
      usingPortableVersion:=true

   if usingPortableVersion
      iMacroFile=C:\WINDOWS\Temp\iMacros\ahkScripted.iim
   else
      iMacroFile=%A_MyDocuments%\iMacros\Macros\ahkScripted.iim

   FileCreate(script, iMacroFile)
   Sleep, 1000

   ;if usingPortableVersion
   ;{
      ;ProcessCloseAll("firefox.exe")
      ;if NOT ProcessExist("FirefoxPortable.exe")
         ;Run,  "%firefoxPath%"
   ;}
   ;else
   ;{
      if NOT ProcessExist("firefox.exe")
         Run,  "%firefoxPath%"
         ;RunProgram("Firefox")
   ;}

   ;show the window in the correct location
   ForceWinFocus(firefoxWindow)
   Sleep, 1000
   ;WinMove, %firefoxWindow%, , 0, 0, 1766, 924

   ;FIXME something in here always makes it create a new firefox window on the home pc... why is that?

   ;run the iMacro
   Run,  "%firefoxPath%" http://run.imacros.net/?m=ahkScripted.iim

   ;wait for the lockfile to disappear, then we'll know that the imacro is done
   WaitFileNotExist(lockfile)

   ;close the iMacros panel
   ;ToggleIMacrosPanel()
   FileCreate("'this is where imacros are saved temporarily", iMacroFile)
   Sleep, 1000

   ;Run this junk on the home PC, cause it's running cruddy old Firefox 3.6.24
   if (ConvertVersionNumToInt(FirefoxVersion) < 5)
   {
      ForceWinFocus("Mozilla Firefox", "Exact")
      WinClose("Mozilla Firefox", "Exact")
      Sleep, 200
   }

   if ClickIfImageSearch("images/iMacros/iMacrosLargeLogo2.bmp")
   {
      ;TODO shouldn't I move this down below the if?
      ToggleIMacrosPanel()
   }
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

;I'm thinking this should generally be discouraged (the hotkey is configurable)
ToggleIMacrosPanel()
{
   Sleep, 2000
   ControlSend, , {F8}, Mozilla Firefox
   ;Send, {F8}
   Sleep, 2000
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
