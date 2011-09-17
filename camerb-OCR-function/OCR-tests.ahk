/**
 * OCR library test script by camerb
 *
 * Tests to verify that the OCR script is running correctly
*/

#SingleInstance force
#Include OCR.ahk
;#Include C:\Dropbox\ahks\FcnLib.ahk


expected=Company Processes
img=C:\Dropbox\Public\ocr-tests\%expected%.jpg

Run http://dl.dropbox.com/u/789954/ocr-tests/%expected%.jpg
sleep, 2000

;FIXME not sure why, but if you don't move the window to the top-left
;   seems like it is using the Screen CoordMode, which seems odd
WinMove, %expected%, , 0, 0
Sleep 100

returned := GetOCR()
sleep, 1000

ToolTip, %returned%
Sleep, 2000
if NOT InStr(returned, expected)
   msgbox face
;else
   ;msgbox tests passed

ExitApp

Esc:: ExitApp
