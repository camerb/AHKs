#include FcnLib.ahk

Loop, C:\code\Bench\var\maps\*.pdf, 0, 1
{
   FileAppend, `n%A_LoopFileName%, C:\code\Bench\script\db_scripts\008-maps-files.txt
}

