#include FunctionLibrary.ahk

ForceWinFocus("Mozilla Firefox", "Contains")
Send, ^+{DEL}
ForceWinFocus("Clear Recent History", "Exact")
Send, {ENTER}
