#include FcnLib.ahk

;folder scan function
;FolderScan("C:\Dropbox\AHKs\*", "conflicted", "paths")
;FolderScan("C:\Dropbox\AHKs\*", ".*;.*(TODO|WRITEME)", "fileContents")
;FolderScan("C:\Dropbox\AHKs\*", ".*;.*WRITEME", "fileContents")
;FolderScan("C:\Dropbox\AHKs\*", "listview", "fileContents")
FolderScan("C:\Dropbox\AHKs\*", "listview", "GUI")

;note that the path is actually a haystack, preserving the search(haystack, needle) ordering that is common throughout AHK
FolderScan(path, needle, options="files folders regex")
{
   global M095_ListViewVar

   if InStr(options, "gui")
      gui:=true
   ;TODO more options!
   ;if InStr(options, "gui")
      ;gui:=true

   if gui
   {
      if (!path and !needle)
      {
         path:=prompt("What folder do you want to scan?")
         needle:=prompt("What regex needle do you want to use?")
      }
      Gui, Add, Listview, xm ym w400 h420 Grid AltSubmit vM095_ListViewVar, Filename              |Line|Matched Line
   }
   AddToTrace("grey line")
   ;options=files/fileContents folders/paths folderPaths regex contains gui

   ;TODO how do we determine if they forgot the wildcard characters at the end? they might only want to scan a certain file type for file contents
   ;path.=*

   ;files
   Loop, %path%, 0, 1
   {
      thisPath := A_LoopFileFullPath
      thisFilename := A_LoopFileName
      ;if RegExMatch(thisPath, "(" . needle . ")", match)
      ;match the path
      ;if RegExMatch(thisPath, needle, match)
         ;AddToTrace(thisPath)

      lineNum=0
      Loop, read, %thisPath%
      {
         lineNum++
         thisLine := A_LoopReadLine
         if RegExMatch(thisLine, needle, match)
            ;AddToTrace(thisFilename, lineNum, thisLine)
            LV_Add("", thisFilename, lineNum, thisLine)
      }
   }

   ;folders
   Loop, %path%, 2, 1
   {
   }
   if gui
      Gui, Show, , FolderScan Results
}
Return

GuiClose:
GuiEscape:
{
    ExitApp
}
Return

   ;Gui, +ToolWindow -Caption
   ;Gui, Color, , 000022
   ;Gui, font, s7 cCCCCEE,
   ;;Gui, font, , Courier New
   ;Gui, font, , Verdana
   ;;Gui, font, , Arial
   ;;Gui, font, , Consolas
   ;Gui, Margin, 0, 0
   ;Gui, Add, ListView, r20 w147 -Hdr, Text
   ;Gui, Show
   ;WinMove, %guiTitle%, , , , 200, 200
   ;Loop
   ;{
      ;lastEntireMessage:=entireMessage
      ;entireMessage:=GetWidgetText()

      ;;if a change in the text has taken place, repaint
      ;;(else: don't bother cause it flickers)
      ;if (entireMessage <> lastEntireMessage)
      ;{
         ;LV_Delete()
         ;Loop, parse, entireMessage, `r`n
         ;{
            ;if NOT A_LoopField == ""
               ;LV_Add("", A_LoopField)
         ;}
      ;}

      ;;wait between updates, unless if currently messing with gmail in browser
      ;;  this will make it more accurate if we're reading emails right now
      ;Loop 30
      ;{
         ;if InStr(WinGetActiveTitle(), "Gmail")
            ;break
         ;SleepSeconds(1)
      ;}
   ;}
