#include FcnLib.ahk

param=%1%
tempFile=todo/ahk_tasks.txt
libFile=FcnLib.ahk

if (param <> "copyTasksToFcnLib")
{
   task := prompt("What AHK functionality do you want to put in your TODO list?")
   task=;WRITEME %task%
   FileAppendLine(task, tempFile)
}
else
{
   if FileExist(tempfile)
   {
      tasks := FileRead(tempFile)
      FileAppendLine("", libFile)
      FileAppendLine(tasks, libFile)
      FileDelete(tempFile)
   }
}
