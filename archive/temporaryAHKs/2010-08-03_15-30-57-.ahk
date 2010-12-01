#include FcnLib.ahk

SetTitleMatchMode, RegEx

parentWin=Commit - C:\\.* ahk_class #32770
diffWin=.*\..* - TortoiseMerge

#IfWinActive Commit - C:\\.* ahk_class #32770
^LEFT::
#IfWinActive .*\..* - TortoiseMerge
^LEFT::
ForceWinFocus(parentWin, "RegEx")
Send, {UP}{ENTER}
return
#IfWinActive

#IfWinActive Commit - C:\\.* ahk_class #32770
^RIGHT::
#IfWinActive .*\..* - TortoiseMerge
^RIGHT::
ForceWinFocus(parentWin, "RegEx")
Send, {DOWN}{ENTER}
return
#IfWinActive

#IfWinActive Commit - C:\\.* ahk_class #32770
^UP::
ForceWinFocus(diffWin, "RegEx")
Send, ^{UP}
return
#IfWinActive

#IfWinActive Commit - C:\\.* ahk_class #32770
^DOWN::
ForceWinFocus(diffWin, "RegEx")
Send, ^{DOWN}
return
#IfWinActive
