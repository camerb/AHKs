;NOTE Ok, so this is awfully ghetto at the moment. Right now this uses Desktop Sidebar
; with the "Capture Panel" widget to capture and display this AHK GUI as a widget
;TODO Someday I need to make an actual C# widget for Desktop Sidebar
; and get rid of the Capture Panel/AHK GUI combo that you see here

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
   widgetY := 323
}
else if (A_ComputerName == "BAUSTIAN-09PC")
{
   widgetX := 1771
   widgetY := 319
}
else if (A_ComputerName == "T-800")
{
   ;TODO figure out the position for the widget
   widgetX := 1129
   widgetY := 5
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
   Sleep, 950
}

;didn't really need to make this a function
; but it was getting a bit congested up there
GetWidgetText()
{
   FormatTime, returned, , dddd`nMMMM d yyyy`nhh:mm:ss
   return returned
}