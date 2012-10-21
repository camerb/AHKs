#Persistent
SetTimer, Persist, 500
return

Persist:
SetTitleMatchMode, 1


LogLastLineExecuted("chk 0")

LogLastLineExecuted("chk " . A_LineNumber)

;{{{ temporary things (processes to kill)
;if (A_ComputerName = "PHOSPHORUS")
   ;ProcessClose("pidgin.exe")
;if (A_ComputerName = "BAUSTIAN12")
   ;ProcessClose("CLCL.exe")
;}}}

LogLastLineExecuted("chk " . A_LineNumber)

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
   ;addtotrace("Max time it took for one iteration:", maxTotalTime)
;}
;timer:=starttimer()
;}}}

LogLastLineExecuted("chk " . A_LineNumber)

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
if (A_Min==10 AND A_ComputerName == "BAUSTIANVM" AND A_Hour<>3 AND A_Hour<>4)
{
   if RunOncePerDay("PushToGit-Nightly")
   {
      RunAhk("PushToGit.ahk")
      SleepMinutes(1.1)
   }
}
;}}}

LogLastLineExecuted("chk " . A_LineNumber)

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

LogLastLineExecuted("chk " . A_LineNumber)

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

LogLastLineExecuted("chk " . A_LineNumber)

;{{{Test Lynx SMS everyday
;if (A_Hour=7 AND A_Min=50 AND A_Sec=0)
;{
   ;if (A_ComputerName="PHOSPHORUS")
      ;if A_WDay BETWEEN 2 AND 6
      ;{
         ;RunAhk("TestLynx.ahk")
         ;SleepSeconds(2)
      ;}
;}
if A_WDay BETWEEN 2 AND 6
   RunDailyTask("07:50:00", "PHOSPHORUS", "TestLynx.ahk")
;}}}

LogLastLineExecuted("chk " . A_LineNumber)

;{{{Test Lynx SMS everyday, again
if A_WDay BETWEEN 2 AND 6
{
   if (A_Hour=7 AND A_Min=45 AND A_Sec=0)
   ;RunDailyTask("HH:MM:SS", "PHOSPHORUS", "asdf.ahk", "params")
      if (A_ComputerName="PHOSPHORUS")
         if A_WDay BETWEEN 2 AND 6
         {
            RunAhk("TestLynx.ahk")
            SleepSeconds(2)
         }
}
;}}}

LogLastLineExecuted("chk " . A_LineNumber)

;{{{Test Lynx SMS throughout the day
;Check out how I organized this in a really crappy way, sucky indents!!
if A_WDay BETWEEN 2 AND 6
if A_Hour BETWEEN 8 AND 16
if (A_ComputerName="PHOSPHORUS")
if (A_Sec<9)
{
   if (A_Min=15 OR A_Min=45)
   {
      ;FIXME where did this fcn go?
      runOnceKey=%A_Hour%_%A_Min%_LynxSmsTest
      if RunOncePerDay(runOnceKey)
      {
         RunAhk("TestLynxSMS.ahk")
         SleepSeconds(2)
      }
   }
}
;}}}

LogLastLineExecuted("chk " . A_LineNumber)

LogLastLineExecuted("chk 1")

LogLastLineExecuted("chk " . A_LineNumber)

