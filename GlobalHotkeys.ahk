/* KEYS !

Work Keyboard                                          Home Keyboard
=============                                          =============
vkA6sc16A Browser_Back     ;(not on home kybd)
vkA7sc169 Browser_Forward  ;(not on home kybd)
vkAEsc12E ;vol down;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;vkADsc120 ;messenger;;;;
vkADsc120 ;mute;;;;;;;;;;;;;;;; COLLISIONS ;;;;;;;;;;;;vkAEsc12E ;webcam;;;;;;;
vkAFsc130 ;vol up;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;vkAFsc130 ;mute;;;;;;;;;
                                                       vkADsc120 ;mute?????
vkB3sc122 ;play/pause                                  vkB5sc16D Launch_Media
vkACsc132 ;web/home                                    vkACsc132 ;my home
vkAAsc165 Browser_Search                               vkAAsc165 Browser_Search
vkB4sc16C Launch_Mail                                  vkB4sc16C Launch_Mail

*/

;somehow this is the same key at work and home... not understanding why (maybe after reformat)
SC120::
SpiffyMute()
return

;Kill the AppsKey menu & act like a modifier
AppsKey:: return
;;;;;;;;;;;;;;AppsKey:: Send, {AppsKey}
;if (in use appskey to launch temp hotkey mode)
   ;Run, temporary.ahk
;return

;Alt-Tab Replacements (no need to let go of AppsKey)
AppsKey & RShift:: AltTab
AppsKey & Enter::  ShiftAltTab

;Mappings for the temporary hotkeys
AppsKey & 1::  Run, temporary1.ahk
AppsKey & 2::  Run, temporary2.ahk
AppsKey & 3::  Run, temporary3.ahk
AppsKey & 4::  Run, temporary4.ahk
AppsKey & 5::  Run, temporary5.ahk
AppsKey & 6::  Run, temporary6.ahk
AppsKey & 7::  Run, temporary7.ahk
AppsKey & 8::  Run, temporary8.ahk
AppsKey & 9::  Run, temporary9.ahk
AppsKey & 0::  Run, ResaveTemporary.ahk

;Egg Timer
AppsKey & t:: Run, EggTimer.ahk

;Arrange Windows
AppsKey & w:: Run, ArrangeWindows.ahk

;Nopaste macro
Appskey & v:: Run, nopaste.ahk

;Debug (on work pc)
AppsKey & d:: Run, DebugAgain.ahk

;View All Tasks
AppsKey & a:: Run, TaskMgr-AllTasks.ahk

;Make New Task
AppsKey & n:: Run, TaskMgr-NewTask.ahk

;Make New Jira Issue
AppsKey & j:: Run, CreateJiraIssue.ahk

;PrintScreen, Crop and Save
AppsKey & c:: Run, CaptureAhkImage.ahk

;Show our AHK post-it notes (question mark key)
AppsKey & /:: Run, PostItNotes.ahk

;Suspend hotkeys for 10 seconds
;so user can use a key combo that is normally overridden
AppsKey & s::
Suspend
Sleep, 10000
Suspend
return

;TODO start FARR if it exists but isn't running
;Run an AHK from the AHKs folder
AppsKey & k::
Process, Exist, FindAndRunRobot.exe
if ErrorLevel
{
   ;use Find and Run Robot, if possible
   Send, {PAUSE}
   return
}
InputBox, filename, AHK Filename, Please enter the filename of the AHK to run:

;if they forgot to add ".ahk", then add it
StringRight, fileExtension, filename, 4
if (fileExtension <> ".ahk")
   filename.=".ahk"

;if it doesn't exist, get rid of spaces and check again
if NOT FileExist(filename)
   filename:=StringReplace(filename, " ")

if NOT FileExist(filename)
   return

Run %filename%
return

;Print Screen and Save to Disk
^PrintScreen:: SaveScreenShot("KeyPress")
!PrintScreen:: SaveScreenShot("KeyPress", "dropbox", "activeWindow")
AppsKey & PrintScreen:: SaveScreenShot("KeyPress")


;Insert Date / Time Hotstrings
:*:]0d:: ; With leading zeros and no slashes
FormatTime CurrentDateTime,, MMddyyyy
SendInput %CurrentDateTime%
return

