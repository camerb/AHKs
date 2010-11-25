;Copying files and overwriting with the newer version of the file in win 7

Loop 50
{
ForceWinFocus("Move File")
MouseMove, 0, 0
ClickIfImageSearch("images\NewerFileCopy.bmp")
}

ForceWinFocus(titleofwin, options="")
{
WinWait, %titleofwin%
IfWinNotActive, %titleofwin%
WinActivate, %titleofwin%
WinWaitActive, %titleofwin%
}

ClickIfImageSearch(filename, variation=0)
{
WinGetPos, no, no, windowWidth, windowHeight
ImageSearch, XCoordinate, YCoordinate, 0, 0, windowWidth, windowHeight, *%variation% %filename%

if NOT ErrorLevel
	MouseClick, left, XCoordinate, YCoordinate

return NOT ErrorLevel
}

