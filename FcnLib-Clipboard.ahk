;#include FcnLib.ahk

;FcnLib-Clipboard.ahk by camerb

;This library contains a bunch of functions that make using the clipboard easier and more reliable

copy()
{
   Send, {CTRL DOWN}
   Sleep, 500
   Send, c
   Sleep, 500
   Send, {CTRL UP}
}

paste()
{
   Send, {CTRL DOWN}
   Sleep, 500
   Send, v
   Sleep, 500
   Send, {CTRL UP}
}

;this is what I've got at the moment... it needs to be refined
CopyWait()
{
   ;number to verify that the clipboard was never assigned to
   null:=Random(100000,999999)
   Clipboard:=null

   Sleep, 100
   Send, ^c
   Send, ^c
   Send, ^c
   Send, ^c
   Sleep, 100
   ;ClipWait, 2
   ;debug("silent log", "just copied to clipboard")
   count=0
   Loop
   {
      count++
      if (Clipboard != null)
      {
         ;if (count >= 2)
            ;debug("silent log yellow line", "clipboard is no longer null after # of tries:", count)
         break
      }
      Sleep, 100
   }

   ;TODO return false if error?
}

;rewrite of the clipwait command
ClipWait(clipboardContentsToWaitFor, options="")
{

}

;TODO ClipWaitNull(), ClipWaitNotNull()
