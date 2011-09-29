#include FcnLib.ahk
#include thirdParty/cmdret.ahk
#NoTrayIcon

;Run, TestRemoteWidget.ahk
guiTitle=%A_ScriptName% ahk_class AutoHotkeyGUI
joe:=SexPanther()
CamGmailUrl=https://cameronbaustian:%joe%@gmail.google.com/gmail/feed/atom
joe:=SexPanther("melinda")
MelGmailUrl=https://melindabaustian:%joe%@gmail.google.com/gmail/feed/atom

if (A_ComputerName == "PHOSPHORUS")
{
   widgetX := 3689
   widgetY := 623
}
else if (A_ComputerName == "BAUSTIAN-09PC")
{
   ;TODO figure out the position for the widget
   widgetX := 1771
   widgetY := 319
}

Gui, +ToolWindow -Caption
Gui, Color, , 000022
Gui, font, s7 cCCCCEE,
Gui, font, , Verdana
Gui, Margin, 0, 0
Gui, Add, ListView, r10 w149 -Hdr, Text
Gui, Show
;WinMove, %guiTitle%, , , , 149, 200
;Gui, Show, , %widgetX%, %widgetY%, 170, 200
;Gui, Show, , %widgetX%, %widgetY%, 170, 200
WinMove, %guiTitle%, , %widgetX%, %widgetY%

;continue to refresh the widget
Loop
{
   lastEntireMessage:=entireMessage
   entireMessage:=GetWidgetText()
   ;entireMessage:="hi" ;to test when internet sucks
   ;addtotrace(entireMessage)

   ;if a change in the text has taken place, repaint
   ;(else: don't bother cause it flickers)
   if (entireMessage <> lastEntireMessage)
   {
      LV_Delete()
      Loop, parse, entireMessage, `r`n
      {
         if NOT A_LoopField == ""
            LV_Add("", A_LoopField)
      }
   }

   ;wait between updates, unless if currently messing with gmail in browser
   ;  this will make it more up-to-date if we're reading emails right now
   Loop 1
   {
      if InStr(WinGetActiveTitle(), "Gmail")
         fastRefresh:=true
      if InternetWasDown
         fastRefresh:=true
      if fastRefresh
         break
      SleepSeconds(1)
   }
}

;#include thirdParty/winsock2.ahk

;separateThread=temporary9.ahk

;RunAhk(separateThread, "copper.lan.mitsi.com:8096")
;SleepSeconds(1)
;if CloseAhk(separateThread)


;timer:=StartTimer()
;WS2_Socket:=WS2_Connect("copper.lan.mitsi.com:8095")
;result:=WS2_SendData(WS2_Socket, "boogety")
;totalTime:=ElapsedTime(timer)

;timer:=StartTimer()
;result2:=WS2_Connect("copper.lan.mitsi.com:8096")
;totalTime2:=ElapsedTime(timer)

;timer:=StartTimer()
;result2 := QuickPing("http://copper.lan.mitsi.com:8096")
;totalTime2:=ElapsedTime(timer)

;timer:=StartTimer()
;result3 := QuickPing("http://copper.lan.mitsi.com:8028")
;totalTime3:=ElapsedTime(timer)

debug(totaltime, result, totaltime2, result2, totaltime3, result3)

QuickPing(url)
{
   ;hi:=AhkClose("RemoteWidget.ahk")
   ;debug(hi)
   returned := UrlDownloadToVar(url)
   ;debug(returned, url)
   if InStr(returned, "HTML")
      return true
   else
      return false
}

;didn't really need to make this a function
; but it was getting a bit congested up there
GetWidgetText()
{
   timer:=StartTimer()
   returned .= PingPortOnCopper(8095, "crowd")
   returned .= PingPortOnCopper(80,   "conf old")
   returned .= PingPortOnCopper("http://206.190.248.57/secure/Dashboard.jspa", "jira old")

   ;returned .= PingPortOnCopper(8096, "crowd new")
   returned .= PingPortOnCopper(8031, "conf new")
   returned .= PingPortOnCopper(8028, "jira new")
   totalTime:=ElapsedTime(timer)

   returned .= totalTime . "  " . CurrentTime("hh-mm-ss")
   return returned
}

PingPortOnCopper(port, description)
{
   url=http://copper.lan.mitsi.com:%port%
   errorMessage = %port% is down - %description%`n
   if ( StrLen(port) > 4 )
   {
      url:=port
      errorMessage = 80 is down - %description%`n
   }
   if NOT QuickPing(url)
      returned := errorMessage
   return returned
}
