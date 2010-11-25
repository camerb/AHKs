Farmvillewin = FarmVille on Facebook

WinWait, %Farmvillewin%, 
IfWinNotActive, %Farmvillewin%, , 
WinActivate, %Farmvillewin%, 
WinWaitActive, %Farmvillewin%, 

WinMove, %Farmvillewin%, ,, , 1013, 950, 

;In case of double execution, don't do it again
;Send ^{HOME}
PixelGetColor, pixcolor,  196,  119
if (pixcolor <> 0x41C27F)
{
	scrolllocation := 128
	MouseMove, 996,  scrolllocation
	
	Click down
	Loop 200
	{
	;location to look at for a given color
	PixelGetColor, pixcolor,  196,  119
	if (pixcolor == 0x41C27F)
		Break
	
	;move scrollbar down one pixel
	scrolllocation := scrolllocation + 1
	MouseMove, 996, scrolllocation
	}
	Click up
}