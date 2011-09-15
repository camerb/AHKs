/**
 * OCR library test script by camerb
 *
 * Tests to verify that the OCR script is running correctly
*/

#SingleInstance force
#Include OCR.ahk
;#Include C:\Dropbox\ahks\FcnLib.ahk

;expected := "HELLO FRIENDS"
;textToType := "{enter 5}{space 20}" . expected

;Run, Notepad.exe
;Sleep, 2000
;SetTitleMatchMode, 2
;WinMove, Untitled - Notepad, , 0, 0
;Send, %textToType%
;returned := GetOCR()
;ToolTip, %returned%
;Sleep, 2000
;if NOT InStr(returned, expected)
   ;msgbox face
;else
   ;msgbox tests passed
;Process, Close, Notepad.exe


expected=Company Processes
img=C:\Dropbox\Public\ocr-tests\%expected%.jpg
SplashImage, %img%
sleep, 1000
returned := GetOCR()
sleep, 1000
SplashImage, Off
ToolTip, %returned%
Sleep, 2000
if NOT InStr(returned, expected)
   msgbox face
else
   msgbox tests passed

ExitApp

;sometimes this helps to ensure more consistent results when switching from one window to another
;CoordMode, Mouse, Screen

;widthToScan=200
;heightToScan=50

;gui, -border +AlwaysOnTop
;gui, color, 0xFF44AA
;gui, show, w%widthToScan% h%heightToScan%,OcrPreviewWindow
;sleep, 200
;WinSet, Transparent, 50, OcrPreviewWindow

;Loop
;{
   ;MouseGetPos, mouseX, mouseY
   ;topLeftX := mouseX
   ;topLeftY := mouseY - heightToScan

   ;WinMove, OcrPreviewWindow, , % topLeftX+2, % topLeftY-2

   ;;NOTE: this is where the magical OCR function is called
   ;magicalText := GetOCR(topLeftX, topLeftY, widthToScan, heightToScan, "true")

   ;liveMessage=Here is the text that GetOCR() found near your mouse:`n%magicalText%`n`nPress ESC at any time to exit
   ;ToolTip, %liveMessage%
   ;Sleep, 100
;}
;;end of script (obviously this never really exits)

Esc:: ExitApp
