;NOTE Ok, so this is awfully ghetto at the moment. Right now this uses Desktop Sidebar
; with the "Capture Panel" widget to capture and display this AHK GUI as a widget
;TODO Someday I need to make an actual C# widget for Desktop Sidebar
; and get rid of the Capture Panel/AHK GUI combo that you see here

#include FcnLib.ahk

;Run, TestRemoteWidget.ahk
guiTitle=%A_ScriptName% ahk_class AutoHotkeyGUI
joe:=SexPanther()
CamGmailUrl=https://cameronbaustian:%joe%@gmail.google.com/gmail/feed/atom
joe:=SexPanther("melinda")
MelGmailUrl=https://melindabaustian:%joe%@gmail.google.com/gmail/feed/atom

Gui:
   Gui, +ToolWindow -Caption
   Gui, Color, , 000022
   Gui, font, s7 cCCCCEE,
   ;Gui, font, , Courier New
   Gui, font, , Verdana
   ;Gui, font, , Arial
   ;Gui, font, , Consolas
   Gui, Margin, 0, 0
   Gui, Add, ListView, r20 w147 -Hdr, Text
   Gui, Show
   WinMove, %guiTitle%, , , , 200, 200
   Loop
   {
      entireMessage:=urldownloadtovar("http://dl.dropbox.com/u/789954/remotewidget.txt")
      if (A_ComputerName=="PHOSPHORUS")
         entireMessage.=urldownloadtovar("http://dl.dropbox.com/u/789954/remotewidget-livesitemode.txt")
      entireMessage.=GetGmailMessageCount(MelGmailUrl, "Melinda")
      entireMessage.=GetGmailMessageCount(CamGmailUrl, "Cameron")
      LV_Delete()
      Loop, parse, entireMessage, `r`n
      {
         if NOT A_LoopField == ""
            LV_Add("", A_LoopField)
      }
      SleepSeconds(30)
   }
Return

;TODO do i really want to do this? -- scope!!!
;didn't really need to make this a function
; but it was getting a bit congested up there
;GetWidgetText()
;{
;}

GetGmailMessageCount(url, prettyName)
{
   gmailPage:=urldownloadtovar(url)
   RegExMatch(gmailPage, "<fullcount>(\d+)</fullcount>", gmailPage)
   RegExMatch(gmailPage, "\d+", number)

   if (number == 0)
      return ""
   returned=%prettyName% has %number% new emails`n
   return returned
}
