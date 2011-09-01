#include FcnLib.ahk

IfWinNotExist, SK Sync Server Version 1.0.01A ahk_class SunAwtFrame
   Run, C:\Dropbox\Programs\syncserver.jar
WinActivate, SK Sync Server Version 1.0.01A ahk_class SunAwtFrame
WinWait, SK Sync Server Version 1.0.01A ahk_class SunAwtFrame
WinGetPos, no, no, no, winHeight, SK Sync Server Version 1.0.01A ahk_class SunAwtFrame
Click(10,winHeight-10,"Mouse")
WinHide, SK Sync Server Version 1.0.01A ahk_class SunAwtFrame
