#IfWinActive Confluence ahk_class Chrome_WindowImpl_0
^s::
#IfWinActive Confluence ahk_class Chrome_WidgetWin_0
^s::
;debug("hi")
;Maybe we should page up to the top of the screen, but maybe not needed
ClickIfImageSearch("images\confluence\ConfluenceSaveButton.bmp", "Control")
ClickIfImageSearch("images\confluence\ConfluenceSaveButtonXP.bmp", "Control")

;Wait for webpage to load
Sleep, 2000

ClickIfImageSearch("images\confluence\ConfluenceOverwriteButton.bmp", "Control")
ClickIfImageSearch("images\confluence\ConfluenceOverwriteButtonXP.bmp", "Control")
return
#IfWinActive ;End Confluence

#IfWinActive JIRA ahk_class Chrome_WindowImpl_0
!s::
#IfWinActive JIRA ahk_class Chrome_WidgetWin_0
!s::
Send, {PGDN 4}
ClickIfImageSearch("images\jira\UpdateButton.bmp", "Control")
return
#IfWinActive ;end jira

/*
;FIXME Seems that this never happens (so copy/paste doesn't work in cmd prompt (admin mode)
;NOTE seems to happen all the time now... going to disable this
;#IfWinActive Administrator: Command Prompt ahk_class ConsoleWindowClass
;d:: errord("Admin command prompt detected", "this never seems to happen", "check the logs and attempt to reproduce", "maybe you only have one cmd window open and that's why it worked")
;#IfWinActive
*/

#IfWinActive ahk_class ConsoleWindowClass
;#IfWinActive Administrator: Command Prompt ahk_class ConsoleWindowClass
;#IfWinActive C:\Windows\system32\cmd.exe ahk_class ConsoleWindowClass
^c::
WinGetActiveTitle, title
if title contains perl
{
   Send, ^c
}
else
{
   MouseClick, right, 100, 100
   Send, {DOWN 4}{ENTER}
   Sleep 100
   Send, {ENTER}
}
return

^v::
SendInput {Raw}%clipboard%
;MouseClick, right, 100, 100
;Send, {DOWN 3}{ENTER}
return

PGUP:: SendInput, {WHEELUP 10}
PGDN:: SendInput, {WHEELDOWN 10}
#IfWinActive ;End ahk_class ConsoleWindowClass

#IfWinActive pgAdmin III ahk_class wxWindowClassNR
d::
Loop 10
{
   ;SendMode, Play
   ForceWinFocus("pgAdmin III ahk_class wxWindowClassNR")
   OpenConnectionExists := ClickIfImageSearch("images\pgAdmin\OpenDbConnection.bmp", "Right")
   if NOT OpenConnectionExists
      return
   WaitForImageSearch("images\pgAdmin\Disconnect.bmp")
   ClickIfImageSearch("images\pgAdmin\Disconnect.bmp")
   ;SendMode, Event
}
return
o::
ClickIfImageSearch("images\pgAdmin\ViewDataInTable.bmp", "Control")
ForceWinFocus("pgAdmin III ahk_class wxWindowClassNR")
;MouseMove, 0, -10, , r
return
j:: Send, {DOWN}
k:: Send, {UP}
;Select All
^a::
SendInput {Home}
SendInput ^+{End}
return
#IfWinActive ;End pgAdmin III ahk_class wxWindowClassNR

