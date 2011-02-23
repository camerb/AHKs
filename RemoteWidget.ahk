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
      entireMessage:=GetWidgetText()
      LV_Delete()
      Loop, parse, entireMessage, `r`n
      {
         if NOT A_LoopField == ""
            LV_Add("", A_LoopField)
      }
      SleepSeconds(30)
   }
Return

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

   while (title == errorMsg)
   {
      page:=urldownloadtovar(url)
      title:=GetXmlElement(page, "title")
      ;title:=page
      ;RegExMatch(title, "<title>.*?</title>", title)
      ;title := StringTrimLeft(title, 7)
      ;title := StringTrimRight(title, 8)
   }

   return page
}

GetXmlElement(xml, path)
{
   elementName:=path
   regex=<%elementName%>(.*)</%elementName%>

   RegExMatch(xml, regex, xml)
   ;errord("nolog", xml1)
   xml := StringTrimLeft(xml, strlen(path)+2)
   xml := StringTrimRight(xml, strlen(path)+3)
   ;msgbox

   return xml
}
