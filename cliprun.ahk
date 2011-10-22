#include FcnLib.ahk

Gui, Add, Picture, w300 h300 gOnPic, C:\Dropbox\AHKs\images\vmware\phosphorusVmButton.bmp
Gui, Show
Return

OnPic:
{
}
Return

GuiClose:
GuiEscape:
{
    ExitApp
}
Return



 ~esc::ExitApp