;{{{Routine email/msgbox reminders
if (A_Hour=7 AND A_Min=55 AND A_Sec=0)
{
   if (A_ComputerName="PHOSPHORUS")
      if A_WDay BETWEEN 2 AND 6
      {
         ThreadedMsgbox("Get Notepad/Pen")
         SleepSeconds(2)
      }
}

if (A_Hour=8 AND A_Min=35 AND A_Sec=0)
{
   if (A_ComputerName="PHOSPHORUS")
      if A_WDay BETWEEN 2 AND 6
      {
         ThreadedMsgbox("Meeting Time")
         SleepSeconds(2)
      }
}

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

if (A_Hour=13 AND A_Min=0 AND A_Sec=0)
{
   if (A_ComputerName="PHOSPHORUS")
   {
      sendEmail("Read yer Bible", "Message sent by bot", "", "melindabaustian@gmail.com")
      SleepSeconds(2)
   }
}

if (A_Hour=14 AND A_Min=45 AND A_Sec=0)
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

;if (A_WDay=5 AND A_Hour=10 AND A_Min=0 AND A_Sec=0)
;{
   ;if (A_ComputerName="PHOSPHORUS")
      ;sendEmail("Check if Melinda is coming to lunch", "Message sent by bot")
;}

if (A_WDay=6 AND A_Hour=10 AND A_Min=0 AND A_Sec=0)
{
   if (A_ComputerName="PHOSPHORUS")
      sendEmail("Mitsi Donut Day", "Message sent by bot")
}

if (A_DD=17 AND A_Hour=7 AND A_Min=59 AND A_Sec=0)
{
   if (A_ComputerName="PHOSPHORUS")
   {
      sendEmail("Bill reminder", "Cameron Mastercard`n`nMessage sent by bot")
      SleepSeconds(2)
   }
}
if (A_DD=07 AND A_Hour=7 AND A_Min=59 AND A_Sec=0)
{
   if (A_ComputerName="PHOSPHORUS")
   {
      sendEmail("Bill reminder", "Melinda Mastercard`n`nMessage sent by bot")
      SleepSeconds(2)
   }
}
if (A_DD=11 AND A_Hour=7 AND A_Min=59 AND A_Sec=0)
{
   if (A_ComputerName="PHOSPHORUS")
   {
      sendEmail("Bill reminder", "City of Garland Electric`n`nMessage sent by bot")
      SleepSeconds(2)
   }
}
if (A_DD=25 AND A_Hour=7 AND A_Min=59 AND A_Sec=0)
{
   if (A_ComputerName="PHOSPHORUS")
   {
      sendEmail("Bill reminder", "Chase Freedom Credit (Routine Bills Card)`n`nMessage sent by bot")
      SleepSeconds(2)
   }
}

if (A_DD=26 AND A_Hour=7 AND A_Min=59 AND A_Sec=0)
{
   if (A_ComputerName="PHOSPHORUS")
   {
      sendEmail("Mint checkup", "Ensure that mint records are updating for all accounts`n`nMessage sent by bot")
      SleepSeconds(2)
   }
}
;}}}

LogLastLineExecuted("chk " . A_LineNumber)

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

LogLastLineExecuted("chk " . A_LineNumber)

;{{{Monitor FF4 RAM usage
;if (Mod(A_Min, 15)==0 && A_Sec==35)
;{
   ;if (A_ComputerName="PHOSPHORUS")
   ;{
      ;time:=currenttime("hyphenated")
      ;pid:=getpid("firefox.exe")
      ;ram:=GetRamUsage(pid)
      ;cpu:=GetCpuUsage(pid)
      ;csvLine := ConcatWithSep(",", time, pid, ram, cpu)
      ;FileAppendLine(csvLine, "gitExempt/phosFFstats.csv")
      ;sleepseconds(2)
   ;}
;}
;}}}

LogLastLineExecuted("chk " . A_LineNumber)
;it seemed to hang up here on phosphorus once 10/4

;{{{Check bot emails, and process them accordingly (cloud AHKs and Lynx SMS checks)
if (Mod(A_Sec, 5)==0)
{
   ;if (A_ComputerName="baustian12")
   if (A_ComputerName="phosphorus")
   {
      ghetto:=SexPanther()
      BotGmailUrl=https://cameronbaustianbot:%ghetto%@gmail.google.com/gmail/feed/atom

      gmailPage:=urldownloadtovar(BotGmailUrl)
      RegExMatch(gmailPage, "<fullcount>(\d+)</fullcount>", gmailPage)
      RegExMatch(gmailPage, "\d+", number)

      if (number == 0 || number == "")
         number:=""

      ;debug("saw unread emails", number)

      if (number)
      {
         RunAhkAndBabysit("ProcessBotEmails.ahk")
         SleepSeconds(10)
         ;SleepSeconds(20)
         ;SleepSeconds(60)
         ;maybe we should sleep more like 60 secs
      }
   }
}
;}}}

