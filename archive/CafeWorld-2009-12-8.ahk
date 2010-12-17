while true
{
	WinWait, Café World on Facebook - Google Chrome, 
	IfWinNotActive, Café World on Facebook - Google Chrome, , WinActivate, Café World on Facebook - Google Chrome, 
	WinWaitActive, Café World on Facebook - Google Chrome, 
	
	ImageSearch, outx, outy, 0, outy+1, A_ScreenWidth, A_ScreenHeight, *5 images\cafeworld\stove2.bmp
	if ErrorLevel
	{
		outy:=0
	}
	else
	{
		Loop 40
		{
			MouseMove, outx, outy
			Sleep 500
			ImageSearch, leftx, lefty, outx+48-10, outy-77-10, outx+48+30, outy-77+10, *150 images\cafeworld\TimeLeftUntilCooked.bmp
;			ImageSearch, leftx, lefty, 0, 0, A_ScreenWidth, A_ScreenHeight, *50 images\cafeworld\TimeLeftUntilCooked.bmp
;			msgbox %outx%, %outy% :: %leftx%, %lefty%
			if ErrorLevel
			{
				CloseCafeWorldPopups()
				InactivityCounter:=0
;				MouseMove, outx, outy
;				debug("didnt find it")
				MouseClick, left, outx, outy
			}
			else
			{
				InactivityCounter++
;				MouseMove, leftx, lefty
;				debug("found it")
;				Sleep 3000
				break
			}
		}
	}
	
	Sleep 100
	
	CloseCafeWorldPopups()

	if % InactivityCounter>12
	{
		debug("Cafe World Macro says:  I can't find anything to do, I'll chill out for a couple minutes")
		;exit
		outy:=0
		InactivityCounter:=0
		Sleep, 1000*60*9
	}

}

CloseCafeWorldPopups()
{
	ClickIfImageSearch("images\cafeworld\SkipButton.bmp")
	ClickIfImageSearch("images\cafeworld\Checkmark.bmp")
	ImageSearch, XCoordinate, YCoordinate, 0, 0, 1000, 1000, *0 images\cafeworld\Cookbook.bmp
	if NOT ErrorLevel
	{
		MouseMove, XCoordinate, YCoordinate
		MakePurchaseFromCookbook("images\cafeworld\FruitSalad.bmp")
	}
	ClickIfImageSearch("images\cafeworld\CloseWindow.bmp")
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

MoveToRandomSpotInWindow()
{
WinGetActiveStats, no, WidthOfWindow, HeightOfWindow, no, no
Random, xCoordinate, 0, WidthOfWindow
Random, yCoordinate, 0, HeightOfWindow
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

ClickIfImageSearchNormal(filename, variation=50)
{
WinGetActiveStats, no, WidthOfWindow, HeightOfWindow, no, no
Sleep 100
ImageSearch, XCoordinate, YCoordinate, 0, 0, %WidthOfWindow%, %HeightOfWindow%, *%variation% %filename%

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

Debug(text)
{
MsgBox, , , %text%, 1
}