;{{{ Confluence
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
;}}}

;{{{ JIRA
#IfWinActive JIRA ahk_class Chrome_WindowImpl_0
!s::
#IfWinActive JIRA ahk_class Chrome_WidgetWin_0
!s::
Send, {PGDN 4}
ClickIfImageSearch("images\jira\UpdateButton.bmp", "Control")
return
#IfWinActive ;end jira
;}}}

;{{{ Cmd console
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
if RegExMatch(title, "(perl|plackup)")
   Send, ^c
else
   CommandPromptCopy()
return

^v::
SendInput {Raw}%clipboard%
;MouseClick, right, 100, 100
;Send, {DOWN 3}{ENTER}
return

;for some reason you can't scroll up with the mousewheel in git (MINGW32)
PGUP:: SendInput, {WHEELUP 10}
PGDN:: SendInput, {WHEELDOWN 10}
#IfWinActive ;End ahk_class ConsoleWindowClass
;}}}

;{{{ Git
;#IfWinActive MINGW32
/*
PGUP:: SendInput, {WHEELUP 10}
PGDN:: SendInput, {WHEELDOWN 10}
*/
;#IfWinActive ;End ahk_class ConsoleWindowClass
;}}}

;{{{ pgAdmin
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
;}}}

;{{{ Window Spy
#IfWinActive Active Window Info \(Shift-Alt-Tab to freeze display\) ahk_class AU3Reveal
;Select All
^a::
SendInput ^{Home}
SendInput ^+{End}
return
#IfWinActive ;end Active Window Info (Shift-Alt-Tab to freeze display) ahk_class AU3Reveal
;}}}

;{{{ ScriptWriter
#IfWinActive AutoScriptWriter II - \( by Larry Keys \)
;Select All
^a::
SendInput ^{Home}
SendInput ^+{End}
return
#IfWinActive ;end AutoScriptWriter II - ( by Larry Keys )
;}}}

;{{{ Perforce
#IfWinActive .*Perforce P4Merge ahk_class QWidget
;Previous diff
^UP:: Send, ^1

;Next diff
^DOWN:: Send, ^2
#IfWinActive ;end Perforce P4Merge ahk_class QWidget
;}}}

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

;{{{Pidgin Easily start a new IM
#IfWinActive ahk_class gdkWindowToplevel
;only if it doesn't contain "Buddy List"
;#IfWinActive Buddy List ahk_class gdkWindowToplevel
^m::
person := Prompt("Who would you like to IM?")
if (person=="") return

;TODO putting emails in would be the fastest way, but I don't want to put a mapping in the code
;TODO maybe we could scan the pidgin folder and find the mapping in an ini?
if InStr(person, "mel")
   person=Melinda
if InStr(person, "nat")
   person=Nathan Dyck
if InStr(person, "c4")
   person=c-4
   ;person=absinthe.10.6@gmail.com

ForceWinFocus("ahk_class gdkWindowToplevel")
SendInput, ^m
WinWaitActive, Pidgin
SendInput, %person%

;FIXME ugly, and did I mention: ugly
Sleep, 1000

SendInput, {DOWN}{ENTER 2}
return

^w::
;don't kill chat windows accidentally with hotkeys
return

^v::
;don't paste into irc or gchat - experiment to see the habits i have with pidgin
return
#IfWinActive
;}}}

;{{{ Vim
#IfWinActive ahk_class Vim

;remap undo
^z:: Send, {ESC 6}u

;stop me from changing the color scheme accidentally
F8::return

#IfWinActive ;end Vim
;}}}

;{{{ Irssi
#IfWinActive Irssi ahk_class PuTTY
^g::
Run, %Clipboard%
return
#IfWinActive
;}}}

;{{{ SSMS
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
;}}}

