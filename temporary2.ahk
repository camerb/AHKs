#include FcnLib.ahk


Loop, C:\Users\Name\Documents\usb backup\, 1, 1
{
  possiblePath=H:\%A_LoopFileName%
  if RegExMatch(A_LoopFileExt, "(xls|doc)")
    FileCopy, %A_LoopFileFullPath%, %PossiblePath%
 }
