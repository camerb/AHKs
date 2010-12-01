; included this in the AppSpecificHotkeys file... time to archive it

#include FcnLib.ahk

SetTitleMatchMode, RegEx

parentWin=Commit - C:\\.* ahk_class #32770
diffWin=.*\..* - TortoiseMerge

#IfWinActive Commit - C:\\.* ahk_class #32770
^LEFT::
#IfWinActive .*\..* - TortoiseMerge
^LEFT::
parentWin=Commit - C:\\.* ahk_class #32770
diffWin=.*\..* - TortoiseMerge
ForceWinFocus(parentWin, "RegEx")
Send, {UP}{ENTER}
return
#IfWinActive

#IfWinActive Commit - C:\\.* ahk_class #32770
^RIGHT::
#IfWinActive .*\..* - TortoiseMerge
^RIGHT::
parentWin=Commit - C:\\.* ahk_class #32770
diffWin=.*\..* - TortoiseMerge
ForceWinFocus(parentWin, "RegEx")
Send, {DOWN}{ENTER}
return
#IfWinActive

#IfWinActive Commit - C:\\.* ahk_class #32770
^UP::
parentWin=Commit - C:\\.* ahk_class #32770
diffWin=.*\..* - TortoiseMerge
ForceWinFocus(diffWin, "RegEx")
Send, ^{UP}
return
#IfWinActive

#IfWinActive Commit - C:\\.* ahk_class #32770
^DOWN::
parentWin=Commit - C:\\.* ahk_class #32770
diffWin=.*\..* - TortoiseMerge
ForceWinFocus(diffWin, "RegEx")
Send, ^{DOWN}
return
#IfWinActive
