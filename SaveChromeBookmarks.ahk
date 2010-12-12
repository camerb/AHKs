#include FcnLib.ahk

SetTitleMatchMode, 2
IfWinNotExist, Google Chrome
{
   wasNotRunning:=true
   Run, Chrome
}
Run, http://www.google.com/
ForceWinFocus("Google Chrome", "Contains")
Sleep, 1500
Send, {ALT}
Sleep, 1500
Send, {ENTER}
Sleep, 1500
Send, b

ForceWinFocus("Bookmark Manager", "Contains")
WinMaximize ;TODO need to switch this to image search
;Sleep, 200
WaitForImageSearch("images\chrome\organizeMenu.bmp")
ClickIfImageSearch("images\chrome\organizeMenu.bmp", "Control")
;Sleep, 100
WaitForImageSearch("images\chrome\exportButton.bmp")
ClickIfImageSearch("images\chrome\exportButton.bmp", "Control")

ForceWinFocus("Save As", "Exact")
archiveFilename := CurrentTime("hyphenated")
archivePath=C:\DataExchange\ChromeBookmarks
FileCreateDir, %archivePath%
SendInput, %archivePath%\%archiveFilename%
Sleep, 100
;Click(517, 338, "Control")
ControlClick, &Save
Sleep, 100

ForceWinFocus("Bookmark Manager", "Contains")
Send, ^w

if wasNotRunning
   WinClose, Google Chrome
