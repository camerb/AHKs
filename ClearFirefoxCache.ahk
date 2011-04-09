#include FcnLib.ahk

ForceWinFocus("Mozilla Firefox", "Contains")
Send, ^+{DEL}
ForceWinFocus("Clear All History", "Exact")
Send, {ENTER}