;Part of pgAdmin (windows were created by pgAdmin but don't have it in the title
#IfWinActive (Maintain|Backup|Restore) Database ahk_class #32770
^a::
SendInput ^{Home}
SendInput ^+{End}
return
#IfWinActive ;end Restore Database ahk_class #32770

#IfWinActive Active Window Info \(Shift-Alt-Tab to freeze display\) ahk_class AU3Reveal
;Select All
^a::
SendInput ^{Home}
SendInput ^+{End}
return
#IfWinActive ;end Active Window Info (Shift-Alt-Tab to freeze display) ahk_class AU3Reveal

#IfWinActive AutoScriptWriter II - \( by Larry Keys \)
;Select All
^a::
SendInput ^{Home}
SendInput ^+{End}
return
#IfWinActive ;end AutoScriptWriter II - ( by Larry Keys )

#IfWinActive .*Perforce P4Merge ahk_class QWidget
;Previous diff
^UP:: Send, ^1

;Next diff
^DOWN:: Send, ^2
#IfWinActive ;end Perforce P4Merge ahk_class QWidget

;{{{ Hotkeys to make svn commits easier
#IfWinActive .*\..* - TortoiseMerge
^SPACE::
^ENTER::
#IfWinActive Commit - C:\\.* ahk_class #32770
^SPACE::
^ENTER::
ENTER:: ;this keeps me from accidentally committing by hitting enter
parentWin=Commit - C:\\.* ahk_class #32770
diffWin=.*\..* - TortoiseMerge
ForceWinFocus(parentWin, "RegEx")
Send, {SPACE}
return
#IfWinActive

#IfWinActive Log Messages - C:\\.* ahk_class #32770
^LEFT::
#IfWinActive Commit - C:\\.* ahk_class #32770
^LEFT::
#IfWinActive .*\..* - TortoiseMerge
^LEFT::
parentWin=Commit - C:\\.* ahk_class #32770
diffWin=.*\..* - TortoiseMerge
parentWin2=Log Messages - C:\\.* ahk_class #32770
ForceWinFocusIfExist(parentWin, "RegEx")
ForceWinFocusIfExist(parentWin2, "RegEx")
Send, {UP}{ENTER}
return
#IfWinActive

#IfWinActive Log Messages - C:\\.* ahk_class #32770
^RIGHT::
#IfWinActive Commit - C:\\.* ahk_class #32770
^RIGHT::
#IfWinActive .*\..* - TortoiseMerge
^RIGHT::
parentWin=Commit - C:\\.* ahk_class #32770
diffWin=.*\..* - TortoiseMerge
parentWin2=Log Messages - C:\\.* ahk_class #32770
ForceWinFocusIfExist(parentWin, "RegEx")
ForceWinFocusIfExist(parentWin2, "RegEx")
Send, {DOWN}{ENTER}
return
#IfWinActive

#IfWinActive Log Messages - C:\\.* ahk_class #32770
^UP::
#IfWinActive Commit - C:\\.* ahk_class #32770
^UP::
parentWin=Commit - C:\\.* ahk_class #32770
diffWin=.*\..* - TortoiseMerge
ForceWinFocus(diffWin, "RegEx")
Send, ^{UP}
return
#IfWinActive

#IfWinActive Log Messages - C:\\.* ahk_class #32770
^DOWN::
#IfWinActive Commit - C:\\.* ahk_class #32770
^DOWN::
parentWin=Commit - C:\\.* ahk_class #32770
diffWin=.*\..* - TortoiseMerge
ForceWinFocus(diffWin, "RegEx")
Send, ^{DOWN}
return
#IfWinActive
;}}}

;{{{ Easily start a new IM
#IfWinActive ahk_class gdkWindowToplevel
;only if it doesn't contain "Buddy List"
;#IfWinActive Buddy List ahk_class gdkWindowToplevel
^m::
person := Prompt("Who would you like to IM?")
if (person=="") return

if (InStr(person, "mel"))
   person=Melinda
if (InStr(person, "nat"))
   person=Nathan Dyck

ForceWinFocus("ahk_class gdkWindowToplevel")
SendInput, ^m
WinWaitActive, Pidgin
SendInput, %person%
Sleep, 1000
SendInput, {DOWN}{ENTER 2}
return
#IfWinActive
;}}}

#IfWinActive ahk_class Vim
^z::
Send, {ESC 6}u
return

;^v::
;SendMode, Play
;Click(100, 100, "Right Control")
;ClickIfImageSearch("images\vim\MenuPaste.bmp")
;Sleep, 100
;ClickIfImageSearch("images\vim\MenuPaste.bmp")
;SendMode, Event
;return
#IfWinActive ;end Vim

#IfWinActive Irssi ahk_class PuTTY
^g:: Run, %Clipboard%
#IfWinActive

#IfWinActive Microsoft SQL Server Management Studio ahk_class wndclass_desked_gsk
^n::
if ClickIfImageSearch("images\ssms\DropdownDefaultSelected.bmp")
{
   Sleep, 200
   ClickIfImageSearch("images\ssms\EpmsDb.bmp")
   Sleep, 100
}
ClickIfImageSearch("images\ssms\NewQueryButton.bmp")
Sleep, 900
if ClickIfImageSearch("images\ssms\DropdownDefaultSelected.bmp")
{
   Sleep, 200
   ClickIfImageSearch("images\ssms\EpmsDb.bmp")
   Sleep, 100
}
return
#IfWinActive
