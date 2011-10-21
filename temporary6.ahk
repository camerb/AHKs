#include FcnLib.ahk
#include FcnLib-Nightly.ahk

;making a nifty way to upload screenshots to imgin.it
;got the upload working but haven't messed with generating the image yet

ProcessCloseAll("firefox.exe")

filePath=C:\Dropbox\AHKs\images\firebug\reloadButton.bmp
imacro=
(
VERSION BUILD=7401004 RECORDER=FX
URL GOTO=http://www.imgin.it/
TAG POS=1 TYPE=INPUT:FILE FORM=ACTION:/ ATTR=ID:localUP CONTENT=%filePath%
TAG POS=1 TYPE=INPUT:IMAGE FORM=ID:form_up ATTR=ID:subir
)
RunIMacro(imacro)
page:=iMacroUrlDownloadToVar()

;needle=href="([^"]*)"[^>]>URL:
needle=(href="([^"]*)"[^>]*\>URL\:)

RegExMatch(page, needle, match)
Clipboard := match2
debug("The image URL has been placed on the clipboard")
