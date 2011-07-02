#include FcnLib.ahk

;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
;===  GUI Stuff  ===============================
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

MainGuiCreate:
Gui, Font, q5 s9 c000000, Segoe UI
Gui, Color, c3c3c3
;Gui, Add, Text, gAboutPFW, ProcFromWin
Gui, Font, s8
Gui, Add, Text,, Hold cursor over window and press `n spacebar to grab info.

MainGuiShow:
Gui, Show, Hide, ProcFromWin 0.1 beta
Gui -Resize -Caption +AlwaysOnTop +LastFound
Gui, Show, x0 y0, ProcFromWin 0.1 beta
WinSet, Transparent, 225, ProcFromWin 0.1 beta
Return


GuiClose:
OnExit:
Gui, Destroy
ExitApp
Return




;Gui 2 - WinInfo  v
GetWinInfo:
Space::
Win := GetWinofInterest()
ProcPID := GetProcPid()
ProcFullPath := GetProcPath(ProcPID)
ProcName := GetJustProc()
;MsgBox, %Win% -- %ProcFullPath% -- %ProcName% -- %ProcPID%

CreateInfoWin:
Gui, 2:+owner1
Gui, 2:Add, Text,, Window Information:
Gui, 2:Add, Text,, Process: %ProcName%`nPID: %ProcPid% ;`nProcess location: %ProcFullPath%
Gui, 2:Add, Text, gKillIt Center, Kill Now!
Gui, 2:Show,, Window Information
Return

2GuiClose:
Gui, 2:Destroy
WinActivate, ProcFromWin 0.1 beta
Return


KillIt:
ProcessCloseAll(ProcName)
Gui, 2:Add, Text,, Process was killed sucessfully. 
Gui, 2:+Resize
Return

;Gui 2 - WinInfo  ^














;==================================================;
;== These are the functions used by the program. ==;
;====       They are what makes it tick.       ====;
;=  CAUTION: Looking at these functions may fry   =;
;=  your brains, or make you think of spaghetti.  =;
;=              YOU HAVE BEEN WARNED              =;
;==================================================;

GetWinofInterest() ;Get the ID of the window under the cursor
{
	MouseGetPos,,, Win
	Return, Win
}
Return


GetWinId()  ;Don't have clue what this does. Uses the Win ID to get the Win ID?
{
	global Win
	WinGet, WinID, ID, ahk_id %Win%
	Return, WinID
}
Return


GetProcPath(p_pid)  ;code contributed by an #ahk-er -- gets proc (exe) and full path from win.
{
	h_process := DllCall( "OpenProcess", "uint", 0x10|0x400, "int", false, "uint", p_pid ) 
	If (ErrorLevel or h_process = 0) 
		Return
	name_size = 255
	VarSetCapacity( ProcFullPath, name_size )
	result := DllCall( "psapi.dll\GetModuleFileNameExA", "uint", h_process, "uint", 0, "str", ProcFullPath, "uint", name_size )
	DllCall( "CloseHandle", h_process )
	Return, ProcFullPath
}
Return

GetJustProc() ;Get only the proc (exe) for the win
{
	global Win
	WinGet, ProcName, ProcessName, ahk_id %Win%
	Return, ProcName
}
Return


GetProcPID() ;Get just the pid
{
	global Win
	WinGet, ProcPID, PID, ahk_id %Win%
	Return, ProcPID
}
Return





 ~esc::ExitApp