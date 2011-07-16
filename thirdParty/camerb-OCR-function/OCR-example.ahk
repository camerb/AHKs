/**
 * OCR library test script by camerb
 *
 * This tiny script serves as an example of the intended usage of the OCR library.
*/

#SingleInstance force
#Include OCR.ahk

;sometimes this helps to ensure more consistent results when switching from one window to another
CoordMode, Mouse, Screen

outputFile=OCRtext.txt
widthToScan=100
heightToScan=40

Loop
{
   ;figuring out what region we will scan (the area around the mouse)
   MouseGetPos, mouseX, mouseY
   topLeftX := mouseX - (widthToScan / 2)
   topLeftY := mouseY - (heightToScan / 2)

   ;NOTE: this is where the magical OCR function is called
   magicalText := GetOCR(topLeftX, topLeftY, widthToScan, heightToScan)

   ;I prefer to look at this output using a BareTail, some like Tooltips
   ;but I left a msgbox with a timeout here because that works for everyone
   liveMessage=Here is the text that GetOCR() found near your mouse:`n%magicalText%`n`nPress ESC at any time to exit
   ;FileAppend, %magicalText%`n, %outputFile%
   MsgBox, , , %liveMessage%, 2
   ;ToolTip, %liveMessage%
   Sleep, 100
}
;end of script (obviously this never really exits)

Esc:: ExitApp
