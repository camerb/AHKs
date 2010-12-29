#include FcnLib.ahk


#Singleinstance Force
scripttitle = test script

Gui, Add, MonthCal, vcalgo x15 y50 w180 h180  Multi
Gui, Show, x131 y91 h270 w200, %scripttitle%
return


guiclose:
	exitapp