:*:]d::  ; This hotstring replaces "]d" with the current date and time via the commands below.
FormatTime CurrentDateTime,, ShortDate
SendInput %CurrentDateTime%
return

:*:]t::
FormatTime CurrentDateTime,, Time
SendInput %CurrentDateTime%
return

;Paste without formatting
^+v:: SendViaClipboard(Clipboard)

;Press the play/pause button in last.fm
;Play pause button on work keyboard
SC122::
Launch_Media::
Run, PlayPauseMusic.ahk
return

;Record the artist name in the log so we can remove them from the last.fm library later
AppsKey & b::
SetTitleMatchMode, 2
WinGetTitle, titletext, Last.fm
InputBox, inputtext, User, Whose account should we remove this artist from?
logPath=C:\My Dropbox\Public\logs
FileCreateDir, %logPath%
FileAppend, %titletext%`n%inputtext%`n`n, %logPath%\removeartist.log
return

/*
;FIXME odd... both come through as 13-045 on the VM and all keys come through as 90-045 on the parent
;SC169:: Send, ^{Alt}{vkA7sc169}
;SC16A:: Send, ^{Alt}{vkA6sc16A}
AppsKey:: Send, ^{Alt}
vk13sc045:: Send, {Ctrl Down}{Alt}{Ctrl Up}
vk5Dsc15D:: Send, {Ctrl Down}{Alt}{Ctrl Up}
vk90sc045:: Send, {Ctrl Down}{Alt}{Ctrl Up}
*/

;FIXME the code flow here is kinda crappy
;Show the current track from last.fm
AppsKey & SC122::
AppsKey & Launch_Media::
SetTitleMatchMode, RegEx
WinGetTitle, titletext, (Last.fm|Power FM)
PowerIsStreamingInWMP:=WinExist("Windows Media Player")
if (titletext=="89.7 Power FM - Powered by ChristianNetcast.com - Opera" OR PowerIsStreamingInWMP)
{
   filename=C:\DataExchange\urltempfile.txt
   playlist:=UrlDownloadToVar("http://on-air.897powerfm.com/")

   playlist:=RegExReplace(playlist, "(`r|`n)", " ")
   RegExMatch(playlist, "Now Playing.*What`'s Played Recently", outputVar)

   outputVar:=RegExReplace(outputVar, "(Now Playing|What`'s Played Recently)", "")
   outputVar:=RegExReplace(outputVar, "<.*?>", "")
   outputVar:=RegExReplace(outputVar, " +", " ")

   debug(outputVar)
   return
}
if (titletext=="")
   WinGetTitle, titletext, ahk_class QWidget
if (titletext=="")
   WinGetTitle, titletext, foobar2000
if (titletext<>"")
{
   titletext:=RegExReplace(titletext, "\[foobar2000.*$")
   titletext:=RegExReplace(titletext, " \[Indie.Rock Playlist.*?\]")
   titletext:=StringReplace(titletext, " - Last.fm - Opera")
   Debug(titletext)
}
return

AppsKey & q:: Run, temporary.ahk
AppsKey & m:: Run, RecordMacro.ahk

;TODO something that would remap or create a new set of hotkeys...
;     like a new AHK that will open up, then exit on another hotkey command
;===later note: I think I already did that (ResaveTemporary.ahk)
;     except for the exit part, maybe... but I don't think that even makes sense

;;Test to see if the Google Desktop errors are being detected
;^+d::
;titleofwin = Google Desktop Sidebar
;textofwin3 = One or more of the following gadget(s) raised an exception
;SetTitleMatchMode 1
;IfWinExist, %titleofwin%
;{
	;IfWinExist, %titleofwin%, %textofwin3%,
	;{
		;WinActivate, %titleofwin%
		;MouseClick, left, 410, 192
	;}
	;;MsgBox, Window Detected
;}
;Else
;{
	;MsgBox, Couldn't find it
;}
;return

;^#g::
;IfWinExist ahk_class _GD_Sidebar
;{
	;;this doesn't work
	;WinClose ahk_class _GD_Sidebar
	;;ahk_class _GD_Mon
	;;MsgBox Closing Google Desktop
;}
;Else
;{
	;Run "C:\Program Files\Google\Google Desktop Search\GoogleDesktop.exe" /sidebar
	;;MsgBox Google Desktop not open ... opening now
;}
;return

