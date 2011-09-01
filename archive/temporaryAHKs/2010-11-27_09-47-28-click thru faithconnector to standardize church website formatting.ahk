#include FcnLib.ahk

sleepNum=250
longSleep=10000

Loop, read, C:\Dropbox\AHKs\REFP\out1.txt
{
   cmd=%A_LoopReadLine%
   debug(cmd)
   if NOT cmd == ""
   {
      Run, %cmd%

      Sleep, %longSleep%

      ForceWinFocus("centralrichardson.com.* - Google Chrome", "RegEx")
      MouseClick, left,  673,  270
      Sleep, %sleepNum%
      MouseClick, left,  696,  877
      Sleep, %sleepNum%
      Send, {CTRLDOWN}a{CTRLUP}
      MouseClick, left,  577,  804
      Sleep, %sleepNum%
      MouseClick, left,  598,  825
      Sleep, %sleepNum%
      MouseClick, left,  622,  804
      Sleep, %sleepNum%
      MouseClick, left,  637,  831
      Sleep, %sleepNum%
      MouseClick, left,  631,  584
      Sleep, %sleepNum%
      MouseClick, left,  631,  584
      Sleep, %sleepNum%
      Send, {PGDN}
      MouseClick, left,  583,  519
      Sleep, %sleepNum%
      MouseClick, left,  157,  636
      Sleep, %sleepNum%
      Send, {CTRLDOWN}a{CTRLUP}
      MouseClick, left,  591,  517
      Sleep, %sleepNum%
      MouseClick, left,  604,  542
      Sleep, %sleepNum%
      MouseClick, left,  616,  514
      Sleep, %sleepNum%
      MouseClick, left,  631,  543
      Sleep, %sleepNum%
      MouseClick, left,  1484,  904
      Sleep, %sleepNum%
      Send, {PGDN 50}
      MouseClick, left,  245,  918
      MouseClick, left,  245,  900
      MouseClick, left,  245,  880
      Sleep, %sleepNum%

      Sleep, %longSleep%

      Send, ^w
   }
}
