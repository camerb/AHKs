#include FcnLib.ahk

IfWinNotExist, SK Sync Server Version 1.0.01A ahk_class SunAwtFrame
   RunProgram("C:\Dropbox\Programs\sksync\syncserver.jar")
WinActivate, SK Sync Server Version 1.0.01A ahk_class SunAwtFrame
WinWait, SK Sync Server Version 1.0.01A ahk_class SunAwtFrame
WinGetPos, no, no, no, winHeight, SK Sync Server Version 1.0.01A ahk_class SunAwtFrame
Click(18,winHeight-18,"Mouse")
WinHide, SK Sync Server Version 1.0.01A ahk_class SunAwtFrame
