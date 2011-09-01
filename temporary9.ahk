#include FcnLib.ahk

target=C:\Dropbox\AHKs\Bootstrap.ahk
workingDir=C:\Dropbox\AHKs\
shortcut=%A_StartMenu%\Programs\Startup\AutoHotkey - Bootstrap.lnk
FileCreateShortcut, %target%, %shortcut%, %workingDir%
