#include FcnLib.ahk

A_Debug:=true

;Run, %windir%\system32\cmd.exe
Run, "C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
;Run, "C:\Program Files (x86)\Opera\opera.exe"
Run, "C:\Program Files (x86)\PostgreSQL\8.4\bin\pgAdmin3.exe"
Run, "C:\Program Files (x86)\foobar2000\foobar2000.exe"
Run, "C:\My Dropbox\Programs\baretail.exe"
Run, "C:\Program Files (x86)\VMware\VMware Player\vmplayer.exe"

;Sleep, 15000

Run, "C:\Program Files (x86)\Vim\vim72\gvim.exe"
ForceWinFocus("GVIM", "Contains")
Send, {F2}
Send, {;}
Send, BookmarkToRoot code{ENTER}

ForceWinFocus("Mozilla Firefox")
Send, ^!2

ForceWinFocus("GVIM", "Contains")
Send, ^!2

ForceWinFocus("ahk_class gdkWindowToplevel")
Sleep, 100
Send, ^!a

ForceWinFocus("BareTail", "Contains")
Send, ^!a

;ForceWinFocus("Opera", "Contains")
;Send, ^!a
;Sleep, 100
;Send, !d
;Sleep, 100
;SendInput, http://www.last.fm/listen/user/cameronbaustian/personal{ENTER}
;Sleep, 100
;WinMinimize

ForceWinFocus("pgAdmin III ahk_class wxWindowClassNR", "Contains")
Sleep, 100
Send, ^!{NUMPAD6}
Sleep, 100
Send, ^!{RIGHT}
Sleep, 100
Send, ^!3

Run, "C:\Program Files (x86)\Vim\vim72\gvim.exe"
ForceWinFocus("GVIM", "Contains")
Send, {F2}
Send, {;}
Send, BookmarkToRoot ahks{ENTER}

debug("Launching Irssi")
RunWait, LaunchIrssi.ahk

ForceWinFocus("ahk_class VMPlayerFrame")
file=images\vmware\phosphorusVmButton.bmp
WaitForImageSearch(file)
ClickIfImageSearch(file)
Click
Send, ^!5

Sleep, 10000

;delay these til the os has started up fully
debug("starting quirky programs")
Send, #1
Send, #2
Send, #3
Run, "C:\Program Files (x86)\Pidgin\pidgin.exe"
Send, #4
Send, #5

ForceWinFocus("Administrator: Command Prompt", "Exact")
Send, ^!a

ForceWinFocus("Irssi", "Contains")
Send, ^!a

ForceWinFocus("MINGW32 ahk_class ConsoleWindowClass", "Contains")
Send, cd C:/code/epms{ENTER}
Send, git status{ENTER}
Send, ^!a

debug("Launching Pidgin")
RunWait, LaunchPidgin.ahk

debug("Running ArrangeWindows script for all screens")
Loop 5
{
   RunWait, ArrangeWindows.ahk
   Send, {BROWSER_FORWARD}
}

Loop 5
   Send, {BROWSER_BACK}

SetNumLockState, On
SetScrollLockState, On
SetCapsLockState, Off

debug("All finished with the boot AHK")
