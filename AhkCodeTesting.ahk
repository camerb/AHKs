#include FacebookGameFunctions.ahk

MouseGetPos, xCoord, yCoord

gosub lbl2

lbl4:
if (NOT PixelIsColor(xCoord, yCoord, 0xFFFFFF))
	msgbox totally NOT white
else
	msgbox white
exit

lbl3:
WaitUntilPixelIsColor(xCoord, yCoord, 0xFFFFFF, 10000)
msgbox pixel is now white or maxWait exceeded
exit

lbl2:
if (PixelIsColor(xCoord, yCoord, 0xFFFFFF))
	msgbox is white
else
	msgbox other color
exit

asdffasasfdfdsaafdsfds


lbl1:
joevar := PixelIsColor(xCoord, yCoord, 0xFFFFFF)
msgbox %joevar%
if (joevar)
	msgbox is white
else
	msgbox other color
exit

