#include FcnLib.ahk
#singleinstance force

Run, C:\Program Files (x86)\PostgreSQL\8.4\bin\pgAdmin3.exe
ForceWinFocus("pgAdmin III ahk_class wxWindowClassNR", "Contains")
Send, ^!{NUMPAD6}
Send, ^!{RIGHT}
Send, ^!3
