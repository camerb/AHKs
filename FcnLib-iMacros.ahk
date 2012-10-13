#include FcnLib.ahk

;Generally you don't want this to run in the middle of the day... only at night

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
   iMacroFile=%A_MyDocuments%\iMacros\Macros\ahkScripted.iim
   lockfile=%A_Temp%\iMacro.lock
   ;lockfile := GetPath("imacro.lock") ;TODO FIXME this path is in

   ;make the lockfile
   startTime := CurrentTime("hyphenated")
   FileCreate(startTime, lockfile)

   ;tweak the script so that it will cooperate/communicate with AHK
   /*
   TAB CLOSEALLOTHERS
   TAB CLOSE
   TAB T=1
   */

   /*
   TAB CLOSEALLOTHERS
   TAB OPEN
   TAB T=2
   */
   script=
   (
   TAB CLOSEALLOTHERS
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

   ;debug(firefoxPath)
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

   ;TODO trying to make a "hidden" option, but I don't think it will work
   ;try to hide the window while stuff is happening
   ;Sleep, 1000
   ;debug()
   ;CustomTitleMatchMode("Contains")
   ;WinMinimize, Lynx Menu
   ;WinClose, Lynx Menu
   ;WinHide, Lynx Menu
   ;WinMinimize, Lynx Menu - Mozilla Firefox
   ;WinClose, Lynx Menu - Mozilla Firefox
   ;WinHide, Lynx Menu - Mozilla Firefox
   ;WinClose, Lynx Menu - Mozilla Firefox
   ;IfWinExist, Lynx Menu - Mozilla Firefox
      ;debug(wingetactivetitle())
   ;IfWinExist, ahk_class Edit
      ;debug(wingetactivetitle())

   ;WinWait, ahk_class Edit, , 10
   ;el := ERRORLEVEL
   ;debug("WinWait just happened, and here is the errorlevel (to show if it found the right window)", el)
   ;WinClose, ahk_class Edit

   ;wait for the lockfile to disappear, then we'll know that the imacro is done
   WaitFileNotExist(lockfile)

   FileCreate("'this is where imacros are saved temporarily", iMacroFile)
   Sleep, 1000

   ;ConvertVersionNumToInt(FirefoxVersion)
   ;debug(firefoxversion)

   ;Run this junk on the home PC, cause it's running cruddy old Firefox 3.6.24
   if (ConvertVersionNumToInt(FirefoxVersion) < 5)
   {
      ForceWinFocus("Mozilla Firefox", "Exact")
      WinClose("Mozilla Firefox", "Exact")
      Sleep, 200
   }

   ;close the iMacros panel, if not already done
   if ClickIfImageSearch("images/iMacros/iMacrosLargeLogo2.bmp")
      ToggleIMacrosPanel()
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

