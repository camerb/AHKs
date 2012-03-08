#Persistent
SetTimer, Persist, 500
return

Persist:
SetTitleMatchMode, 1


;{{{ temporary things (processes to kill)
;if (A_ComputerName = "PHOSPHORUS")
   ;ProcessClose("pidgin.exe")
;}}}

;{{{debugging how long it takes for an iteration through the #Persistent stuff
;if NOT timer
;{
   ;AddToTrace("restarted script", A_ScriptName, "grey line")
   ;maxTotalTime := 0
   ;timer:=starttimer()
;}
;totaltime:=elapsedtime(timer)
;if (totalTime > maxTotalTime)
;{
   ;maxTotalTime := totalTime
   ;addtotrace("Max time it took for one iteration:", maxTotalTime, CurrentTime("hyphenated"), A_ComputerName)
;}
;timer:=starttimer()
;}}}

;{{{Middle of the night unit tests, backups, and reload script
if (A_Hour==3 AND A_Min==2)
{
   SpiffyMute()

   debug("reloading script")
   SleepSeconds(10)

   ;let's try for something that is a bit stiffer
   ;Run, ForceReloadAll.exe

   ;lets close all ahks as gently as possible
   CloseAllAhks()
}
if (A_Hour==3 AND A_Min==5)
{
   RunAhk("NightlyAhks.ahk")
   SleepMinutes(2)
}
;}}}

;{{{Send Jira Status Workmorrow for the Tea Meeting Minutes
;if (A_ComputerName="PHOSPHORUS")
;{
;   if A_WDay BETWEEN 2 AND 6
;   {
;      if (A_Hour=13 AND A_Min=30 AND A_Sec=0)
;      {
;         RunAhk("JiraWorkmorrow.ahk", "reminder")
;         SleepSeconds(2)
;      }
;      if (A_Hour=14 AND A_Min=0 AND A_Sec=0)
;      {
;         RunAhk("JiraWorkmorrow.ahk")
;         SleepSeconds(2)
;      }
;   }
;}
;}}}

;{{{Send Morning AHK Status Briefing
if (A_Hour=6 AND A_Min=0 AND A_Sec=0)
{
   if ( A_ComputerName == LeadComputer() )
   {
      RunAhk("MorningStatus.ahk", "SendMessage")
      SleepSeconds(2)
   }
}
;}}}

;{{{Try refreshing mint each hour on vm
if (A_Min=15 AND A_Sec=0 AND A_Hour<>3 AND A_Hour<>4)
{
   if (A_ComputerName="PHOSPHORUSVM")
   {
      RunAhkAndBabysit("MintTouch.ahk")
      SleepSeconds(2)
   }
}
;}}}

;{{{Download carset for nr2003 just before the race
if (A_WDay=5 AND A_Hour=18 AND A_Min=0 AND A_Sec=0)
{
   if (A_ComputerName="BAUSTIAN-09PC")
   {
      RunAhkAndBabysit("SaveNR2003cars.ahk")
      SleepSeconds(2)
   }
}
;}}}

