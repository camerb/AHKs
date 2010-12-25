;####################################################
;          Includes from other files
;####################################################

#include FacebookGameFunctions.ahk
#include FcnLib.ahk

;####################################################
;          The actual "running" script itself
;####################################################

PrimeWebpage()
FindCleanerEmployee()
ReassignEmployeeJobs()
SaveGame()
CloseTab()
SleepMinutes(10)

;infinite loop (refresh the script with the latest one, cause Cameron makes frequent changes)
Reload

;####################################################
;          THIS IS THE END OF THE "RUNNING" SCRIPT
;          Functions that are used are defined below
;####################################################

;####################################################
;          Complex functions (ones that require indent formatting since they're so complex)
;####################################################

PrimeWebpage()
{
	;Open window
	;Run, http://apps.facebook.com/restaurantcity/
	;Sleep, 5000
	
	loaded=no
	while loaded == "no"
	{
		Run, http://apps.facebook.com/restaurantcity/
		
		RestaurantCitywin = Restaurant City on Facebook
		
		WinWait, %RestaurantCitywin%, , 10000
		IfWinNotActive, %RestaurantCitywin%, , 
		WinActivate, %RestaurantCitywin%, 
		WinWaitActive, %RestaurantCitywin%, , 10000
		
		WinMove, %RestaurantCitywin%, ,, , 1013, 950, 
		
		;just in case it wasn't logged in
		;Send {ENTER}
		;Sleep, 1000*60
		
		;wait until the facebook bar appears, then we can scroll down
		WaitUntilPixelIsColor(450, 118, 0x98593B, 10000)
		
		;Send ^{HOME}
		;Sleep 100
		ScrollUntilPixelIsColor(30, 107, 0xCE8200, 996, 128)
		
		WaitUntilPixelIsNotColor(457, 194, 0xFFFFFF, 30000)
	
		Loop 50
		{
			Sleep 200
			ClickIfPixelIsColor(152, 112, 0xFFFFFF)
			ClickIfPixelIsColor(152, 135, 0xFFFFFF)
			ClickIfPixelIsColor(152, 158, 0x4A4AD8)
			
			ClosePopups()
		
			;Try to exit
			if (PixelIsColor(152, 112, 0x4A4AD8)
			 AND PixelIsColor(152, 135, 0x4A4AD8)
			 AND PixelIsColor(152, 158, 0xFFFFFF)
			 AND PixelIsColor(741, 709, 0x00D6FF))
			{
				loaded=yes
				Break
			}
		}
	}

	;MsgBox loaded:%loaded%
	;if loaded is no, then we probably need to close the 
	;page/reload the script (but reloading the script 
	;could have adverse effects with #includes)
}

FindCleanerEmployee()
{
	;enter the menus
	MouseClick, left,  272,  703
	
	Loop 10
	{
		;check color
		Sleep 400
		PixelGetColor, pixcolor,  475,  223
		if (pixcolor == 0x21E6A8)
			Break
		
		ClickNextEmployee()
	}
}

CloseTab()
{
	Sleep, 100
	MouseClick, left,  20,  350
	Loop 20
	{
		Sleep 500
		if (PixelIsColor(468, 283, 0xD4ECFC))
			Break
	}
	
	Send, ^w
}

;####################################################
;          Simple/independent functions (ones that are so straightforward, they don't need formatting)
;####################################################

ReassignEmployeeJobs()
{
;Start assigning duties
;RRWCCJC (J is janitor)

Sleep, 350
MouseClick, left,  273,  706
Sleep, 350
MouseClick, left,  397,  242
Sleep, 350
ClickNextEmployee()
Sleep, 350
MouseClick, left,  399,  245
Sleep, 350
ClickNextEmployee()
Sleep, 350
MouseClick, left,  589,  245
Sleep, 350
ClickNextEmployee()
Sleep, 350
MouseClick, left,  525,  245
Sleep, 350
ClickNextEmployee()
Sleep, 350
MouseClick, left,  522,  242
Sleep, 350
ClickNextEmployee()
Sleep, 350
MouseClick, left,  458,  245
Sleep, 350
ClickNextEmployee()
Sleep, 350
MouseClick, left,  589,  245
Sleep, 350
ClickNextEmployee()
Sleep, 350
ClickExitMenu()
Sleep, 350
}

ClickExitMenu()
{
MouseClick, left, 664, 356
}

ClickNextEmployee()
{
Sleep 350
MouseClick, left, 610, 360
}

SaveGame()
{
MouseClick, left,  158,  191
Sleep, 1000
MouseClick, left,  418,  440
}

;get rid of annoying pop up "windows" in the game
ClosePopups()
{
;get rid of friend invite on white BG on entry into game
ClickIfPixelIsColor(545, 439, 0x2E30EB)

;get rid of latest earnings popup on game entry
ClickIfPixelIsColor(606, 350, 0x21E6A8)
}