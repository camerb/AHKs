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
AppsKey & 0::  Run, temporary0.ahk
AppsKey & -::  Run, ResaveTemporary.ahk
AppsKey & =::  Run, NewTempAhk.ahk

^+!#0::
ActiveFile := Prompt("Which file would you like to work on?")
ActiveFile := EnsureEndsWith(ActiveFile, ".ahk")
RegExMatch(ActiveFile, "^.*\\", folderPath)
command=Run, %ActiveFile%, %folderPath%
FileCreate(command, "temporary0.ahk")
return

/*
AppsKey & 0::  Run, temporary.ahk
;or, this could be a way to run an ironahk script
;or, we could add another modifier so that IronAHK is launched using a separate modifier
;or, we could save the file that we are currently working on and use Apps0 as a launcher for that ahk - currently the path I'm using
*/

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
if NOT ProcessExist("FindAndRunRobot.exe") and NOT IsVM()
{
   RunProgram("FindAndRunRobot.exe")
   Sleep, 1000
}

if ProcessExist("FindAndRunRobot.exe")
{
   ;use Find and Run Robot, if possible
   Send, {PAUSE}
   return
}
InputBox, filename, AHK Filename, Please enter the filename of the AHK to run:

;if they forgot to add ".ahk", then add it
filename := EnsureEndsWith(filename, ".ahk")

;if it doesn't exist, get rid of spaces and check again
if NOT FileExist(filename)
   filename:=StringReplace(filename, " ")

if NOT FileExist(filename)
   return

Run %filename%
return

;Print Screen and Save to Disk
^PrintScreen:: SaveScreenShot("KeyPress", "dropbox")
!PrintScreen:: SaveScreenShot("KeyPress", "dropbox", "activeWindow")
AppsKey & PrintScreen:: SaveScreenShot("KeyPress", "dropbox")


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

;hotstrings for auto-complete on linking people to the forum
:*:the definitive autofire thread::http://www.autohotkey.com/forum/viewtopic.php?t=69474 - The Definitive Autofire Thread

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
logPath=C:\Dropbox\Public\logs
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

#include thirdparty/notify.ahk
;FIXME the code flow here is kinda crappy
;Show the current track from last.fm
AppsKey & SC122::
AppsKey & Launch_Media::
SetTitleMatchMode, RegEx
DetectHiddenWindows, On
titletext := WinGetTitle("(Last.fm|Power FM)")
;debug(titletext)

;FIXME buggy
PowerIsStreamingInWMP:=WinExist(".+Windows Media Player")
;titletext := WinGetTitle("Windows Media Player")
;debug(titletext)

WinGetTitle, titletext, foobar2000
DetectHiddenWindows, Off
if (titletext<>"")
   notify("", titletext, 5)
if (titletext=="")
   WinGetTitle, titletext, ahk_class QWidget
if (titletext=="")
   WinGetTitle, titletext, foobar2000
if (titletext<>"")
{
   titletext:=RegExReplace(titletext, "\[foobar2000.*$")
   titletext:=RegExReplace(titletext, " \[Indie.Rock Playlist.*?\]")
   titletext:=StringReplace(titletext, " - Last.fm - Opera")
   notify("", titletext, 5)
}
if (titletext=="89.7 Power FM - Powered by ChristianNetcast.com - Opera" OR PowerIsStreamingInWMP)
{
   playlist:=UrlDownloadToVar("http://on-air.897powerfm.com/")

   playlist:=RegExReplace(playlist, "(`r|`n)", " ")
   RegExMatch(playlist, "Now Playing.*What`'s Played Recently", outputVar)

   outputVar:=RegExReplace(outputVar, "(Now Playing|What`'s Played Recently)", "")
   outputVar:=RegExReplace(outputVar, "<.*?>", "")
   outputVar:=RegExReplace(outputVar, " +", " ")

   notify("", outputVar, 5)
}
return

AppsKey & q:: Run, temporary.ahk
AppsKey & m:: Run, RecordMacro.ahk

#e::
RunProgram("C:\Program Files\EF Commander Free\EFCWT.EXE")
WinWait, EFLogo
WinClose

;recent replacement
WinWaitActive, EF Commander Free
;ForceWinFocus("EF Commander Free")

return

;----- Run Code From Clipboard - from tidbit, but modified alot
;LOL... that if statement is horrible
~^Lwin::
ahkHotkey=#include FcnLib.ahk`n`n%Clipboard%`n`n ~esc::ExitApp
~^+Lwin::
ahkNoHotkey=%Clipboard%
if InStr(Clipboard, "esc::")
   ahkHotkey=
if ahkHotkey
   ahk:=ahkHotkey
else
   ahk:=ahkNoHotkey
file=%A_ScriptDir%\cliprun.ahk
FileDelete(file)
FileAppend(ahk, file)
Run, %file%
Sleep 2000 ;no, seriously, this will keep you from doing stupid stuff (running too many clipAHKs)
Return

;control the firefly macros if they ran amuck
^`::
DetectHiddenWindows, On
;TODO make this a function IsAhkRunning() and include AutoHotkey in the title. (and allow regex)
IfWinExist, firefly.*.ahk
{
   BlockInput, MouseMoveOff
   AhkClose("fireflyButtons.ahk")
   RunAhk("fireflyButtons.ahk")
   reload
}
else
   RunAhk("fireflyButtons.ahk")
DetectHiddenWindows, Off
return