;{{{Routine email reminders
if (A_Hour=11 AND A_Min=05 AND A_Sec=0)
{
   if (A_ComputerName="PHOSPHORUS")
      if A_WDay BETWEEN 2 AND 6
      {
         ThreadedMsgbox("Time for lunch")
         SleepSeconds(2)
      }
}

if (A_Hour=11 AND A_Min=15 AND A_Sec=0)
{
   if (A_ComputerName="PHOSPHORUS")
      if A_WDay BETWEEN 2 AND 6
      {
         ThreadedMsgbox("Really now, it is time for lunch!")
         SleepSeconds(2)
      }
}

if (A_Hour=08 AND A_Min=01)
{
   if (A_ComputerName="PHOSPHORUS")
      RunAhk("EpmsTimecardReminder.ahk")
}
if (A_Hour=10 AND A_Min=01)
{
   if (A_ComputerName="PHOSPHORUS")
      RunAhk("EpmsTimecardReminder.ahk")
}

if (A_Hour=12 AND A_Min=0 AND A_Sec=0)
{
   if (A_ComputerName="PHOSPHORUS")
   {
      sendEmail("Read yer Bible", "Message sent by bot", "", "melindabaustian@gmail.com")
      SleepSeconds(2)
   }
}

if (A_Hour=15 AND A_Min=15 AND A_Sec=0)
{
   if (A_ComputerName="PHOSPHORUS")
      if A_WDay BETWEEN 2 AND 6
      {
         sendEmail("Snacktime", "Message sent by bot")
         SleepSeconds(2)
      }
}

;if (A_Hour=13 AND A_Min=30 AND A_Sec=0)
;{
;   if (A_ComputerName="PHOSPHORUS")
;      if A_WDay BETWEEN 2 AND 6
;         sendEmail("Update your jira tasks (completed and workmorrow)", "http://jira.mitsi.com`n`nMessage sent by bot")
;}

;if (A_WDay=5 AND A_Hour=10 AND A_Min=22 AND A_Sec=0)
;{
   ;if (A_ComputerName="PHOSPHORUS")
      ;sendEmail("Fantasy Nascar", "http://fantasygames.nascar.com/streak`n`nMake your fantasy picks", "", "cameronbaustian@gmail.com;melindabaustian@gmail.com")
;}

if (A_WDay=5 AND A_Hour=10 AND A_Min=0 AND A_Sec=0)
{
   if (A_ComputerName="PHOSPHORUS")
      sendEmail("Check if Melinda is coming to lunch", "Message sent by bot")
}

if (A_WDay=6 AND A_Hour=10 AND A_Min=0 AND A_Sec=0)
{
   if (A_ComputerName="PHOSPHORUS")
      sendEmail("Mitsi Donut Day", "Message sent by bot")
}

if (A_DD=17 A_Hour=7 AND A_Min=59 AND A_Sec=0)
{
   if (A_ComputerName="PHOSPHORUS")
   {
      sendEmail("Bill reminder", "Cameron Mastercard`n`nMessage sent by bot")
      SleepSeconds(2)
   }
}
if (A_DD=07 A_Hour=7 AND A_Min=59 AND A_Sec=0)
{
   if (A_ComputerName="PHOSPHORUS")
   {
      sendEmail("Bill reminder", "Melinda Mastercard`n`nMessage sent by bot")
      SleepSeconds(2)
   }
}
if (A_DD=08 A_Hour=7 AND A_Min=59 AND A_Sec=0)
{
   if (A_ComputerName="PHOSPHORUS")
   {
      sendEmail("Bill reminder", "Time Warner Cable`n`nMessage sent by bot")
      SleepSeconds(2)
   }
}
if (A_DD=11 A_Hour=7 AND A_Min=59 AND A_Sec=0)
{
   if (A_ComputerName="PHOSPHORUS")
   {
      sendEmail("Bill reminder", "City of Garland Electric`n`nMessage sent by bot")
      SleepSeconds(2)
   }
}
if (A_DD=25 A_Hour=7 AND A_Min=59 AND A_Sec=0)
{
   if (A_ComputerName="PHOSPHORUS")
   {
      sendEmail("Bill reminder", "Chase Freedom Credit (Routine Bills Card)`n`nMessage sent by bot")
      SleepSeconds(2)
   }
}
;}}}

;{{{Check weather and put it on the remote widget
if (Mod(A_Min, 15)==0 && A_Sec==0)
{
   if (A_ComputerName="PHOSPHORUS")
   {
      Run, UpdateRemoteWidget.ahk
      sleepseconds(2)
   }
}
;}}}

;{{{Monitor FF4 RAM usage
if (Mod(A_Min, 15)==0 && A_Sec==35)
{
   if (A_ComputerName="PHOSPHORUS")
   {
      time:=currenttime("hyphenated")
      pid:=getpid("firefox.exe")
      ram:=GetRamUsage(pid)
      cpu:=GetCpuUsage(pid)
      csvLine := ConcatWithSep(",", time, pid, ram, cpu)
      FileAppendLine(csvLine, "gitExempt/phosFFstats.csv")
      sleepseconds(2)
   }
}
;}}}

