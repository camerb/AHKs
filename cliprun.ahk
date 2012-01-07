#include FcnLib.ahk

Gui, Add, Text,, Please enter the file name for the Follett report:
Gui, Add, Edit, vFileName
Gui, Add, Text,, Please enter the market:
Gui, Add, Edit, vMarket, USA
Gui, Add, Button, x10 y100 Default, OK
Gui, Add, Button, x50 y100,Cancel
Gui, Show

 ~esc::ExitApp