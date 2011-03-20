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
   SleepMinutes(2)
}
;}}}

;{{{Send Jira Status Workmorrow for the Tea Meeting Minutes
if (A_Hour=14 AND A_Min=0 AND A_Sec=0)
{
   if (A_ComputerName="PHOSPHORUS")
      if A_WDay BETWEEN 2 AND 6
      {
         RunAhk("JiraWorkmorrow.ahk")
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
if (A_Hour=11 AND A_Min=05 AND A_Sec=0)
{
   if (A_ComputerName="PHOSPHORUS")
      if A_WDay BETWEEN 2 AND 6
      {
         ThreadedMsgbox("Time for lunch")
         SleepSeconds(2)
      }
}

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
if 0
if (Mod(A_Sec, 15)==0)
{
   if (A_ComputerName="PHOSPHORUS")
   {
      ;TODO perhaps we can write the same text in the top and bottom of the file as a sort of checksum
      joe:=urlDownloadToVar("http://www.autohotkey.net/~cameronbaustian/text.txt")
      last:=urlDownloadToVar("http://dl.dropbox.com/u/789954/text.txt")

      if (joe != last)
      {
         debug("silent log", "new version detected... going to run it")
         FileDelete, C:\My Dropbox\Public\text.txt
         FileAppend, %joe%, C:\My Dropbox\Public\text.txt
         timestamp := CurrentTime()
         FileAppend, %joe%, C:\My Dropbox\AHKs\scheduled\phosphorus\%timestamp%.ahk
      }
   }
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

IfWinActive, Disconnect Terminal Services Session ahk_class #32770
{
   Send, {ENTER}
}

IfWinExist, Firefox Add-on Updates ahk_class MozillaDialogClass
{
   ;ForceWinFocus("Firefox Add-on Updates ahk_class MozillaDialogClass")
   ;Sleep, 10
   ;SendInput, !i

   ;FIXME this should work!!!
   ControlSend, MozillaWindowClass1, !i, Firefox Add-on Updates ahk_class MozillaDialogClass
   Sleep, 100
   errord("nolog", "just attempted to prod along firefox update window: did it work?", A_LineNumber, A_ScriptName)
   SleepSeconds(60)
}

IfWinExist, Connection to server argon.lan.mitsi.com lost. ahk_class #32770, Close server browser? If you abort, the object browser will not show accurate data.
{
   ControlClick, &Yes
}

IfWinExist, Security Warning ahk_class #32770, Do you want to view only the webpage content that was delivered securely?
{
   ControlClick, &No
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