;{{{Check to see if we scheduled an ahk from the cloud
if (Mod(A_Sec, 5)==0)
{
   if (A_ComputerName="BAUSTIAN-09PC")
   {
      ghetto:=SexPanther()
      BotGmailUrl=https://cameronbaustianbot:%ghetto%@gmail.google.com/gmail/feed/atom

      gmailPage:=urldownloadtovar(BotGmailUrl)
      RegExMatch(gmailPage, "<fullcount>(\d+)</fullcount>", gmailPage)
      RegExMatch(gmailPage, "\d+", number)

      if (number == 0 || number == "")
         number:=""

      if (number)
      {
         RunAhkAndBabysit("ProcessBotEmails.ahk")
         SleepSeconds(20)
         ;maybe we should sleep more like 60 secs
      }
   }
}
;}}}

;{{{Run scheduled AHKs
if (Mod(A_Sec, 2)==0)
{
   asapAhk=%A_WorkingDir%\scheduled\%A_ComputerName%\asap.ahk
   asapTxt=%A_WorkingDir%\scheduled\%A_ComputerName%\asap.txt
   lock=%A_WorkingDir%\scheduled\%A_ComputerName%\InProgress.lock
   deleteLock=%A_WorkingDir%\scheduled\%A_ComputerName%\DeleteLock.now

   bothAsaps=%asapAhk%,%asapTxt%
   Loop, parse, bothAsaps, CSV
   {
      if FileExist(A_LoopField)
      {
         time:=CurrentTime("hyphenated")
         newFileName=%A_WorkingDir%\scheduled\%A_ComputerName%\%time%.ahk
         FileMove(A_LoopField, newFileName)
      }
   }


   if FileExist(deletelock)
   {
      FileDelete(lock)
      FileDelete(deletelock)
   }

   if NOT FileExist(lock)
   {
      ;check if time to run an ahk
      asapAhk=%A_WorkingDir%\scheduled\%A_ComputerName%\asap.ahk
      asapTxt=%A_WorkingDir%\scheduled\%A_ComputerName%\asap.txt
      if FileExist(asapTxt)
         FileMove(asapTxt, asapAhk, "overwrite")

      ;TODO put all this crap into another ahk, so that persistent doesn't halt while we're babysitting other ahks
      Loop, %A_WorkingDir%\scheduled\%A_ComputerName%\*.ahk
      {
         filedate := A_LoopFileName
         filedate := RegExReplace(filedate, "\.ahk$")
         filedate := DeformatTime(filedate)

         ;check to make sure filedate is a number and is 14 long
         if ( strlen(filedate) != 14 )
            continue
         if NOT filedate is integer
            continue
         if NOT CurrentlyAfter(filedate)
            continue

         ;debug(filedate)

         compilingPath=%A_WorkingDir%\scheduled\%A_ComputerName%\Compiling\%A_LoopFileName%
         errorsPath   =%A_WorkingDir%\scheduled\%A_ComputerName%\Errors\%A_LoopFileName%
         runningPath  =%A_WorkingDir%\scheduled\%A_ComputerName%\Running\%A_LoopFileName%
         finishedPath =%A_WorkingDir%\scheduled\%A_ComputerName%\Finished\%A_LoopFileName%

         ;debug(compilingPath)
         FileMove(A_LoopFileFullPath, compilingPath)
         FileAppend("`n#include FcnLib.ahk", compilingPath)

         ;TODO write a testCompile function
         ;if errorsCompiling
         ;{
            ;FileMove(A_LoopFileFullPath, errorsPath)
            ;continue
         ;}

         ;Prep for run (tell him that after he's done running, he's got to move himself to the finished folder)
         FileMove(compilingPath, runningPath)
         lastLine=`nFileMove("%runningPath%", "%finishedPath%")
         FileAppend(lastLine, runningPath)

         ;Run that sucka!
         RunAhk(runningPath)
      }
   }
}
;}}}

;{{{ Close unwanted windows, new ways, but not one-liners
if ForceWinFocusIfExist("Microsoft Windows")
{
   if SimpleImageSearch("images/win7/doYouWantToScanAndFixFlashDrive.bmp")
      ClickIfImageSearch("images/win7/continueWithoutScanning.bmp", "control")
}
;}}}

;{{{ new ways to close unwanted windows

;note that this is the body of the traytip, not the title
CloseTrayTip("Automatic Updates is turned off")
CloseTrayTip("A new version of Java is ready to be installed.")
CloseTrayTip("There are unused icons on your desktop")
CloseTrayTip("Click here to have Windows automatically keep your computer")

if ForceWinFocusIfExist("Microsoft SQL Server Management Studio Recovered Files")
   ClickButton("&Do Not Recover")
;}}}

;{{{ Miscellaneous stuff, done the new way
if (Mod(A_Sec, 5)==0)
{
   CustomTitleMatchMode("Contains")
   IfWinActive, Gmail
   {
      ClickIfImageSearch("images\gmail\ReconnectWidget7.bmp",  "Control")
      ClickIfImageSearch("images\gmail\ReconnectWidgetXP.bmp", "Control")
      ;ClickIfImageSearch("images\gmail\ReconnectWidgetXP2.bmp", "Control")
   }
   CustomTitleMatchMode("Default")
}
;}}}

;{{{ move network usage notification to a less annoying spot
thewintitle=NetWorx Notification ahk_class TTimedMessageForm
IfWinExist, %thewintitle%
{
   WinMove, 3564, 0
}
thewintitle=NetWorx (All Connections) ahk_class TGraphForm
IfWinExist, %thewintitle%
{
   WinMove, 3689, 960
}
;}}}

;{{{ kill processes that are of the devil
Process, Close, newreleaseversion70700.exe
Process, Close, DivXUpdate.exe
;}}}

;{{{ Old legacy stuff for closing unwanted windows
;N64 emulator error
WinClose, Access Violation, While processing graphics data an exception occurred

SetTitleMatchMode 2

;Descriptive messages (most of these are error messages)
WinClose, Error, An instance of Pidgin is already running
WinClose, WinSplit message, Impossible to install hooks
WinClose, VMware Player, The virtual machine is busy
WinClose, VMware Player, internal error
WinClose, Google Chrome, The program can't start because nspr4.dll is missing from your computer
WinClose, Search and Replace, Error opening

IfWinExist, TGitCache, error
   if ForceWinFocusIfExist("TGitCache")
      Send, !x

;tortoisegit crashed
IfWinExist, TortoiseGit status cache
{
   WinActivate
   Sleep, 10
   Send, {ENTER}
   Sleep, 500
}

IfWinExist, Find and Run Robot ahk_class TMessageForm, OK
{
   WinActivate
   SaveScreenshot("FARR-MessageThatWeClosed")
   Sleep, 10
   Send, {ENTER}
   Sleep, 500
}

;This is for foobar at work
;IfWinExist, Playback error
   ;WinClose

IfWinActive, Disconnect Terminal Services Session ahk_class #32770
{
   ;Disconnect RDP automatically
   Send, {ENTER}

   ;Kill Astaro if we just disconnected from RDP on the VPN
   Process, Close, openvpn-gui.exe
}

IfWinActive, , This will disconnect your Remote Desktop Services session
   Send, {ENTER}

;IfWinActive, Remote Desktop Connection, Do you want to connect despite these certificate errors?
   ;Send, !y
IfWinExist, Remote Desktop Connection, Do you want to connect despite these certificate errors?
{
   WinActivate
   Sleep, 100
   Send, !y
}

;FF4 has fewer prompts now
;IfWinExist, Firefox Add-on Updates ahk_class MozillaDialogClass
;{
   ;;ForceWinFocus("Firefox Add-on Updates ahk_class MozillaDialogClass")
   ;;Sleep, 10
   ;;SendInput, !i

   ;;FIXME this should work!!!
   ;ControlSend, MozillaWindowClass1, !i, Firefox Add-on Updates ahk_class MozillaDialogClass
   ;Sleep, 100
   ;errord("nolog", "just attempted to prod along firefox update window: did it work?", A_LineNumber, A_ScriptName)
   ;SleepSeconds(60)
;}

IfWinExist, Connection to server argon.lan.mitsi.com lost. ahk_class #32770, Close server browser? If you abort, the object browser will not show accurate data.
   ControlClick, &Yes

IfWinExist, Security Warning ahk_class #32770, Do you want to view only the webpage content that was delivered securely?
   ControlClick, &No

IfWinExist, EF Commander Free, Do you want to quit the Commander
   ControlClick, &Yes

CustomTitleMatchMode("Contains")
WinClose, pgAdmin III ahk_class #32770, server closed the connection unexpectedly
CustomTitleMatchMode("Default")
   ;ControlClick, OK

;This is for accidentally opened .js files
WinClose, Windows Script Host, 'Ext' is undefined

;Come on, i already know my Win XP isn't pirated
WinClose, Windows Genuine Advantage Notifications - Installation Wizard

;Close error that sometimes comes up from Adobe Acrobat
WinClose, Fatal Error, Acrobat failed to connect to a DDE server.

;Temporary solution, close the pestering dialog since i'm using the trial
IfWinActive, Balsamiq Mockups For Desktop - * New Mockup ahk_class ApolloRuntimeContentWindow
   ClickIfImageSearch("images\balsamiq\TrialDialog.bmp")

;Annoying Popups
titleofwin = Popular ScreenSavers!!
SetTitleMatchMode 2
IfWinExist, %titleofwin%
   WinClose

;Pesky pop up for netflix... but don't close the main site!
;WinClose, Netflix - Google Chrome
;check window dimensions
;>>>>>>>>>>( Window Title & Class )<<<<<<<<<<<
;Netflix - Google Chrome
;ahk_class Chrome_WidgetWin_0

;>>>>>>>>>>>>( Mouse Position )<<<<<<<<<<<<<
;On Screen:	641, 429  (less often used)
;In Active Window:	161, 54

;>>>>>>>>>( Now Under Mouse Cursor )<<<<<<<<
;ClassNN:	Chrome_RenderWidgetHostHWND1
;Text:	Netflix
;Color:	0xE7DFE7  (Blue=E7 Green=DF Red=E7)

;>>>>>>>>>>( Active Window Position )<<<<<<<<<<
;left: 480     top: 375     width: 730     height: 355

;>>>>>>>>>>>( Status Bar Text )<<<<<<<<<<

;>>>>>>>>>>>( Visible Window Text )<<<<<<<<<<<
;Netflix
;Netflix

;>>>>>>>>>>>( Hidden Window Text )<<<<<<<<<<<

;>>>>( TitleMatchMode=slow Visible Text )<<<<
;http://cdn.optmd.com/V2/62428/196130/index.html?g=Af////8=&r=www.foodnetwork.com/recipes/rachael-ray/halibut-fish-tacos-with-guacamole-sauce-recipe/index.html

;>>>>( TitleMatchMode=slow Hidden Text )<<<<

;}}}

;{{{ Close windows that have been open for a while (they are "abandoned")
;dangit... this isn't used anymore since we switched to Git
;TODO perhaps this approach can be used for telling last.fm to resume listening
SetTitleMatchMode, RegEx
IfWinExist .* - (Update|Commit) - TortoiseSVN Finished! ahk_class #32770
{
   if (TimeToExitWindow=="")
   {
      ;the window just showed up
      WinGet, windowHwndId, ID
      TimeToExitWindow:=CurrentTimePlus(60)
   }
   else if (CurrentlyAfter(TimeToExitWindow))
   {
      ;we are now going to close the window and reset vars
      WinClose, ahk_id %windowHwndId%
      TimeToExitWindow:=""
   }
}
;}}}

;{{{ Watch for error messages from AHKs with syntax errors (and log them)
IfWinExist, %filename%, (The program will exit|The previous version will remain in effect)
{
   textFromTheWindow := WinGetText()
   ControlClick, OK, %filename%
   errord("silent yellow line", A_ThisFunc, filename, "AHK file had an error...", textFromTheWindow, "... end of error msg")
   ;return "error"
}
;}}}

;{{{ Keep Last.fm music running
if (Mod(A_Sec, 30)==0)
{
   lastFmWindow=Last.fm - Opera ahk_class OperaWindowClass

   CustomTitleMatchMode("RegEx")
   DetectHiddenWindows, On

   IfWinExist, %lastFmWindow%
   {
      ;now := CurrentTime()
      ;futureTimeCheckLastFmWindow := AddDatetime(now, 1, "minutes")
      titletext := WinGetTitle(lastFmWindow)

      if (OldTitleTextFromLastFmWindow == titleText)
      {
         if CurrentlyAfter(futureTimeCheckLastFmWindow)
         {
            ;refresh lastfm window
            ;WinShow, %lastFmWindow%
            RunAhk("PlayPauseMusic.ahk", "resumeLastFm")
            now := CurrentTime()
            futureTimeCheckLastFmWindow := AddDatetime(now, 8, "minutes")
            ;WinHide, %lastFmWindow%
         }
      }
      else
      {
         ;debug("new track")
         OldTitleTextFromLastFmWindow:=titleText
         now := CurrentTime()
         futureTimeCheckLastFmWindow := AddDatetime(now, 8, "minutes")
      }
   }
   else
   {
      OldTitleTextFromLastFmWindow:=""
      futureTimeCheckLastFmWindow:=""
   }
}

DetectHiddenWindows, Off
CustomTitleMatchMode("Default")
;}}}

;{{{ Check to see if there are files that need to be out of the dropbox (transferTo)
;TODO put all this crap into another ahk, so that persistent doesn't halt while we're babysitting other ahks
Loop, C:\My Dropbox\AHKs\gitExempt\transferTo\%A_ComputerName%\*.*, 2, 0
{
   localPath=C:\DataExchange\ReceivedFrom
   Sleep, 100
   iniFile = %A_LoopFileFullPath%.ini
   IniRead, DirSize, %iniFile%, TransferTo-Info, DirSize
   IniRead, DirName, %iniFile%, TransferTo-Info, DirName
   IniRead, FromComputer, %iniFile%, TransferTo-Info, FromComputer
   IniRead, DateStamp, %iniFile%, TransferTo-Info, DateStamp
   ;debug("hi dirsize", dirsize)
   if (DirSize == "ERROR")
   {
      ;errord("The INI did not contain the required values")
      ;ExitApp
      continue
   }

   if ( DirSize <> DirGetSize(A_LoopFileFullPath) )
   {
      ;errord("The folder was not the same size as specified in the ini")
      ;ExitApp
      continue
   }
   DestinationFolder = %LocalPath%\%FromComputer%\%DateStamp%\
   DestinationFolder .= GetFolderName(DirName)
   FileCreateDir, %DestinationFolder%
   FileCopyDir, %A_LoopFileFullPath%, %DestinationFolder%, 1
   ;debug(A_LoopFileFullPath, DestinationFolder)
   if ( DirSize <> DirGetSize(DestinationFolder) )
   {
      errord("there must have been an error during the copy, dir size is incorrect")
      ExitApp
   }
   FileRemoveDir, %A_LoopFileFullPath%, 1
   FileDelete, %iniFile%
   Sleep, 5000
}
;}}}

;{{{ Ensure VM firefly bot is running, and not crashed
if (A_ComputerName = "BAUSTIANVM" and Mod(A_Sec, 5)==0)
{
   ;checkin
   FireflyCheckin("Babysitter", "Watching")

   if NOT IsAhkCurrentlyRunning("FireflyFeesBot")
   {
      RunAhk("C:\Dropbox\AHKs\FireflyFeesBot.ahk")
      SleepSeconds(5)
   }
   if NOT IsAhkCurrentlyRunning("FireflyBotHelper")
   {
      RunAhk("C:\Dropbox\AHKs\FireflyBotHelper.ahk")
      SleepSeconds(5)
   }

   ;if bot or helper haven't said hi within a certain period of time, kill them and restart them
   VerifyFireflyCheckin("Bot")
   VerifyFireflyCheckin("Helper")
   Sleep, 1200
}

;getting some info about the AHK processes that are running currently
if (A_ComputerName = "BAUSTIANVM" and A_Sec=42)
{
   addToTrace("time marker (tick tock) grey line")
   ;HowManyAhksAreRunning()
   ;HowManyAhksAreRunning(A_ScriptName)
   SleepSeconds(1)
}
;}}}

;{{{ Continual backups
;archive import reports for EPMS
if (A_ComputerName = "PHOSPHORUS" and Mod(A_Sec, 5)==0)
{
   BackupFile("C:\code\report.txt",                    "C:\import_files\archive\importReports\")  ;importer reports
   BackupFile("C:\code\epms\script\epms_workbench.pl", "C:\import_files\archive\epms_workbench\") ;workbench
}
;}}}


;end of Persist subroutine
return

;{{{ functions of things that should only be used here in the Persistent file
;is there a better name for this function?
BackupFile(fileToBackup, archiveDir)
{
   if FileGetSize(fileToBackup)
   {
      FileGetTime, timestamp, %fileToBackup%
      timestamp := FormatTime(timestamp, "yyyy-MM-dd_HH-mm-ss")

      archiveFile=%archiveDir%%timestamp%.txt
      if NOT FileExist(archiveFile)
         FileCopy(fileToBackup, archiveFile)
   }
}

;WRITEME
BackupFolder(folderToBackup, archiveDir)
{
}

VerifyFireflyCheckin(whoIsCheckingIn)
{
   ;if bot or helper haven't said hi within a certain period of time, kill them and restart them

   ;FailedCheckinTime := CurrentTime() - 1000
   FailedCheckinTime := CurrentTime() - 500
   ;FailedCheckinTime := CurrentTime() - 200
   ;addtotrace(currenttime())
   ;addtotrace(failedcheckintime)
   ;addtotrace("hello")

   IniFolder:=GetPath("FireflyIniFolder")
   lastCheckin:=IniFolderRead(IniFolder, "Check-In", whoIsCheckingIn)

   if (lastCheckin < FailedCheckinTime)
   {
      debugmsg:="killing unresponsive bot"
      iniPP(debugmsg)
      addtotrace(debugmsg)
      HowManyAhksAreRunning()

      ;TODO BlockInput, MouseMove
      WinActivate, Program Manager
      MouseMove, 720, 944, 20
      MouseMove, 1080, 944, 80
      MouseMove, 1280, 944, 80
      ;TODO BlockInput, MouseMoveOff
      ;SaveScreenShot("FireflyBotFroze", "dropbox") ;UNCOMMENTME before moving live

      ;TODO figure out exactly what works best here...
      ;     seems like we can't reboot the compy all the friggin time
      ;Run, restart.ahk
      Run, ForceReloadAll.exe  ;just gives a lot of dead tray icons
      ;CloseAllAhks("", "AutoHotkey.ahk")
      ;CloseAllAhks("AutoHotkey.ahk") ;seemed ok, but gave a lot of dead processes

      Reload
      Sleep, 5000
      ;Reload()
      ExitApp
   }


   ;TODO remove all this stuff eventually 2012-02-18
   ;CurrentFirefoxUrl := GetUrlBar("Firefox")
   ;if NOT MaxTimeToWaitForDeadBot
      ;MaxTimeToWaitForDeadBot := "20200102010203"

   ;if (CurrentFirefoxUrl == LastFirefoxUrl)
   ;{
      ;iniPP("saw old url")
      ;if CurrentlyAfter(MaxTimeToWaitForDeadBot)
      ;{
         ;debugmsg:="killing rogue bot (reload after five) dmsg"
         ;iniPP(debugmsg)
         ;addtotrace(currenttime("hyphenated") . " " . debugmsg)
         ;SaveScreenShot("FireflyBotFroze", "dropbox")

         ;;TODO figure out exactly what works best here...
         ;;     seems like we can't reboot the compy all the friggin time
         ;;Run, restart.ahk
         ;;Run, ForceReloadAll.exe
         ;;CloseAllAhks("", "AutoHotkey.ahk")
         ;CloseAllAhks("AutoHotkey.ahk") ;seemed ok, but gave a lot of dead processes

         ;Reload()
      ;}
   ;}
   ;else
   ;{
      ;iniPP("saw new url")
      ;LastFirefoxUrl := CurrentFirefoxUrl
      ;MaxTimeToWaitForDeadBot:=CurrentTimePlus(500) ;TODO I think this is five minutes
   ;}
}

;all I needed was the iniFolder lib
;and the ghetto methods of debugging how many ahks were running
#include Firefly-FcnLib.ahk
;}}}
