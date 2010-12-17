while true
{
	WinWait, Café World on Facebook - Google Chrome,
	IfWinNotActive, Café World on Facebook - Google Chrome, , WinActivate, Café World on Facebook - Google Chrome,
	WinWaitActive, Café World on Facebook - Google Chrome,

	ImageSearch, outx, outy, 0, outy+1, 1000, 1000, *5 images\cafeworld\stove2.bmp
	if ErrorLevel
		outy:=0
	else
		MouseMove, outx, outy

	Sleep, 100

	if (ClickIfImageSearchOffsetExact("images\cafeworld\clickstove8.bmp", 0, 36)
		OR ClickIfImageSearchToolTip("images\cafeworld\clickstove7.bmp", outx, outy)
		OR ClickIfImageSearchToolTip("images\cafeworld\clickstove6.bmp", outx, outy)
		OR ClickIfImageSearchToolTip("images\cafeworld\clickstove1.bmp", outx, outy))
		InactivityCounter:=0
	else
		InactivityCounter++

	ClickIfImageSearch("images\cafeworld\SkipButton.bmp")
	ClickIfImageSearch("images\cafeworld\Checkmark.bmp")
	ImageSearch, XCoordinate, YCoordinate, 0, 0, 1000, 1000, *0 images\cafeworld\Cookbook.bmp
	if NOT ErrorLevel
		MakePurchaseFromCookbook("images\cafeworld\Cheeseburger.bmp")
	ClickIfImageSearch("images\cafeworld\CloseWindow.bmp")
;	CloseCafeWorldPopups()

	if % InactivityCounter>20
	{
		debug("Cafe World Macro says:  I can't find anything to do, I'll chill out for a couple minutes")
		;exit
		InactivityCounter:=0
		Sleep, 1000*60*8
	}

}

MakePurchaseFromCookbook(FoodToPurchase="images\cafeworld\FruitSalad.bmp")
{
	;if we didn't find it, move back to the beginning
	Loop 20
	{
		Sleep 1000

		if ClickIfImageSearchDownRight(FoodToPurchase, "images\cafeworld\buy.bmp")
			return

		if NOT ClickIfImageSearch("images\cafeworld\LeftArrowActive.bmp")
			MoveToRandomSpotInWindow()

		if ClickIfImageSearch("images\cafeworld\LeftArrowInactive.bmp")
			break
	}

	;page through to the end
	Loop 20
	{
		Sleep 1000

		if ClickIfImageSearchDownRight(FoodToPurchase, "images\cafeworld\buy.bmp")
			return

		if NOT ClickIfImageSearch("images\cafeworld\RightArrowActive.bmp")
			MoveToRandomSpotInWindow()

		if ClickIfImageSearch("images\cafeworld\RightArrowInactive.bmp")
			debug("error")
	}
}

ClickIfImageSearchNormal(filename, variation=50)
{
ImageSearch, XCoordinate, YCoordinate, 0, 0, A_ScreenWidth, A_ScreenHeight, *%variation% %filename%

if NOT ErrorLevel
	MouseClick, left, XCoordinate, YCoordinate

return NOT ErrorLevel
}

ClickIfImageSearchOffset(filename, OffsetX, OffsetY)
{
WinGetActiveStats, no, WidthOfWindow, HeightOfWindow, no, no
Sleep 100
ImageSearch, XCoordinate, YCoordinate, 0, 0, %WidthOfWindow%, %HeightOfWindow%, *50 %filename%

if NOT ErrorLevel
	MouseClick, left, XCoordinate+OffsetX, YCoordinate+OffsetY

return NOT ErrorLevel
}

ClickIfImageSearchOffsetExact(filename, OffsetX, OffsetY)
{
WinGetActiveStats, no, WidthOfWindow, HeightOfWindow, no, no
Sleep 100
ImageSearch, XCoordinate, YCoordinate, 0, 0, %WidthOfWindow%, %HeightOfWindow%, %filename%

if NOT ErrorLevel
	MouseClick, left, XCoordinate+OffsetX, YCoordinate+OffsetY

return NOT ErrorLevel
}