LogLastLineExecuted("chk " . A_LineNumber)

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

LogLastLineExecuted("chk " . A_LineNumber)

;{{{ Run Queued Functions (queued in a variable)
;run every time through the loop (500 ms), or maybe we should wait longer, like 5 seconds
;if queue is empty, length 0, do nothing
;Run the next item in the queue, then bail out
    ; (we need to keep going so that we can monitor things like windows that pop up
;Maybe I should put the AHKs into an ini variable, put a tick count on them, and then
;if ( Mod(A_Sec, 2) == 0 )
;{
   ;;TODO if this has already run this second, then bail

   ;;TODO move this to an AssignGlobals() func
   ;G_null := "ZZZ-NULL-ZZZ"

   ;if G_VariableQueuedFunctions
   ;{
      ;Loop, parse, G_VariableQueuedFunctions, `n
      ;{
         ;LineToRun := A_LoopField

         ;needle=^(%LineToRun%)(`n)?
         ;G_VariableQueuedFunctions := RegExReplace(G_VariableQueuedFunctions, needle)

         ;;parse the sucker
         ;Loop, parse, LineToRun, CSV
         ;{
            ;i := A_Index - 1
            ;Param%i% := A_LoopField
            ;numberOfParams := i
         ;}
         ;FuncToRun := Param0

         ;;FIXME
         ;;FuncToRun := LineToRun

         ;;run the sucker, with the correct number of params
         ;if (numberOfParams == 0)
            ;%FuncToRun%()
         ;else if (numberOfParams == 1)
            ;%FuncToRun%(param1)
         ;else if (numberOfParams == 2)
            ;%FuncToRun%(param1, param2)
         ;else if (numberOfParams == 3)
            ;%FuncToRun%(param1, param2, param3)
         ;else if (numberOfParams == 4)
            ;%FuncToRun%(param1, param2, param3, param4)
         ;else if (numberOfParams == 5)
            ;%FuncToRun%(param1, param2, param3, param4, param5)
         ;else if (numberOfParams == 6)
            ;%FuncToRun%(param1, param2, param3, param4, param5, param6)
         ;else if (numberOfParams == 7)
            ;%FuncToRun%(param1, param2, param3, param4, param5, param6, param7)
         ;else if (numberOfParams == 8)
            ;%FuncToRun%(param1, param2, param3, param4, param5, param6, param7, param8)
         ;else if (numberOfParams == 9)
            ;%FuncToRun%(param1, param2, param3, param4, param5, param6, param7, param8, param9)
         ;else if (numberOfParams == 10)
            ;%FuncToRun%(param1, param2, param3, param4, param5, param6, param7, param8, param9, param10)
         ;else if (numberOfParams == 11)
            ;%FuncToRun%(param1, param2, param3, param4, param5, param6, param7, param8, param9, param10, param11)
         ;else if (numberOfParams == 12)
            ;%FuncToRun%(param1, param2, param3, param4, param5, param6, param7, param8, param9, param10, param11, param12)
         ;else if (numberOfParams == 13)
            ;%FuncToRun%(param1, param2, param3, param4, param5, param6, param7, param8, param9, param10, param11, param12, param13)
         ;else if (numberOfParams == 14)
            ;%FuncToRun%(param1, param2, param3, param4, param5, param6, param7, param8, param9, param10, param11, param12, param13, param14)
         ;else if (numberOfParams == 15)
            ;%FuncToRun%(param1, param2, param3, param4, param5, param6, param7, param8, param9, param10, param11, param12, param13, param14, param15)

         ;;bail out and do other things, Variable Queued Functions are not a priority
         ;break
      ;}
   ;}
;}

;Schedule something for testing
;if NEVER
;if (A_ComputerName = "PHOSPHORUS" and A_Sec=54)
;{
   ;ScheduleVariableQueuedFunction("debug")
   ;ScheduleVariableQueuedFunction("debug", "hi mom")
   ;ScheduleVariableQueuedFunction("debug", "hi mom", 1, 2, 3)
   ;ScheduleVariableQueuedFunction("addtotrace", "hi")
   ;ScheduleVariableQueuedFunction("debug", "hi mom", 1, 2, 3, 4, 5)
;}

;show scheduled ahks for debugging
;if (A_ComputerName = "PHOSPHORUS" and A_Sec=54)
;{
   ;AddToTrace(G_VariableQueuedFunctions)
   ;SleepSeconds(1.1)
;}
;}}}

