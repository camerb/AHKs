#include FunctionLibrary.ahk
;originally was in autohotkey install dir Extras/Scripts/IntelliSense.ahk

; IntelliSense -- by Rajat (requires XP/2k/NT)
; http://www.autohotkey.com
; This script watches while you edit an AutoHotkey script.  When it sees you
; type a command followed by a comma or space, it displays that command's
; parameter list to guide you.  In addition, you can press Ctrl+F1 (or
; another hotkey of your choice) to display that command's page in the help
; file. To dismiss the parameter list, press Escape or Enter.

; Requires v1.0.41+

; CONFIGURATION SECTION: Customize the script with the following variables.

; The hotkey below is pressed to display the current command's page in the
; help file:
I_HelpHotkey = ^F1

; The string below must exist somewhere in the active window's title for
; IntelliSense to be in effect while you're typing.  Make it blank to have
; IntelliSense operate in all windows.  Make it Pad to have it operate in
; editors such as Metapad, Notepad, and Textpad.  Make it .ahk to have it
; operate only when a .ahk file is open in Notepad, Metapad, etc.
I_Editor = GVIM

; If you wish to have a different icon for this script to distinguish it from
; other scripts in the tray, provide the filename below (leave blank to have
; no icon). For example: E:\stuff\Pics\icons\GeoIcons\Information.ico
I_Icon =

; END OF CONFIGURATION SECTION (do not make changes below this point unless
; you want to change the basic functionality of the script).

SetKeyDelay, 0
;#SingleInstance
#include FunctionLibrary.ahk

;~[::
;debug()
;return

; Use the Input command to watch for commands that the user types:
Loop
{
	; Editor window check:
	WinGetTitle, ActiveTitle, A
	IfNotInString, ActiveTitle, %I_Editor%
	{
		ToolTip
		Sleep, 500
		Continue
	}

	; Get all keys till endkey:
	Input, I_Word, V, {enter}{escape}{space}`,
        ;debug("silent log", i_word)
	I_EndKey = %ErrorLevel%

	; Tooltip is hidden in these cases:
	if I_EndKey in EndKey:Enter,EndKey:Escape
	{
		ToolTip
		Continue
	}

	; Editor window check again!
	WinGetActiveTitle, ActiveTitle
	IfNotInString, ActiveTitle, %I_Editor%
	{
		ToolTip
		Continue
	}

	; Compensate for any indentation that is present:
	StringReplace, I_Word, I_Word, %A_Space%,, All
	StringReplace, I_Word, I_Word, %A_Tab%,, All
	if I_Word =
		Continue

	; Check for commented line:
	StringLeft, I_Check, I_Word, 1
	if (I_Check = ";" or I_Word = "If")  ; "If" seems a little too annoying to show tooltip for.
		Continue

	; Match word with command:
	I_Index =
	Loop
	{
		; It helps performance to resolve dynamic variables only once.
		; In addition, the value put into I_ThisCmd is also used by the
		; I_HelpHotkey subroutine:
		;I_ThisCmd := I_Cmd%A_Index%
		;if I_ThisCmd =
			;break

		;if (I_Word = I_ThisCmd);TODO replace line below with this one
		if (I_Word = "hello")
		{
			I_Index := A_Index
			I_HelpOn = %I_ThisCmd%
			break
		}
	}

	; If no match then resume watching user input:
	if I_Index =
		Continue

	; Show matched command to guide the user:
	I_ThisFullCmd := I_FullCmd%I_Index%
	I_ThisFullCmd := "SAW IT" ;TODO remove this
	ToolTip, %I_ThisFullCmd%, A_CaretX, A_CaretY + 20
}
