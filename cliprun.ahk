#include FcnLib.ahk

Gui, Add, Text,, hi`nBye`nhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh`n`n`n
Gui, +LastFound
Gui Show, hide
H := WinExist()
AnimateWindow(H, "Slide BT Activate", 1000)
; Gui Show
return

GuiClose:
 AnimateWindow(H, "Hide Slide TB", 1000)
 ExitApp

; AnimateWindow wrapper 6L by nimda
; AHK_L only
; MSDN http://msdn.microsoft.com/en-us/library/ms632669(v=vs.85).aspx


AnimateWindow(HWND, Options, t=200){
	o := 0, op := {Activate : 0x00020000, Fade : 0x00080000, Center : 0x00000010, Hide : 0x00010000, LR : 0x00000001, RL : 0x00000002, Slide : 0x00040000, TB : 0x00000004, BT : 0x00000008}
	List = Activate|Blend|Center|Hide|LR|RL|Slide|TB|BT
	Loop Parse, List,|
		If InStr(Options, A_LoopField, false)
			o |= op[A_LoopField]
	return DllCall("AnimateWindow", "UInt", HWND, "Int", t, "UInt", o)
}



 ~esc::ExitApp