;{{{ MSPaint
#IfWinActive ahk_class MSPaintApp
NumpadMult::
if (GetOS() == "WIN_7")
   Send, ^+x
else
   Send, ^x^e1{TAB}1{ENTER}^v
return

NumpadAdd::
if (GetOS() == "WIN_7")
   Send, ^{PGUP}
else
   Send, {ALT}vzu6{ENTER}
return

NumpadSub::
if (GetOS() == "WIN_7")
   Send, ^{PGDN}
else
   Send, ^{PGUP}
return
#IfWinActive
;}}}

;{{{ Windows Live Movie Maker
#IfWinActive Windows Live Movie Maker
NUMPADDIV::
Click(452, 44, "left")
Click(452, 76, "left")
return
#IfWinActive
;}}}

;{{{EF Commander
#IfWinActive ahk_class EF Commander
;kill stupid hotkeys that mean different things
F5::return
#IfWinActive
;}}}

;{{{EPMS stuff for Melinda
#IfWinActive EPMS Shop
;#IfWinActive Mozilla Firefox
^+e::
SendInput, {CTRL UP}{SHIFT UP}Executive Summary, Question 3: Based on the Leasing Professional's presentation, would you have leased this apartment? Why or Why Not? Please answer based on the presentation only, not on the apartment or community.
return
#IfWinActive
;}}}

;{{{AHK Forum quick replies
#IfWinActive (Post a reply|Edit post)
:*:!tutorial::Sure, you can do that with AHK... have you checked out the tutorial? http://www.autohotkey.com/docs/Tutorial.htm{ENTER}{ENTER}By the way, when you're reading through the tutorial, do not just gloss over it... instead: try all of the examples, run them, tweak them, and experiment with it. After all, the purpose of the tutorial is for you to be doing the examples as you're reading... it isn't just a quick read.
:*:!codetags::Use [/code] tags when you're pasting code into the forums.
:*:!cycle::Masterfocus made a nifty function called Cycle() that should fix your problem. Check this out:{ENTER}http://www.autohotkey.com/forum/viewtopic.php?p=388494#p388494
:*:!ocr::You may want to check out Optical Character Recognition (OCR.ahk):{ENTER}http://www.autohotkey.com/forum/topic74227.html
:*:!game::Not all applications listen for input on default SendModes, games are especially notorious for this. I would test sending the input with each of the four sendmodes, to see which SendMode successfully sends input to the application.  `nhttp://www.autohotkey.com/docs/commands/SendMode.htm `n`nAlso, there are a couple of other issues that can affect games, so be sure to check the games FAQ if that doesn't work: `nhttp://www.autohotkey.com/docs/FAQ.htm{#}games
:*:!autofire::Ah, you want to check out 'The definitive autofire thread!'`n`n http://www.autohotkey.com/forum/viewtopic.php?t=69474


;perhaps I should write an article and put a link to it in here
:*:!details::Please give use more details to help diagnose your problem... simply saying that it "doesn't work" doesn't help at all.
#IfWinActive
;}}}

;FIXME - should work in forums, pastebins, notepad, gvim... etc...
;pastebin!!!
:*:!pseudocode::;DISCLAIMER: this is totally pseudocode, written by camerb... you'll need to fix this so that commands work (because this certainly will not run as it is currently), but I think I made things pretty clear, so you can fix it up as you'd like it

;{{{AHK in Vim hotstrings
#IfWinActive ahk.* ahk_class Vim
:*:!debug::A_LineNumber, A_ScriptName, A_ThisFunc, A_ThisLabel,
:*:!date::
date := CurrentTime("hyphendate")
SendInput %A_Space%
SendInput {;}
SendInput (changed on %date%)
return
#IfWinActive
;}}}

;{{{ Sugar
#IfWinActive Mitsi - Google Chrome
:*:!s::
date := CurrentTime("slashdate")
SendInput %A_Space%- CB %date%
return
#IfWinActive
;}}}

