#include FcnLib.ahk

;trying to color a button for the firefly buttons script

;General Window Settings
;Gui, Font, s11 w700
Gui, -Caption +E0x200 +ToolWindow
TransColor = D4D1C8
Gui, Color, %TransColor%  ; This color will be made transparent later below.

bgColor = White ; Background color
;Button number, as found using the number pad
Three = x230 y230 w100 h100 ceeee22
Gui, Add, Button, %Three%, AD
Gui, Show, x400 y400 h340 w340

WinGet, k_ID, ID, A   ; Get its window ID.
WinSet, AlwaysOnTop, On, ahk_id %k_ID%
WinSet, TransColor, %TransColor% 170, ahk_id %k_ID%

Gui, 2:-Caption +E0x200 +ToolWindow
Gui, 2:Color, %bgColor% ; Set background color here

Gui, 2:Add, Progress, %Three%, 100
Gui, 2:Show, x400 y400 h340 w340
Return


ButtonAD:
ExitApp

