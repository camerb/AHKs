#include FcnLib.ahk
;debug("before fl dev")
ClickIfImageSearch("images\pgadmin\FL_dev.bmp")
;debug("after fl dev")
;WaitForImageSearch("images\pgadmin\FL_live_as_owner.bmp")
ClickIfImageSearch("images\pgadmin\FL_live_as_owner.bmp")
Click

;WaitForImageSearch("images\pgadmin\FL.bmp")
ClickIfImageSearch("images\pgadmin\FL.bmp", "Right")

;WaitForImageSearch("images\pgadmin\Backup.bmp")
ClickIfImageSearch("images\pgadmin\Backup.bmp")

ForceWinFocus("Backup Database FL", "Exact Debug")
SendInput, ^a{DEL}
time:=CurrentTime("hyphenated")
filename=C:\Users\cameron\Documents\fl_live_automated_backup_%time%_(FL)_as_sa.backup
SendInput, %filename%{ENTER}
;Sleep, 300
;ControlClick, &OK, Backup Database FL

;Sleep, 300
;ControlClick, &OK, Backup Database FL

;Sleep, 300
;ControlClick, &OK, Backup Database FL
;Sleep, 300

;TitleMatchMode Slow
;Process returned exit code 0.
