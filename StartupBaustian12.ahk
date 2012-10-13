#include FcnLib.ahk

;why the heck does this window open up?
;  who even cares why... just kill the window and move on with life
WinWait, NVIDIA ahk_class CabinetWClass, , 20
WinClose

;TODO delete swp files from PC on startup

ForceWinFocus("ahk_class TfrmMSNPopUp")
Sleep, 100
;Click, 10, 10
Click(10, 10, "Control")
;Click(10, 10)
