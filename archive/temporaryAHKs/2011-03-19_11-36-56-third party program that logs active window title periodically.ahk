#include FcnLib.ahk


; ================== program start up====================================
sleep, 5000
; set unique value for these variables
old_prog = StartUp
old_win = StartUp

; set location and header row for the output file
filename =C:\Dropbox\Public\trace.txt
titlerow = StartTime%a_tab%EndTime%a_tab%UserName%a_tab%ProgramName%a_tab%WindowTitle`r`n

; set initial start time
FormatTime, StartTime_a,,MM/dd/yy
FormatTime, StartTime_b,,hh:mm:ss tt
StartTime := StartTime_a . a_space . StartTime_b

; ======================= check to see if window has changed ====================
GetActiveWindow:

WinGet, program_name, ProcessName, A
WinGetActiveTitle, Window_name


if (old_prog = program_name) and (old_win = Window_name)
; no change, check again after 5 seconds
{
   sleep, 5000
   gosub, GetActiveWindow
}


if (old_prog <> program_name) or (old_win <> Window_name)
; A change has occured
{
   ; set end time
   FormatTime, EndTime_a,,MM/dd/yy
   FormatTime, EndTime_b,,hh:mm:ss tt
   EndTime := EndTime_a . a_space . EndTime_b

   ; save values for output file
   datarow = %StartTime%%a_tab%%EndTime%%a_tab%%A_UserName%%a_tab%%program_name%%a_tab%%Window_name%`r`n
   gosub, SaveData
}

; ============================= save data output ===================
SaveData:

IfExist,%filename%
; if file already exists, append to current file
   {
   ; save to existing file
   FileAppend, %datarow%, %filename%
   gosub,ResetVariables
   }

Ifnotexist,%filename%
; if file does not exist, create new file
   {
   ; create new file and save record
   FileAppend, %titlerow%, %filename%
   FileAppend, %datarow%, %filename%
   gosub,ResetVariables
   }


; ===================== reset variables =====================
ResetVariables:

   ;replace old names with active names.  These will be used for the next comparison
   old_prog = %program_name%
   old_win = %Window_name%

   ; set next start time
   FormatTime, StartTime_a,,MM/dd/yy
   FormatTime, StartTime_b,,hh:mm:ss tt
   StartTime := StartTime_a . a_space . StartTime_b

gosub, GetActiveWindow


