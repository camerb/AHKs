#include FcnLib.ahk

ForceWinFocus("GVIM", "Contains")
SendInput, ,c {ESC 6}{;}w{enter}

ForceWinFocus("cmd.exe", "Contains")
SendInput, perl script\db_scripts\importJudgeTermExpires.pl{ENTER}
