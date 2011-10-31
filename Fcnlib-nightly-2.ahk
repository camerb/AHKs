#include FcnLib.ahk

;NOTE: this was my attempt at trying to make the imacros lib work for several versions of firefox (this attempt mostly failed)

;Function lib for things that are too ghetto to happen during the day

RuniMacro(script="URL GOTO=nascar.com", options="")
{
   SetTitleMatchMode, RegEx
   ;vars we'll use later
   firefoxWindow=Mozilla Firefox ahk_class Mozilla(UI)?WindowClass
   ;iMacroFile=%A_MyDocuments%\iMacros\Macros\ahkScripted.iim
   iMacroFile=C:\WINDOWS\Temp\iMacros\ahkScripted.iim

   ;make the lockfile
   startTime := CurrentTime("hyphenated")
   lockfile := GetPath("imacro.lock")
   FileCreate(startTime, lockfile)

   ;tweak the script so that is will cooperate/communicate with AHK
   script=
   (
   TAB CLOSEALLOTHERS
   'TAB CLOSE
   'TAB T=1
   %script%
   FILEDELETE NAME=%lockfile%
   )
   FileCreate(script, iMacroFile)

   ;figure out where the firefox install is
   ffList:="C:\Program Files\Mozilla Firefox 4.0 Beta 4\firefox.exe,C:\Program Files\Mozilla Firefox\firefox.exe,C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
   ;ffList:="C:\Dropbox\Programs\FirefoxPortable\FirefoxPortable.exe,C:\Program Files\Mozilla Firefox 4.0 Beta 4\firefox.exe,C:\Program Files\Mozilla Firefox\firefox.exe,C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
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

   ;are we using the portable version?
   if InStr(firefoxPath, "FirefoxPortable")
      usingPortableVersion:=true

   ;if usingPortableVersion
   ;{
      ;;ProcessCloseAll("firefox.exe")
      ;NOTE the issue here is that sometimes FirefoxPortable runs with the process name "firefox.exe" and sometimes it is "FirefoxPortable.exe"
      ;if NOT ProcessExist("FirefoxPortable.exe")
         ;Run,  "%firefoxPath%"
   ;}
   ;else
   ;{
      if NOT ( ProcessExist("firefox.exe") OR ProcessExist("FirefoxPortable.exe") )
         Run,  "%firefoxPath%"
   ;}

   ;show the window in the correct location
   ForceWinFocus(firefoxWindow)
   Sleep, 200
   WinRestore, %firefoxWindow%
   Sleep, 200
   WinRestore, %firefoxWindow%
   Sleep, 200
   WinMove, %firefoxWindow%, , 0, 0, 1766, 924

   ;FIXME something in here always makes it create a new firefox window on the home pc... why is that?

   ;run the iMacro
   Run,  "%firefoxPath%" http://run.imacros.net/?m=ahkScripted.iim

   ;wait for the lockfile to disappear, then we'll know that the imacro is done
   WaitFileNotExist(lockfile)

   ;close the iMacros panel
   ToggleIMacrosPanel()
   FileCreate("'this is where imacros are saved temporarily", iMacroFile)
   Sleep, 5000
}

