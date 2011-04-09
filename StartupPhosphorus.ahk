#include FcnLib.ahk

A_Debug:=true

;TODO exitapp if we are re-logging in (instead of booting up)

;Run, %windir%\system32\cmd.exe
;Run, "C:\Program Files (x86)\Opera\opera.exe"
RunProgram("C:\Program Files (x86)\Mozilla Firefox\firefox.exe")
RunProgram("C:\Program Files (x86)\PostgreSQL\8.4\bin\pgAdmin3.exe")
RunProgram("C:\Program Files (x86)\foobar2000\foobar2000.exe")
RunProgram("C:\My Dropbox\Programs\BareTail\baretail.exe")

;Sleep, 15000

Run, "C:\Program Files (x86)\Vim\vim72\gvim.exe"
ForceWinFocus("GVIM", "Contains")
Send, {F2}
Send, ^w{RIGHT}{;}q{ENTER}
Send, {;}BookmarkToRoot code{ENTER}

ForceWinFocus("Mozilla Firefox")
Send, ^!2

ForceWinFocus("GVIM", "Contains")
Send, ^!2

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
Send, ^w{RIGHT}{;}q{ENTER}
Send, {;}BookmarkToRoot ahks{ENTER}

debug("Launching Irssi")
RunWait, LaunchIrssi.ahk

RunAhk("LaunchVM.ahk")
ForceWinFocus("ahk_class VMPlayerFrame")
SleepSeconds(2)
ForceWinFocus("ahk_class VMPlayerFrame")
Send, ^!5

;ForceWinFocus("ahk_class VMPlayerFrame")
;file=images\vmware\phosphorusVmButton.bmp
;WaitForImageSearch(file)
;ClickIfImageSearch(file)
;Click
;Send, ^!5

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

;ForceWinFocus("ahk_class gdkWindowToplevel")
;Sleep, 100
;Send, ^!a
;NOTE I commented this line because it is already being shown on all screens in the launch pidgin script

if desktopSidebarNeedsRelocating()
   moveDesktopSidebar()

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

while desktopSidebarNeedsRelocating()
{
   moveDesktopSidebar()
   SleepSeconds(1)
}

debug("All finished with the boot AHK")
ExitApp

desktopSidebarNeedsRelocating()
{
   debug("checking desktop sidebar position")
   WinGetPos, xPos, no, no, winHeight, ahk_class SideBarWndv10
   ;debug(xpos, winheight)
   if (xPos < 2500)
      return true
   return false
}

moveDesktopSidebar()
{
   debug("moving desktop sidebar")
   WinActivate, ahk_class SideBarWndv10
   ;TODO figure out a way to ensure that the sidebar is actually responding to WinActivate
   Click(20, winHeight - 20, "Right")
   Sleep, 100
   Send, {DOWN 2}{ENTER}

   WinWaitActive, Options, , 10
   if NOT errorLevel
   {
      ;messWithOptionsForDesktopSidebar()
      WinWaitActive, Options
      ;ForceWinFocus("Options")
      Click(95,  41)
      Sleep, 100
      Click(390,  249)
      Sleep, 100
      Click(401,  279)
      Sleep, 100
      Click(239,  553)
      Sleep, 100
      ;debug()
   }
}
