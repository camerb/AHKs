#include FcnLib.ahk

Loop,C:\code\Revertion Archive\Bench\2010-07-02_09-29-56 adding basic update source\.svn, 2, 1
{
   ;text=%text%`n%A_LoopFileFullPath%
   FileRemoveDir, %A_LoopFileFullPath%, 1
}
;msgbox, %text%
