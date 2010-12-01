#include FcnLib.ahk

ForceWinFocus("Administrator: Command Prompt")
MouseClick, left,  408,  316
Sleep, 100
Send, {CTRLDOWN}
MouseClick, right,  100,  100
Sleep, 100
{CTRLUP}
ForceWinFocus("Select Administrator: Command Prompt")
Send, {CTRLDOWN}{CTRLUP}
ForceWinFocus("Administrator: Command Prompt")
Send, {CTRLDOWN}{CTRLUP}`