#include FcnLib.ahk

Loop, C:\code\Bench\root\static\js\lib\ux\*.js, 0, 1
{
   FileAppend, `"%A_LoopFileFullPath%`"`,`n, C:\DataExchange\paths.txt
}
