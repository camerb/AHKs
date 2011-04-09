;NOTE Ok, so this is awfully ghetto at the moment. Right now this uses Desktop Sidebar
; with the "Capture Panel" widget to capture and display this AHK GUI as a widget
;TODO Someday I need to make an actual C# widget for Desktop Sidebar
; and get rid of the Capture Panel/AHK GUI combo that you see here

#include FcnLib.ahk
#NoTrayIcon

;Run, TestRemoteWidget.ahk
guiTitle=%A_ScriptName% ahk_class AutoHotkeyGUI
joe:=SexPanther()
CamGmailUrl=https://cameronbaustian:%joe%@gmail.google.com/gmail/feed/atom
joe:=SexPanther("melinda")
MelGmailUrl=https://melindabaustian:%joe%@gmail.google.com/gmail/feed/atom

;Gui:
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
      lastEntireMessage:=entireMessage
      entireMessage:=GetWidgetText()

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
      ;  this will make it more accurate if we're reading emails right now
      Loop 30
      {
         if InStr(WinGetActiveTitle(), "Gmail")
            break
         SleepSeconds(1)
      }
   }
;Return

;didn't really need to make this a function
; but it was getting a bit congested up there
GetWidgetText()
{
   global CamGmailUrl
   global MelGmailUrl

   returned.=urldownloadtovarcheck500("http://dl.dropbox.com/u/789954/remotewidget.txt")
   if (A_ComputerName == "PHOSPHORUS")
      returned.=urldownloadtovarcheck500("http://dl.dropbox.com/u/789954/remotewidget-livesitemode.txt")
   returned.=GetGmailMessageCount(CamGmailUrl, "Cameron")
   if (A_ComputerName != "PHOSPHORUS")
      returned.=GetGmailMessageCount(MelGmailUrl, "Melinda")
   return returned
}

GetGmailMessageCount(url, prettyName)
{
   gmailPage:=urldownloadtovar(url)
   RegExMatch(gmailPage, "<fullcount>(\d+)</fullcount>", gmailPage)
   RegExMatch(gmailPage, "\d+", number)
   ;number := getXmlElementContents(gmailPage, "fullcount")

   if (number == 0 || number == "")
      return ""
   returned=%prettyName% has %number% new emails`n
   return returned
}

UrlDownloadToVarCheck500(url)
{
   errorMsg:="Dropbox - 500"
   title := errorMsg

   while (RegExMatch(title, "^Dropbox - (500|5xx)$"))
   {
      page:=urldownloadtovar(url)
      title:=GetXmlElement(page, "title")
   }

   return page
}
