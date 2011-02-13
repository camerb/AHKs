#Persistent
SetTimer, Persist, 500
return

Persist:
SetTitleMatchMode, 1

;{{{Middle of the night unit tests, backups, and reload script
if (A_Hour==3 AND A_Min==2)
{
   SpiffyMute()

   SleepSeconds(5)
   debug("reloading script")
   ;let's try for something that is a bit stiffer
   Run, ForceReloadAll.exe
}
if (A_Hour==3 AND A_Min==5)
{
   RunAhk("NightlyAhks.ahk")
}
;}}}

;{{{Send Jira Status Workmorrow for the Tea Meeting Minutes
if (A_Hour=14 AND A_Min=0 AND A_Sec=0)
{
   if (A_ComputerName="PHOSPHORUS")
      if A_WDay BETWEEN 2 AND 6
      {
         RunAhk("SendJiraWorkmorrowEmail.ahk")
         SleepSeconds(2)
      }
}
;}}}

;{{{Send Morning AHK Status Briefing
if (A_Hour=6 AND A_Min=0 AND A_Sec=0)
{
   if (A_ComputerName="PHOSPHORUS")
   {
      RunAhk("MorningStatus-SendMessage.ahk")
      SleepSeconds(2)
   }
}
;}}}

;{{{Routine email reminders
if (A_Hour=13 AND A_Min=30 AND A_Sec=0)
{
   if (A_ComputerName="PHOSPHORUS")
      if A_WDay BETWEEN 2 AND 6
         sendEmail("Update your jira tasks (completed and workmorrow)", "http://jira.mitsi.com`n`nMessage sent by bot")
}

if (A_Hour=14 AND A_Min=50 AND A_Sec=0)
{
   if (A_ComputerName="PHOSPHORUS")
      if A_WDay BETWEEN 2 AND 6
         sendEmail("Update Timesheet", "http://timesheet.mitsi.com`n`nMessage sent by bot")
}

if (A_WDay=5 AND A_Hour=10 AND A_Min=0 AND A_Sec=0)
{
   if (A_ComputerName="PHOSPHORUS")
      sendEmail("Check if Melinda is coming to lunch", "Message sent by bot")
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

;{{{Check to see if we scheduled an ahk from the cloud
if (Mod(A_Sec, 15)==0) ; AND A_ComputerName = "PHOSPHORUS")
{
   dry_run := false
   EntireAlgTimer:=starttimer()

   ;last:=urlDownloadToVar("http://dl.dropbox.com/u/789954/latestCloudAhk.txt")
   ;lastVersion:=urlDownloadToVar("http://dl.dropbox.com/u/789954/latestCloudAhkVersion.txt")
   ;codefile:=GetRemoteAHK_wErrorChecking()
   ;while true
   ;{
      codefile:=urlDownloadToVar("http://sites.google.com/site/ahkcoedz/remoteahk")
      version:=RegExReplace(codefile, "(`r|`n)", "ZZZnewlineZZZ")
      RegExMatch(version, "\#version.*?\#version", version)
      version:=RegExReplace(version, "\#version", "")
      version:=RegExReplace(version, " ", "")
      if ((NOT version) OR strlen(version) > 10)
      {
         ;delog("yellow line", "the version name/number seems incorrect", version)
      }
      else if (version != urlDownloadToVar("http://dl.dropbox.com/u/789954/latestCloudAhkVersion.txt"))
      {
         delog("purple line", "detected a change in version number", lastversion, version)

         FileDelete("C:\My Dropbox\Public\latestCloudAhkVersion.txt")
         FileAppend(version, "C:\My Dropbox\Public\latestCloudAhkVersion.txt")

   delog("broke out of loop")

   originalCode:=codefile
   ;originalReq:=last

   ;give us just the section that we want
   codefile:=RegExReplace(codefile, "(`r|`n)", "ZZZnewlineZZZ")
   RegExMatch(codefile, "sites-layout-name-one-column.*?tbody...table", codefile)
   codefile:=RegExReplace(codefile, "ZZZnewlineZZZ", "`n`n`n")

   ;get rid of some of the html
   codefile:=RegExReplace(codefile, "\<div.*?\>", "`n")
   codefile:=RegExReplace(codefile, "\<.*?\>", "")
   codefile:=RegExReplace(codefile, "^.*?\>", "")
   codefile:=RegExReplace(codefile, "\<.*?$", "")
   codefile:=StringReplace(codefile, chr(194), "", "All")
   codefile:=StringReplace(codefile, chr(160), "", "All")

   ;odd that this shows up (they put it in multiple spots)
   codefile:=RegExReplace(codefile, "remoteahk\n", "")

   ;translate from html to regular
   codefile:=RegExReplace(codefile, "&lt;", "<")
   codefile:=RegExReplace(codefile, "&gt;", ">")

   ;codefile:=StringReplace(codefile, chr(194), "", "All")
   ;last:=StringReplace(last, chr(194), "", "All")

   codefile:=RegExReplace(codefile, "(`r|`n|`r`n)", "`n")
   last:=RegExReplace(last, "(`r|`n|`r`n)", "`n")
   codefile:=RegExReplace(codefile, "`n+", "`n")
   ;debug(codefile, "zzz", last)
   ;errord("nolog", codefile)

   stripExpr:="[^!@#$%^&*(){}a-zA-Z0-9 \r\n]"
   stripExpr:="\n+"
   replExpr:="`n"
   codefile:=RegExReplace(codefile, stripExpr, replExpr)
   ;lastfilestripped:=RegExReplace(last, stripExpr, replExpr)

   delog("done with transformations")

   ;examineStrs(codefilestripped, lastfilestripped)

   ;time:=CurrentTime("hyphenated")
   ;FileAppend, %originalCode%, C:\My Dropbox\Public\ahkerrors\cloudahk\%time%-original.html
   ;FileAppend, %codefile%, C:\My Dropbox\Public\ahkerrors\cloudahk\%time%-processed.ahk

   ;FileDelete, C:\My Dropbox\Public\latestCloudAhk.txt
   ;FileAppend, %codefile%, C:\My Dropbox\Public\latestCloudAhk.txt
   timestamp := CurrentTime()
   filename=C:\My Dropbox\AHKs\scheduled\%A_ComputerName%\%timestamp%.ahk
   if NOT dry_run
      FileAppend, %codefile%, %filename%
   RunAhkAndBabysit(filename)
   Sleep, 2000
   FileDelete(filename)

   }
   ;TODO need a fcn that gives local dropbox folder location and remote dropbox folder location

   ;delog("Elapsed Time:",elapsedtime(EntireAlgTimer))
}
;}}}

;{{{Run scheduled AHKs
if (Mod(A_Sec, 15)==0)
{
   ;TODO put all this crap into another ahk, so that persistent doesn't halt while we're babysitting other ahks
   Loop, %A_WorkingDir%\scheduled\%A_ComputerName%\*.ahk
   {
      ;check to make sure filedate is a number and is 14 long
      if ( strlen(A_LoopFileName) == 18 )
      {
         StringTrimRight, filedate, A_LoopFileName, 4
         if filedate is integer
            shouldRun:=CurrentlyAfter(filedate)
      }
      if (A_LoopFileName=="asap.ahk" or shouldRun)
      {
         ;copy file contents to a new ahk and run it
         tempahk=Scheduled-%A_LoopFileName%
         FileCopy, %A_LoopFileFullPath%, %tempahk%, 1
         FileAppend, `n#include FcnLib.ahk`nSelfDestruct(), %tempahk%
         debug("silent log", "running scheduled ahk:", tempahk)
         status:=RunAhkAndBabysit(tempahk)
         FileDelete, %A_LoopFileFullPath%
         if (status == "error") {
            time:=CurrentTime("hyphenated")
            path=C:\My Dropbox\Public\ahkerrors\
            FileCreateDir, %path%
            FileMove, %tempahk%, %path%%time%-%tempahk%.txt, 1
         }
         ;wait for the scheduled ahk to finish running and self-destruct
         ;since this is the persistent file, we don't want more than one
         ;scheduled ahk to run at one time
         WaitFileNotExist(tempahk)
      }
   }
}
;}}}

;{{{ new ways to close unwanted windows
CloseTrayTip("Automatic Updates is turned off")
CloseTrayTip("A new version of Java is ready to be installed.")
CloseTrayTip("There are unused icons on your desktop")
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
;}}}

;{{{ kill processes that are of the devil
Process, Close, newreleaseversion70700.exe
Process, Close, DivXUpdate.exe
;}}}

;{{{ Old legacy stuff for closing unwanted windows

SetTitleMatchMode 2

WinClose, Error, An instance of Pidgin is already running

;This is for foobar at work
;IfWinExist, Playback error
   ;WinClose

IfWinExist, Connection to server argon.lan.mitsi.com lost. ahk_class #32770, Close server browser? If you abort, the object browser will not show accurate data.
{
   ControlClick, &Yes
}

CustomTitleMatchMode("Contains")
WinClose, pgAdmin III ahk_class #32770, server closed the connection unexpectedly
CustomTitleMatchMode("Default")
   ;ControlClick, OK

;This is for accidentally opened .js files
WinClose, Windows Script Host, 'Ext' is undefined

;Come on, i already know my Win XP isn't pirated
WinClose, Windows Genuine Advantage Notifications - Installation Wizard

;Close stupid popups from Google Desktop Sidebar
titleofwin = Google Desktop Sidebar
textofwin1 = Weather may be busy, or it may have stopped responding
textofwin2 = The data for the following gadget could not be loaded.
textofwin3 = One or more of the following gadget(s) raised an exception
IfWinExist, %titleofwin%
{
   SaveScreenShot("GDS1before")
   Sleep 500
   WinClose, %titleofwin%, %textofwin1%,
   WinClose, %titleofwin%, %textofwin2%,
   IfWinExist, %titleofwin%, %textofwin3%,
   {
      ;for some reason ctrlclick did not work
      WinActivate, %titleofwin%
      MouseClick, left, 410, 192
   }
   IfWinExist, %titleofwin%,
      ControlClick, %titleofwin%,  X410 Y192
   Sleep 500
   SaveScreenShot("GDS2after")
}

;Temporary solution, close the pestering dialog since i'm using the trial
IfWinActive, Balsamiq Mockups For Desktop - * New Mockup ahk_class ApolloRuntimeContentWindow
{
   ClickIfImageSearch("images\balsamiq\TrialDialog.bmp")
}

;Skip confirmation dialog about switching to high contrast
IfWinExist, High Contrast ahk_class NativeHWNDHost
{
   ForceWinFocus("High Contrast ahk_class NativeHWNDHost")
   Send, {ENTER}
}

;Annoying Popups
titleofwin = Popular ScreenSavers!!
SetTitleMatchMode 2
IfWinExist, %titleofwin%
{
   WinClose
}

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


;end of CloseWarnings subroutine
return

