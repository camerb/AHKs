PixelIsColor(xCoord,yCoord,bgrColor)
{
PixelGetColor, pixcolor,  xCoord, yCoord
if (pixcolor=bgrColor)
	return true
else
	return false
}

ClickIfPixelIsColor(xCoord,yCoord,bgrColor)
{
PixelGetColor, pixcolor,  xCoord, yCoord
if (pixcolor=bgrColor)
	MouseClick, left, xCoord, yCoord
}

ClickUntilPixelIsColor(xCoord,yCoord,bgrColor,maxWait)
{
	Loop % maxWait/200
	{
		Sleep 100
		PixelGetColor, pixcolor,  xCoord, yCoord
		if (pixcolor=bgrColor)
			Break
		Sleep 100
		MouseClick, left, xCoord, yCoord
	}
}

WaitUntilPixelIsColor(xCoord, yCoord, bgrColor, maxWait)
{
	Loop % maxWait/200
	{
		Sleep 100
		PixelGetColor, pixcolor, xCoord, yCoord
		if (pixcolor=bgrColor)
			Break
		Sleep 100
	}
}

WaitUntilPixelIsNotColor(xCoord, yCoord, bgrColor, maxWait)
{
	Loop % maxWait/200
	{
		Sleep 100
		PixelGetColor, pixcolor, xCoord, yCoord
		if (pixcolor<>bgrColor)
			Break
		Sleep 100
	}
}

ScrollUntilPixelIsColor(xCoord, yCoord, bgrColor, xScroll, yScroll)
{
PixelSearch, outx, outy, xCoord, yCoord, xCoord, yCoord, bgrColor, 10, Fast
if (outx<>xCoord OR outy<>yCoord)
{
	MouseMove, xScroll, yScroll

	Click down
	Loop 200
	{
		;location to look at for a given color
		PixelSearch, outx, outy, xCoord, yCoord, xCoord, yCoord, bgrColor, 10, Fast
		if (outx==xCoord AND outy==yCoord)
			Break

		PixelSearch, outx, outy, xCoord, yCoord, xCoord, yCoord+400, bgrColor, 10, Fast

		;move scrollbar down one pixel
		yScroll := yScroll + (outy - yCoord)/2 +1
		;msgbox %yScroll% %outy% %yCoord%
		MouseMove, xScroll, yScroll
		Sleep, 500
	}
	Click up
}
}

ScrollUntilPixelIsColorOLD1(xCoord, yCoord, bgrColor, xScroll, yScroll)
{
	PixelGetColor, pixcolor,  xCoord,  yCoord
	if (pixcolor <> bgrColor)
	{
		yScroll := 128
		MouseMove, xScroll,  yScroll

		Click down
		Loop 200
		{
			;location to look at for a given color
			PixelGetColor, pixcolor,  xCoord,  yCoord
			if (pixcolor == bgrColor)
				Break

			;move scrollbar down one pixel
			yScroll := yScroll + 1
			MouseMove, xScroll, yScroll
			Sleep, 10
		}
		Click up
	}
}