LogLastLineExecuted("chk " . A_LineNumber)

LogLastLineExecuted("chk 2")

LogLastLineExecuted("chk " . A_LineNumber)

;{{{ Close unwanted windows, new ways, but not one-liners
if ForceWinFocusIfExist("Microsoft Windows")
{
   if SimpleImageSearch("images/win7/doYouWantToScanAndFixFlashDrive.bmp")
      ClickIfImageSearch("images/win7/continueWithoutScanning.bmp", "control")
}
;}}}

LogLastLineExecuted("chk " . A_LineNumber)

;{{{ new ways to close unwanted windows

;note that this is the body of the traytip, not the title
CloseTrayTip("Automatic Updates is turned off")
CloseTrayTip("A new version of Java is ready to be installed.")
CloseTrayTip("There are unused icons on your desktop")
CloseTrayTip("Click here to have Windows automatically keep your computer")

if ForceWinFocusIfExist("Microsoft SQL Server Management Studio Recovered Files")
   ClickButton("&Do Not Recover")

IfWinActive, NEMON ahk_class #32770, Are you sure to close
   ClickButton("&Yes")
;}}}

LogLastLineExecuted("chk " . A_LineNumber)

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

   ;CustomTitleMatchMode("Exact")
   ;IfWinActive, Control Panel ahk_class G2WHeadPane
   ;{
      ;if ClickIfImageSearch("images\GoToMeeting\newPersonInMeeting.bmp", "Right")
      ;{
         ;Sleep, 100
         ;Send, {DOWN 2}
         ;Sleep, 100
         ;Send, {ENTER}
      ;}
   ;}
   ;CustomTitleMatchMode("Default")
}
;}}}

LogLastLineExecuted("chk " . A_LineNumber)

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

LogLastLineExecuted("chk " . A_LineNumber)
;FIXME this region seems to die often on phosphorus
;{{{ kill processes that are of the devil
Process, Close, newreleaseversion70700.exe
Process, Close, DivXUpdate.exe
;}}}

LogLastLineExecuted("chk " . A_LineNumber)

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

