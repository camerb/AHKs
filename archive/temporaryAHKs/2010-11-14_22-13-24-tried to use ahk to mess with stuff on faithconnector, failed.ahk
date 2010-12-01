#include FcnLib.ahk

sleepnum=1000

ClickIfImageSearch("images\faithConnector\TextColorButton.bmp")
Sleep, %sleepnum%
MouseMove, -200, -200, , R
Sleep, %sleepnum%
ClickIfImageSearch("images\faithConnector\AutomaticColor.bmp")
Sleep, %sleepnum%
ClickIfImageSearch("images\faithConnector\HighlightColorButton.bmp")
Sleep, %sleepnum%
MouseMove, -200, -200, , R
Sleep, %sleepnum%
ClickIfImageSearch("images\faithConnector\AutomaticColor.bmp")
Sleep, %sleepnum%

;Send, {PgDn}

ClickIfImageSearch("images\faithConnector\SaveButton.bmp")
