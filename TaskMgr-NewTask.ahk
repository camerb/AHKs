#include FcnLib.ahk
#singleinstance force

InputBox, taskName, New Task, Enter the name of the task
CurrentTime:=CurrentTime("hyphenated")

todoPath=%A_WorkingDir%\todo
FileCreateDir, %todoPath%
FileAppend, %taskName%, %todoPath%\%CurrentTime%.txt
