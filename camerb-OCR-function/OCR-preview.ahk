/**
 * OCR library preview script by camerb, excellent additions provided by tidbit
 *
 * This tiny script serves as a quick way to see what text will be picked up by the OCR library.
*/

#SingleInstance force
#Include OCR.ahk

;sometimes this helps to ensure more consistent results when switching from one window to another
CoordMode, Mouse, Screen

widthToScan=200
heightToScan=50

gui, -border +AlwaysOnTop
gui, color, 0xFF44AA
gui, show, w%widthToScan% h%heightToScan%,OcrPreviewWindow
sleep, 200
WinSet, Transparent, 50, OcrPreviewWindow

Loop
{
   MouseGetPos, mouseX, mouseY
   topLeftX := mouseX
   topLeftY := mouseY - heightToScan

   WinMove, OcrPreviewWindow, , % topLeftX+2, % topLeftY-2

   options:=""
   if keyIsPressed("d")
      options.=" debug"
   if keyIsPressed("n")
      options.=" numeric"

   ;NOTE: this is where the magical OCR function is called
   magicalText := GetOCR(topLeftX, topLeftY, widthToScan, heightToScan, options)

   liveMessage=Here is the text that GetOCR() found near your mouse:`n%magicalText%`n`nPress ESC at any time to exit`nHold the 'N' key to see output using the "numeric" option.`nHold the 'D' key to see output using the "debug" option.
   ToolTip, %liveMessage%
   Sleep, 100
}
;end of script (obviously this never really exits)

Esc:: ExitApp

keyIsPressed(key)
{
   If (getkeystate(key,"p") == "U")
      return false
   Else If (getkeystate(key,"p") == "D")
      return true
   return getkeystate(key,"p")
}
