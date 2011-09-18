#include FcnLib.ahk
;#include thirdParty/OCR.ahk

firefox=Status Pro Initial Catalog.*Firefox
excel=In House Process Server Scorecard.*OpenOffice.org Calc

;ss()
;ForceWinFocus("Status Pro Initial Catalog=StatusPro; - Portal - Mozilla Firefox")
;ss()
;date:=GetOCR(471, 505, 130, 20)
;debug(date)

ForceWinFocus(excel)
;Loop to find the first empty column
Loop
{
   Send, {RIGHT}
   Send, ^c
   Sleep, 500
   if NOT RegExMatch(Clipboard, "[A-Za-z]")
      break
}


ESC::ExitApp
`::ExitApp

ss()
{
Sleep, 100
}
