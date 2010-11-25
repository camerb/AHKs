; Example #1: Close unwanted windows (IE8 Security Warning about images from external sites) whenever they appear:
;#Persistent
;SetTimer, CloseSecurityWarnings, 500
;return
;CloseSecurityWarnings:
;IfWinExist, Security Warning;, Do you want to view only the webpage content that was delivered securely?
;{
;	msgbox hi
;	ControlClick, No, Security Warning 
;}
;return

^+q::
WinWait, Choose File to Upload, 
IfWinNotActive, Choose File to Upload, , WinActivate, Choose File to Upload, 
WinWaitActive, Choose File to Upload, 
MouseClick, left,  358,  670
Sleep, 100
Send, {CTRLDOWN}c{CTRLUP}
MouseClick, left,  461,  693
Sleep, 1000
WinWait, CTRL-Panel - Windows Internet Explorer, 
IfWinNotActive, CTRL-Panel - Windows Internet Explorer, , WinActivate, CTRL-Panel - Windows Internet Explorer, 
WinWaitActive, CTRL-Panel - Windows Internet Explorer, 
MouseClick, left,  770,  242
Sleep, 100
Send, {CTRLDOWN}v{CTRLUP}
MouseClick, left,  753,  509
Sleep, 2000
MouseClick, left,  569,  169
Sleep, 500
MouseClick, left,  844,  465

;SendInput {End}{Left}{Del 7}
;Run https://www.teaminhouse.com/cPanel/Projects/projects.aspx?Tab=2&TaskID=4237
return

AppsKey::
Run https://www.teaminhouse.com/cPanel/Projects/
WinActivate ahk_class TTOTAL_CMD
WinActivate ahk_class WindowsForms10.Window.8.app.0.2004eee
WinActivate ahk_class rctrl_renwnd32
ControlClick, X115 Y10, AppBar Bullet 
Sleep 2000
WinActivate https://www.teaminhouse.com/cPanel/Projects/ - Windows Internet Explorer
WinActivate ProjectManager - Windows Internet Explorer
return

;Microsoft Excel Shortcut Keys
#IfWinActive ahk_class XLMAIN
^+c::
SendInput ^x
SendInput ^v
return

;^a::
SendInput ^{Home}
Loop 10
	SendInput ^+{End}
return
#IfWinActive

;Microsoft Word Shortcut Keys
;#IfWinActive ahk_class XLMAIN yes-this does not work yet
;^+c::
;SendInput ^x
;SendInput ^v
;return
;#IfWinActive



#p::
Click 1344,685
Sleep 100
SendInput ^c
Sleep 100
Click 1623,710
Sleep 100
Click 1680,236
Sleep 100
SendInput ^v
Sleep 100
Click 1700,500
return

^+i::
OpenBlankNotepad()
SendInput Hello
;Sleep 1000
;Click 1666,237
;Sleep 1000
;SendInput Hello
;SendInput Hello
;Var1 := 5
;SendInput Var1 is %Var1%
;Var1 := Var1 + 1
;SendInput Var1 is %Var1%
return

^+r::
SendInput ^s
Sleep 50
Reload
return

;Internet Explorer Shortcut Keys for Project Manager
#IfWinActive ahk_class IEFrame
^+l::
ClipOriginal := ClipboardAll
SendInput ^c
ClipWait,1

SendInput ^k
Sleep 1500
SendInput ^a
SendInput https://www.teaminhouse.com/cPanel/Projects/projects.aspx?Tab=1&TaskID=
SendInput ^v
SendInput {Tab 7}{Enter}
ClipBoard := ClipOriginal ; returns original clipboard contents
return
#IfWinActive

;########################################################

;Ctrl+Alt+C - demonstrate GetSelectedText method
^!c::
OpenBlankNotepad()
SendInput The text on the clipboard was:
SendInput ^v
SendInput {Enter}
SendInput {Alt}{Tab}
SelectedTextVariable := GetSelectedText()
SendInput {Alt}{Tab}
SendInput The selected text was:
SendInput SelectedTextVariable
SendInput {Enter}
SendInput The text on the clipboard now is:
SendInput ^v
SendInput {Enter}
return

;This will attempt to get the text that is currently selected ("highlighted")
GetSelectedText()
{
OriginalClipboardText := ClipboardAll
SendInput ^c
ClipWait 1
SendInput ^k
SendInput ^a
SendInput https://www.teaminhouse.com/cPanel/Projects/projects.aspx?Tab=1&TaskID=
SendInput ^v
SendInput {Tab 7}{Enter}
ClipBoard := OriginalClipboardText ; returns original clipboard contents
return SelectedText
}

OpenBlankNotepad() ;this will open a new session of notepad if not already opened
;if it is already opened, it will page down to the end of the file to start typing
;(without clearing the existing text)
{
;DetectHiddenWindows on
IfWinExist Untitled - Notepad
{
	WinActivate Untitled - Notepad
	SendInput ^{End}{Enter 2}
}
else
	Run Notepad
return
}