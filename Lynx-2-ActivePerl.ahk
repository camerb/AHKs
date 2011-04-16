#include FcnLib.ahk

;debug("yo2")

Run, C:\LynxCD\Server 7.11\Setup\ActivePerl-5.8.9.827-MSWin32-x86-291969.msi

ForceWinFocus("ActivePerl 5.8.9 Build 827 Setup ahk_class MsiDialogCloseClass")
SleepSeconds(3)
Send, !n
WinWaitActive, , accept the terms in the License Agreement
SleepSeconds(1)
Send, !a
SleepSeconds(1)
Send, !n
SleepSeconds(1)
Send, !n
SleepSeconds(1)
Send, !n
SleepSeconds(1)
;press install button
Send, !i
SleepSeconds(1)

;wait for install to complete (and the prompt to look at the release notes)
CustomTitleMatchMode("Contains")
WinWaitActive, , Display the release notes, 600
if ERRORLEVEL
   fatalErrord("ActivePerl install never finished")
SleepSeconds(1)
Click(255, 286)
SleepSeconds(1)
Send, !f
;WinWaitClose, ActivePerl