;Designed to click on an image that is in several places on the screen
;but is uniquely identified by another image immediately up and to the left of it
ClickIfImageSearchDownRight(IdentifierFilename, ImageToClickFilename)
{
WinGetActiveStats, no, WidthOfWindow, HeightOfWindow, no, no
Sleep 100
ImageSearch, XCoordinate, YCoordinate, 0, 0, %WidthOfWindow%, %HeightOfWindow%, *50 %IdentifierFilename%
if ErrorLevel
	return false

ImageSearch, XCoordinate, YCoordinate, XCoordinate+1, YCoordinate+1, %WidthOfWindow%, %HeightOfWindow%, *50 %ImageToClickFilename%

if NOT ErrorLevel
	MouseClick, left, XCoordinate, YCoordinate

return NOT ErrorLevel
}

ClickIfImageSearchToolTip(filename, altx=0, alty=0)
{
WinGetActiveStats, no, WidthOfWindow, HeightOfWindow, no, no
Sleep 100
ImageSearch, XCoordinate, YCoordinate, 0, YCoordinate+1, %WidthOfWindow%, %HeightOfWindow%, *50 %filename%

if altx<>0
	XCoordinate:=altx
if alty<>0
	YCoordinate:=alty

if NOT ErrorLevel
	MouseClick, left, XCoordinate, YCoordinate

return NOT ErrorLevel
}

ClickIfImageSearchMultiple(filename, down=1, right=1)
{
YCoordinate:=-1
WinGetActiveStats, no, WidthOfWindow, HeightOfWindow, no, no
Sleep 100
while (counter < down)
{
ImageSearch, XCoordinate, YCoordinate, 0, YCoordinate+1, %WidthOfWindow%, %HeightOfWindow%, *50 %filename%
counter++
}
counter:=0
while (counter < right)
{
ImageSearch, XCoordinate, YCoordinate, XCoordinate+1, YCoordinate, %WidthOfWindow%, %HeightOfWindow%, *50 %filename%
counter++
}

if NOT ErrorLevel
	MouseClick, left, XCoordinate, YCoordinate

return NOT ErrorLevel
}

ClickIfImageSearch(filename, altx=0, alty=0, times=1)
{
YCoordinate:=-1
WinGetActiveStats, no, WidthOfWindow, HeightOfWindow, no, no
Sleep 100
while (counter < times)
{
ImageSearch, XCoordinate, YCoordinate, 0, YCoordinate+1, %WidthOfWindow%, %HeightOfWindow%, *50 %filename%
counter++
}

if altx<>0
	XCoordinate:=altx
if alty<>0
	YCoordinate:=alty

if NOT ErrorLevel
	MouseClick, left, XCoordinate, YCoordinate

return NOT ErrorLevel
}


Remap(input, remap1, replace1, remap2=0, replace2=0, remap3=0, replace3=0, remap4=0, replace4=0, remap5=0, replace5=0, remap6=0, replace6=0)
{
if input=remap1
	return %replace1%
if input=remap2
	return %replace2%
if input=remap3
	return %replace3%
if input=remap4
	return %replace4%
if input=remap5
	return %replace5%
if input=remap6
	return %replace6%
return input
}


MoveToRandomSpotInWindow()
{
Random, xCoordinate, 0, A_ScreenWidth
Random, yCoordinate, 0, A_ScreenHeight
MouseMove, xCoordinate, yCoordinate
}

WeightedRandom(OddsOfa1, OddsOfa2, OddsOfa3=0, OddsOfa4=0, OddsOfa5=0)
{
Random, input, 1, 100
;debug(input)
OddsOfa2+=OddsOfa1
OddsOfa3+=OddsOfa2
OddsOfa4+=OddsOfa3
OddsOfa5+=OddsOfa4
if % input<=OddsOfa1
	return 1
if % input<=OddsOfa2
	return 2
if % input<=OddsOfa3
	return 3
if % input<=OddsOfa4
	return 4
if % input<=OddsOfa5
	return 5
return 6
}



Debug(text)
{
MsgBox, , , %text%, 1
}

;Would like to include the functions that were moved to the general functions in WorksInProgress.ahk;but this would register duplicate hotkeys during a normal run
;#include WorksInProgress.ahk
