;#include FcnLib.ahk

;FcnLib-Clipboard.ahk by camerb

;This library contains a bunch of functions that make using the clipboard easier and more reliable

;NOTE that this should not wait at the end...
copy(options="")
{
   sleepTime:=100
   if InStr(options, "fast")
      sleepTime:=10
   else if InStr(options, "noSleep")
      sleepTime:=0
   else if InStr(options, "slow")
      sleepTime:=500

   Send, {CTRL DOWN}
   Sleep, %sleepTime%
   Send, c
   Sleep, %sleepTime%
   Send, {CTRL UP}
}

;note that you need to paste in a ghetto way for the cmd prompt
paste(options="")
{
   sleepTime:=100
   if InStr(options, "fast")
      sleepTime:=10
   else if InStr(options, "noSleep")
      sleepTime:=0
   else if InStr(options, "slow")
      sleepTime:=500

   Send, {CTRL DOWN}
   Sleep, %sleepTime%
   Send, v
   Sleep, %sleepTime%
   Send, {CTRL UP}
}

;this is what I've got at the moment... it needs to be refined
CopyWait(options="")
{
   Clipboard := "null"
   ClipWait("null")

   copy(options)

   ClipWaitNot("null")

   return ClipboardContents

   ;number to verify that the clipboard was never assigned to
   ;null:=Random(100000,999999)
   ;Clipboard:=null

   ;Sleep, 100
   ;copy()
   ;count=0
   ;Loop
   ;{
      ;count++
      ;if (Clipboard != null)
      ;{
         ;;if (count >= 2)
            ;;debug("silent log yellow line", "clipboard is no longer null after # of tries:", count)
         ;break
      ;}
      ;Sleep, 100
   ;}

   ;TODO return false if error?
}

;TODO options (like a timeout)
;TODO options "notEqual" (then condense the ClipWait and ClipWaitNot into one
;rewrite of the clipwait command
ClipWait(clipboardContentsToWaitFor, options="")
{
   Loop
   {
      ClipboardContents := Clipboard
      if (ClipboardContents == clipboardContentsToWaitFor)
         break
      Sleep, 50
   }
}

ClipWaitNot(clipboardContentsToWaitFor, options="")
{
   Loop
   {
      ClipboardContents := Clipboard
      if (ClipboardContents != clipboardContentsToWaitFor)
         break
      Sleep, 50
   }
}

;TODO ClipWaitNull(), ClipWaitNotNull()
; maybe waiting for it to be empty is the best solution... who would ever copy nothing?
; then again, there are probably some times when we want to wait for it to contain the text "null"
