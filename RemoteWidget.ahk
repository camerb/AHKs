;NOTE Ok, so this is awfully ghetto at the moment. Right now this uses Desktop Sidebar
; with the "Capture Panel" widget to capture and display this AHK GUI as a widget
;TODO Someday I need to make an actual C# widget for Desktop Sidebar
; and get rid of the Capture Panel/AHK GUI combo that you see here

#include FcnLib.ahk

;Run, TestRemoteWidget.ahk
guiTitle=%A_ScriptName% ahk_class AutoHotkeyGUI

Gui:
   Gui, +ToolWindow -Caption
   Gui, Margin, 0, 0
   Gui, Add, ListView, r20 w147 -Hdr, Text
   Gui, Show
   WinMove, %guiTitle%, , , , 200, 200
   Loop
   {
      entireMessage:=urldownloadtovar("http://dl.dropbox.com/u/789954/remotewidget.txt")
      LV_Delete()
      Loop, parse, entireMessage, `r`n
      {
         if NOT A_LoopField == ""
            LV_Add("", A_LoopField)
      }
      SleepSeconds(30)
   }
Return

