while true
{
WinWait, Café World on Facebook - Google Chrome, 
IfWinNotActive, Café World on Facebook - Google Chrome, , WinActivate, Café World on Facebook - Google Chrome, 
WinWaitActive, Café World on Facebook - Google Chrome, 

ImageSearch, outx, outy, 0, outy+1, 1000, 1000, *50 images\stove.bmp
MouseMove, outx, outy

Sleep, 100

if (ClickIfImageSearch("images\clickstove1.bmp", outx, outy)
	OR ClickIfImageSearch("images\clickstove2.bmp", outx, outy)
	OR ClickIfImageSearch("images\clickstove3.bmp"))
	InactivityCounter:=0
else
	InactivityCounter++

CloseCafeWorldPopups()

if % InactivityCounter>14
{
	debug("pretty inactive, I'm gonna chill out for a couple minutes")
	InactivityCounter:=0
	Sleep, 1000*60*14
}

/*
ClickIfImageSearch("images\clickstove1.bmp", outx, outy)
ClickIfImageSearch("images\clickstove2.bmp", outx, outy)
CloseCafeWorldPopups()

ClickIfImageSearch("images\clickstove3.bmp")
ClickIfImageSearch("images\EmptyStove.bmp")
ClickIfImageSearch("images\dirtystove.bmp")
*/
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

CloseCafeWorldPopups()
{
ClickIfImageSearch("images\SkipButton.bmp")
ClickIfImageSearch("images\Checkmark.bmp")
num:=WeightedRandom(85, 15)
num:=WeightedRandom(100, 0)
num:=2
ClickIfImageSearch("images\buy.bmp", 0, 0, num)
ClickIfImageSearch("images\CloseWindow.bmp")
}

ClickIfImageSearchNormal(filename, altx=0, alty=0)
{
WinGetActiveStats, no, WidthOfWindow, HeightOfWindow, no, no
Sleep 100
ImageSearch, outx, outy, 0, outy+1, %WidthOfWindow%, %HeightOfWindow%, *50 %filename%

if NOT ErrorLevel
	MouseClick, left, outx, outy

return NOT ErrorLevel
}

ClickIfImageSearchToolTip(filename, altx=0, alty=0)
{
WinGetActiveStats, no, WidthOfWindow, HeightOfWindow, no, no
Sleep 100
ImageSearch, outx, outy, 0, outy+1, %WidthOfWindow%, %HeightOfWindow%, *50 %filename%

if altx<>0
	outx:=altx
if alty<>0
	outy:=alty

if NOT ErrorLevel
	MouseClick, left, outx, outy

return NOT ErrorLevel
}

ClickIfImageSearchMultiple(filename, down=1, right=1)
{
outy:=-1
WinGetActiveStats, no, WidthOfWindow, HeightOfWindow, no, no
Sleep 100
while (counter < down)
{
ImageSearch, outx, outy, 0, outy+1, %WidthOfWindow%, %HeightOfWindow%, *50 %filename%
counter++
}
counter:=0
while (counter < right)
{
ImageSearch, outx, outy, outx+1, outy, %WidthOfWindow%, %HeightOfWindow%, *50 %filename%
counter++
}

if NOT ErrorLevel
	MouseClick, left, outx, outy

return NOT ErrorLevel
}

ClickIfImageSearch(filename, altx=0, alty=0, times=1)
{
outy:=-1
WinGetActiveStats, no, WidthOfWindow, HeightOfWindow, no, no
Sleep 100
while (counter < times)
{
ImageSearch, outx, outy, 0, outy+1, %WidthOfWindow%, %HeightOfWindow%, *50 %filename%
counter++
}

if altx<>0
	outx:=altx
if alty<>0
	outy:=alty

if NOT ErrorLevel
	MouseClick, left, outx, outy

return NOT ErrorLevel
}

Debug(text)
{
MsgBox, , , %text%, 1
}