IfWinExist, Remote Desktop Connection, or if the remote computer is not configured to support server authentication
{
   WinActivate
   Sleep, 100
   Send, !d
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

LogLastLineExecuted("chk " . A_LineNumber)

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

LogLastLineExecuted("chk " . A_LineNumber)

;{{{ Watch for error messages from AHKs with syntax errors (and log them)
;FIXME this might not be working correctly
;IfWinExist, %filename%, (The program will exit|The previous version will remain in effect)
;{
   ;textFromTheWindow := WinGetText()
   ;ControlClick, OK, %filename%
   ;errord("silent yellow line", A_ThisFunc, filename, "AHK file had an error...", textFromTheWindow, "... end of error msg")
   ;;return "error"
;}
;}}}

LogLastLineExecuted("chk 3")

LogLastLineExecuted("chk " . A_LineNumber)

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

LogLastLineExecuted("chk " . A_LineNumber)

;{{{ TransferTo - Check to see if there are files that need to be moved out of the dropbox
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

LogLastLineExecuted("chk " . A_LineNumber)

;{{{ Ensure VM firefly bot is running, and not crashed
;if (A_ComputerName = "BAUSTIANVM" and Mod(A_Sec, 5)==0)
;{
   ;if NOT ProcessExist("Baretail.exe")
   ;{
      ;RunProgram("C:\Dropbox\Programs\Baretail\Baretail.exe")
      ;SleepSeconds(5)
   ;}

   ;;checkin
   ;FireflyCheckin("Babysitter", "Watching")

   ;if NOT IsAhkCurrentlyRunning("FireflyFeesBot")
   ;{
      ;RunAhk("C:\Dropbox\AHKs\FireflyFeesBot.ahk")
      ;SleepSeconds(5)
   ;}
   ;if NOT IsAhkCurrentlyRunning("fireflySupervisionCore")
   ;{
      ;RunAhk("C:\Dropbox\AHKs\fireflySupervisionCore.ahk")
      ;SleepSeconds(5)
   ;}
   ;if NOT IsAhkCurrentlyRunning("FireflyBotHelper")
   ;{
      ;RunAhk("C:\Dropbox\AHKs\FireflyBotHelper.ahk")
      ;SleepSeconds(5)
   ;}
   ;Sleep, 1200
;}

;;Send Queued Emails several times during the day
;if (A_ComputerName = "BAUSTIANVM" and Mod(A_Min, 5)==0 and A_Sec==45)
;{
   ;addtotrace("purple line - sending queued emails")
   ;RunAhk("C:\Dropbox\AHKs\SendQueuedEmails.ahk")
   ;Sleep, 1200
;}

;getting some info about the AHK processes that are running currently
;if (A_ComputerName = "BAUSTIANVM" and A_Sec=42)
;{
   ;addToTrace("time marker (tick tock) grey line")
   ;;HowManyAhksAreRunning()
   ;;HowManyAhksAreRunning(A_ScriptName)
   ;SleepSeconds(1)
;}

;delete dropbox cruft on VM
;TODO move this to the variable queued AHKs
if (A_ComputerName = "BAUSTIANVM" and A_Min=0 and A_Sec=42)
{
   RunAhk("DeleteDropboxCruft.ahk")
}

;TODO move this to the variable queued AHKs
if (A_ComputerName = "PHOSPHORUS" and A_Sec=32)
{
   Run, fireflyCreateViewableInis.ahk
   SleepSeconds(1.1)
}
;}}}

LogLastLineExecuted("chk " . A_LineNumber)
;FIXME this region seems to die often on phosphorus, due to the long pause
;{{{ Run the Supervision Core
if (Mod(A_Sec, 5)==0)
{
   ;checkin
   FireflyCheckin("Babysitter", "Watching")

   if NOT ProcessExist("SupervisionCore1.exe")
   {
      lPath=C:\Dropbox\AHKs\SupervisionCore.exe
      npath=C:\Dropbox\AHKs\SupervisionCore1.exe
      ;TODO use numbered files
      ;delete the numbered file
      ;copy the file to new numeric item
      FileCopy(lpath, npath, "overwrite")
      ;then run the file
      Run, %npath%
      SleepSeconds(5)
   }
   ;Loop, 3
   ;{
      ;thisFileName=SupervisionCore%A_Index%.exe
      ;thisFilePath=C:\Dropbox\AHKs\%fileName%
      ;if NOT ProcessExist(thisFileName)
      ;{
         ;;TODO use numbered files
         ;;delete the numbered file
         ;;copy the file to new numeric item
         ;;FileCopy
         ;;then run the file
         ;Run, C:\Dropbox\AHKs\SupervisionCore.exe
         ;SleepSeconds(5)
      ;}
   ;}
   Sleep, 1200
}
;}}}

LogLastLineExecuted("chk " . A_LineNumber)

;{{{ Count the number of fees that need to be added by the firefly bot
;if (A_ComputerName = "BAUSTIAN12" and A_Sec == 48)
;{
   ;if IsVmRunning()
      ;Run, fireflyCountFeesNotYetAdded.ahk
   ;else
      ;FileCreate("VM is not running", "C:\Dropbox\Public\fireflyFees.txt")
   ;Sleep, 1000
;}
;}}}

LogLastLineExecuted("chk " . A_LineNumber)

;{{{ Continual backups

;Set all the variables for backing up FireflyScorecards
if ( Mod(A_Sec, 5)==0 )
{
   myConfig := GetPath("MyConfig.ini")
   if (A_ComputerName = "BAUSTIAN12" and Mod(A_Min, 5)==0)
      G_FireflyScorecardXLS := IniRead(myConfig, "FireflyScorecard", "WorkingExcelFile")

   ;archive firefly scorecard for Mel
   datestamp := CurrentTime("hyphendate")
   ArchivePath=C:\Dropbox\Melinda\Firefly\archive-scorecards\%datestamp%
   if (A_ComputerName = "BAUSTIAN12")
   {
      BackupFile(G_FireflyScorecardXLS, ArchivePath)
   }

   ;archive import reports for EPMS
   if (A_ComputerName = "PHOSPHORUS")
   {
      BackupFile("C:\code\report.txt",                    "C:\import_files\archive\importReports\")  ;importer reports
      ;BackupFile("C:\code\epms\script\epms_workbench.pl", "C:\import_files\archive\epms_workbench\") ;workbench

      ;FIXME this appears to be broken
      BackupFile("C:\Dropbox\AHKs\gitExempt\financialProjection.csv", "C:\Dropbox\AHKs\gitExempt\financialProjectionArchive\")
      ;archive nightly financial projections, and anything that I save as corrections to it
   }
}
;}}}

LogLastLineExecuted("chk " . A_LineNumber)

;{{{ Get ready for iRacing, if applicable
if mod(A_Sec, 30) == 0
{
   url := GetUrlBar("firefox")
   if InStr(url, "iracing.com")
      if NOT WinExist("Logitech Profiler")
         ChangeLogitechWheelMode()
}
;}}}

LogLastLineExecuted("chk " . A_LineNumber)

;{{{ ensure race reminders are running
if (A_ComputerName = "BAUSTIAN12" and Mod(A_Sec, 5)==0)
{
   url := GetUrlBar("firefox")
   if ( ProcessExist("iRacingSim.exe") OR InStr(url, "iracing.com") )
   {
      if NOT IsAhkCurrentlyRunning("iRacingRaceReminders")
      {
         RunAhk("C:\Dropbox\AHKs\iRacingRaceReminders.ahk")
         SleepSeconds(5)
      }
   }
}
;}}}

LogLastLineExecuted("chk " . A_LineNumber)

;{{{ refresh networked hard drive connections
;TODO start network connections at the beginning of the day
;TODO start network connections whenever connection is lost
if (A_ComputerName = "PHOSPHORUS" and Mod(A_Sec, 5)==0 and A_Min == 38)
{
   Run, KeepNetworkHardDrivesActive.ahk
   SleepSeconds(1)
}
;}}}

LogLastLineExecuted("chk " . A_LineNumber)

;{{{ un-minimize RDP sessions... RDP should never be minimized, just move the window so I can't see it
win= - Remote Desktop Connection
if IsMinimized(win)
{
   Loop, 10
   {
      WinRestore, %win%
      WinMove, %win%, , 3685, 1057, 838, 607
      SleepSeconds(1)
      if ( !IsMinimized(win) AND !IsMaximized(win) )
         break
   }
}
;}}}

LogLastLineExecuted("chk " . A_LineNumber)

;{{{ resize Thunderbird Tasks window
win=^(Edit|New) Task\:.*$
CustomTitleMatchMode("RegEx")
IfWinActive, %win%
{
   CustomTitleMatchMode("Default")
   fullTitle:=WinGetActiveTitle()
   ;WinMove, %win%, , , , 800, 604
   WinMove, %fullTitle%, , , , 800, 604
}
CustomTitleMatchMode("Default")
;}}}

LogLastLineExecuted("chk " . A_LineNumber)

;{{{ open pidgin at start of workday
if (A_ComputerName = "PHOSPHORUS" and Mod(A_Sec, 5)==0 and A_Min == 51 and A_Hour == 07)
{
   if RunOncePerDay("OpenPidginAtStartOfWorkday")
      Send, #6
}
;}}}

LogLastLineExecuted("chk " . A_LineNumber)

;{{{ ensure sugar spy is running
if (Mod(A_Sec, 5)==0 AND A_Min == 41 AND A_ComputerName = "PHOSPHORUS")
{
   ;Run, soffice.exe
   Run, SugarRetrieval.ahk
   Run, SugarProcessor.ahk
}
;if (Mod(A_Sec, 5)==0 AND A_Min == 41)
;{
   ;if NOT ProcessExist("soffice.exe")
   ;{
      ;nPath=C:\Dropbox\AHKs\SupervisionCore.exe
      ;Run, %npath%
      ;SleepSeconds(1.1)
   ;}
;}

;}}}

;end of Persist subroutine
return

;{{{ functions of things that should only be used here in the Persistent file

;DOES NOT SUPPORT LINE BREAKS
ScheduleVariableQueuedFunction(functionName, param1="ZZZ-NULL-ZZZ", param2="ZZZ-NULL-ZZZ", param3="ZZZ-NULL-ZZZ", param4="ZZZ-NULL-ZZZ", param5="ZZZ-NULL-ZZZ", param6="ZZZ-NULL-ZZZ", param7="ZZZ-NULL-ZZZ", param8="ZZZ-NULL-ZZZ", param9="ZZZ-NULL-ZZZ", param10="ZZZ-NULL-ZZZ", param11="ZZZ-NULL-ZZZ", param12="ZZZ-NULL-ZZZ", param13="ZZZ-NULL-ZZZ", param14="ZZZ-NULL-ZZZ", param15="ZZZ-NULL-ZZZ")
{
   global G_VariableQueuedFunctions
   global G_null

   if NOT functionName
      errord("tried to schedule a blank function name")

   ;figure out what the scheduled item will look like
   ;ODO  csv-style!
   ;ODO multi-param!
   ItemToSchedule := functionName
   Loop, 15
   {
      thisParam := param%A_Index%
      if ( thisParam == G_null )
         break

      ItemToSchedule .= ","
      ItemToSchedule .= Format4Csv(thisParam)
   }

   ;already scheduled
   if InStr(G_VariableQueuedFunctions, ItemToSchedule)
      return

   ;go ahead and schedule the sucker!
   if G_VariableQueuedFunctions
      G_VariableQueuedFunctions .= "`n"
   G_VariableQueuedFunctions .= ItemToSchedule
}

;RunDailyTask("HH:MM:SS", "PHOSPHORUS", "asdf.ahk", "params")
;WRITEME
RunDailyTask(HHcolonMMcolonSS, ComputerName, AhkToRun) ;;;;;;, params="")
{
   ;TODO
   ;if timeIsNow
      ;RunAhk(AhkToRun)
   ;SleepSeconds(2)
   RegExMatch(HHcolonMMcolonSS, "(\d\d).(\d\d).(\d\d)", match)

   if (A_Hour=match1 AND A_Min=match2 AND A_Sec=match3)
   {
      if (A_ComputerName = ComputerName)
      {
         RunAhk(AhkToRun)
         SleepSeconds(2)
      }
   }
}

;is there a better name for this function?
;BackupFileImmediatelyOnChange() ????
BackupFile(fileToBackup, archiveDir)
{
   archiveDir := EnsureEndsWith(archiveDir, "\")
   if NOT FileExist(fileToBackup) ;die with silent error, maybe?
      return
   EnsureDirExists(archiveDir)
   if NOT FileDirExist(archiveDir)
      return

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

;{{{ Trying to debug some issues with AHKs crashing lots
;use for debugging different places throughout this script
FindOutWhereItCrashed()
{
   if NOT RegExMatch(A_ComputerName, "^(PHOSPHORUS|BAUSTIAN12)$")
      return

   ini := GetPath("MyStats.ini")
   date := CurrentTime("hyphendate")
   lineNumber := IniRead(ini, date, "LastLineExecuted")
   ;iniPP("This line executed shortly before AHKs appeared to hang- " . lineNumber)
}

;trying to log each line
LogLastLineExecuted(lineNumber)
{
   if NOT RegExMatch(A_ComputerName, "^(PHOSPHORUS|BAUSTIAN12)$")
      return

   ini := GetPath("MyStats.ini")
   date := CurrentTime("hyphendate")
   IniWrite(ini, date, "LastLineExecuted", lineNumber)
   ;iniPP(lineNumber) ;generates too much darned noise
}
;}}}

;all I needed was the iniFolder lib
;and the ghetto methods of debugging how many ahks were running
;also needed the number
;ExitApp
#include Firefly-FcnLib.ahk
;#include fireflySupervisionCore.ahk
;}}}
