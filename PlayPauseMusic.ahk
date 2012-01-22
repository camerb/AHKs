#include FcnLib.ahk
#include FcnLib-Opera.ahk

params=%1%

if InStr(params, "resumeLastFm")
{
   Process, Close, opera.exe
   SleepSeconds(10)
   ;BlockInput, On
   RunOpera()
   ;url=http://www.last.fm/listen/user/cameronbaustian/personal
   ;WinShow, Opera

   ;recent replacement
   ;GoToPage(url)
   ;ForceWinFocus("Opera")
   ForceWinFocus("Last.fm - Opera")
   ;SendInput, !d
   ;Sleep, 100
   ;SendInput, %url%{ENTER}
   ;Sleep, 100

   Send, ^!5
   ;BlockInput, Off
   ExitApp
}

SetTitleMatchMode, RegEx
DetectHiddenWindows, On

titletext := WinGetTitle("ahk_class OperaWindowClass")
Process, Exist, foobar2000.exe
FoobarPID := ERRORLEVEL
Process, Exist, opera.exe
OperaPID := ERRORLEVEL

;PowerIsStreamingInWMP:=WinExist("Windows Media Player") ;FIXME this seems buggy
if (titletext=="106.1 KISS FM - Opera" or titletext=="Mix 102.9 Stream - Opera"
      or titletext=="89.7 Power FM - Powered by ChristianNetcast.com - Opera"
      or titletext=="http://www.christiannetcast.com/listen/dynamicasx.asp?station=kvtt-fm2 - Opera"
      or InStr(titletext, "Last.fm"))
{
   ;Stop music
   ForceWinFocus(titletext, "Contains")
   Sleep, 100
   SendInput, !dhttp://www.google.com/{enter}
   Sleep, 100
}
else if (FoobarPID)
{
   SetTitleMatchMode, 2
   DetectHiddenWindows, On
   WinRestore, foobar2000
   if ForceWinFocusIfExist("^foobar2000", "RegEx")
   {
      Sleep, 1000
      ;this will play
      Send, {ALT}pl
   }
   if ForceWinFocusIfExist("^.+foobar2000", "RegEx")
   {
      Sleep, 1000
      ;this will stop it
      Send, {ALT}ps
   }
}
else if (PowerIsStreamingInWMP)
{
   ;WinClose, Windows Media Player

   ProcessCloseAll("wmplayer.exe")
}
else
{
   InputBox, bookmark, Choose Station, Choose which station you'd like to play

   ;default station
   if (bookmark == "")
      bookmark:="last"

   if (InStr(bookmark, "NPR"))
   {
      Run, C:\Dropbox\Programs\npr.m3u
      ForceWinFocus("Windows Media Player")
      WinMinimize, Windows Media Player
      SleepSeconds(10)
      WinClose, Windows Media Player
      return
   }

   if (InStr(bookmark, "Power"))
   {
      Run, http://www.christiannetcast.com/listen/dynamicasx.asp?station=897power-fm
      return
   }

   ;Ok, all other possibilities have been taken care of,
   ;this has got to be a webpage that we are going to launch
   IfWinNotExist, ahk_class OperaWindowClass
   {
      operaPath:=ProgramFilesDir("\Opera\opera.exe")
      Run, %operaPath%
   }

   ;WinShow, ahk_class OperaWindowClass
   Sleep, 2000

   if (InStr(bookmark, "Rec"))
      url=http://www.last.fm/listen/user/cameronbaustian/recommended
   else if (InStr(bookmark, "Last"))
      url=http://www.last.fm/listen/user/cameronbaustian/personal
   else if (InStr(bookmark, "Pan"))
      url=http://www.pandora.com/
   else if (InStr(bookmark, "Kiss"))
      url=http://www.1061kissfm.com/mediaplayer/?station=KHKS-FM&action=listenlive&channel_title=
   else if (InStr(bookmark, "Mix"))
      url=http://www.mix1029.com/mediaplayer/?station=KDMX-FM&action=listenlive&channel_title=
   else
   {
      debug("what? I'm not sure what station you meant")
      Reload
   }
   ;else if (InStr(bookmark, "Wilder"))

   ;debug("no media player detected... launching power fm")
   ;TODO model the other sections after this one... maybe make a function GoToURL(url, browser)
   ForceWinFocus("ahk_class (OpWindow|OperaWindowClass)", "RegEx")
   Loop
   {
      Sleep, 100
      WinGetActiveTitle, titletext
      Sleep, 100
      Send, ^{TAB}
      Sleep, 100
      WinGetActiveTitle, titletextnew
      Sleep, 100
      if (titletext == titletextnew)
         break
      Sleep, 100
      Send, ^w
      Sleep, 100
   }
   ;debug()
   Sleep, 100
   SendInput, !d
   Sleep, 100
   SendInput, %url%{ENTER}
   Sleep, 100

;http://www.1061kissfm.com/mediaplayer/?station=KHKS-FM&action=listenlive&channel_title=
;http://www.mix1029.com/mediaplayer/?station=KDMX-FM&action=listenlive&channel_title=
;http://66.228.115.186/listen/player.asp?station=897power-fm&
;http://www.christiannetcast.com/listen/dynamicasx.asp?station=kvtt-fm2
}
Send, ^!5
;WinMinimize
;WinHide
SleepSeconds(120)