;{{{ Emails to Lynx Customers
#IfWinActive Write.* ahk_class MozillaWindowClass

;TODO it would be really neat to have an AppsKey+? box for Thunderbird, so that I could remember all my hotstrings
:*:!updated::
text=The LynxGuide server update is complete and your server is back online. In addition, we have tested the server to ensure that it is processing alarms correctly. Feel free to contact Lynx Technical Support if you have any questions regarding the update or the new version of the LynxGuide Server software.`n`nRegards,
SendInput %text%
Send, !s!aLynxGuide Server Update Complete
return

:*:!contact info::
text=Here is my contact information for future reference. Feel free to give me a call any time if you have questions about the Lynx system.`n`nThanks,
SendInput %text%
Send, !s!aLynx Contact Information
return

:*:!address::
text=Our shipping address is below:`n`nMicro Technology Services, Inc.`nATTN: Lynx Department`n1819 Firman Drive`nSuite 137`nRichardson, TX 75081
SendInput %text%
return

:*:!call::
text=Please give Lynx Technical Support a call at (888) 230-6874 x140 if you have any questions.
SendInput %text%
return

:*:!phone::
text=(888) 230-6874 x140
SendInput %text%
return

:*:!push9::
serverName := Prompt("What is the server name for the push?")
profileName := Prompt("What is the profile name for the push?")

text=As we discussed over the phone, the process for moving to the latest version of LynxKeyPro will require an SCCM push, which can be performed whenever it is convenient for you. I would highly recommend performing this pushout on a small pilot group of nearby computers first, to ensure that the pushout goes according to plan.`n`nFresh Installations:`nYou will need to copy the file from the following path on the LynxGuide server to a network shared location.`n\\%ServerName%\c$\inetpub\wwwroot\ClientUpdates\LynxClient_vX.X.X.X.msi`n`nThen, you will have to perform the command to install the client using MSIEXEC`nmsiexec.exe /I "\\NETWORK-SHARED-LOCATION\LynxClient_vX.X.X.X.msi" LYNXSERVERHOSTNAME="%ServerName%" PROFILE="%ProfileName%" /quiet`n`nUpgrading Existing Clients:`nYou will need to copy the file from the following path on the LynxGuide server to a network shared location.`n\\%ServerName%\c$\inetpub\wwwroot\_TrueUpdate\LKPPatcher.exe`n`nThis command line string needs to be executed to perform the upgrade. Keep in mind, the two switches that are provided are used to ensure that the correct settings are placed in the new version of LynxKeyPro. In addition, this executable will seamlessly uninstall the old version of LynxKeyPro and install the new version of LynxKeyPro, with the correct settings.`n\\NETWORK-SHARED-LOCATION\LKPPatcher.exe server="%ServerName%" profile="%ProfileName%"`n`nIn addition, the pushout requires that the client machine is rebooted after the installation, in order for the new version of the client to function properly.`n`nI've attached the manual for this new version of the client software. Feel free to call in to Lynx Technical Support to discuss this over the phone. I am definitely willing to work with you to ensure that this gets pushed out correctly the first time. Call any time from 8am to 5pm Central Time, and ask for Cameron.
;SendInput %text%
SendViaClipboard(text)
return

;TODO virtual specs
;TODO sms failed... here's how we can re-enable it
;TODO email failed, here's how we can re-enable it
#IfWinActive
;}}}

;{{{ Re-tag Thunderbird inbox
#IfWinActive .*@mitsi.com - Mozilla Thunderbird ahk_class MozillaWindowClass
~::
)::
Send, {APPSKEY}g0
return

+1::
+2::
+3::
+4::
+5::
+6::
+7::
+8::
RegExMatch(A_ThisHotkey, ".$", match)
Send, {APPSKEY}g%match%
return
#IfWinActive
;}}}

;{{{ experimental stuff so that I can make an exit hotkey for iracing
:*:iracing::
MouseGetPos, outX, outY
msg=X: %outx%`nY: %outy%`nthese coordinates should be the coords for the quit button in iracing
QuickFileOutput(msg)
return
;}}}
