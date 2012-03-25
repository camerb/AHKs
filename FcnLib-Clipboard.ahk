;#include FcnLib.ahk

;FcnLib-Clipboard.ahk by camerb

;This library contains a bunch of functions that make using the clipboard easier and more reliable

;NOTE that this should not wait at the end...
copy(options="")
{
   ;this seems super stupid... why would i do all this junk?
   ;0    ""
   ;10   "cautious"
   ;100  "slow"
   ;500  "super slow"
   ;1000 "super super slow"

   sleepTime:=10
   if InStr(options, "fast")
      sleepTime:=10
   else if InStr(options, "noSleep")
      sleepTime:=0
   else if InStr(options, "slow")
      sleepTime:=100

   Send, {CTRL DOWN}
   Sleep, %sleepTime%
   Send, c
   Sleep, %sleepTime%
   Send, {CTRL UP}
   Sleep, %sleepTime%
   Send, ^c
}

;TODO you need to paste in a ghetto way for the cmd prompt
paste(options="")
{
   sleepTime:=10
   if InStr(options, "fast")
      sleepTime:=10
   else if InStr(options, "noSleep")
      sleepTime:=0
   else if InStr(options, "slow")
      sleepTime:=100

   Send, {CTRL DOWN}
   Sleep, %sleepTime%
   Send, v
   Sleep, %sleepTime%
   Send, {CTRL UP}
}

CopyWait2(options="useNull")
{
   knownClipboard:="null"
   if InStr(options, "useBlank")
      knownClipboard:=""

   Clipboard:=knownClipboard
   ClipWait(knownClipboard)
   ss()
   copy()
   ;Send, {CTRLDOWN}c{CTRLUP}
   ss()
   ClipWaitNot(knownClipboard)

   returned:=Clipboard
   return returned
}

CopyWait(options="useNull")
{
   knownClipboard:="null"
   if InStr(options, "useBlank")
      knownClipboard:=""

   Clipboard:=knownClipboard
   ClipWait(knownClipboard)
   ss()
   copy()
   ;Send, {CTRLDOWN}c{CTRLUP}
   ss()
   ClipWaitNot(knownClipboard)

   returned:=Clipboard
   return returned
}

/*
CopyWait2()
{
   Clipboard:=""
   ClipWait("")
   ss()
   copy()
   ;Send, {CTRLDOWN}c{CTRLUP}
   ss()
   ClipWaitNot("")

   returned:=Clipboard
   return returned
}
*/
/*

;this is what I've got at the moment... it needs to be refined
CopyWait(options="")
{
   null := "null"
   Clipboard := null
   iniPP("before ClipWait(null)")
   ClipWait(null)
   iniPP("after ClipWait(null)")

   copy(options)

   iniPP("before wait for clip contents")
   ;ClipWaitNot(null)
   Loop 30
   {
      count++
      if (Clipboard != null)
      {
         if (count >= 2)
            iniPP("clipboard no longer null after # of tries: " . count)
            ;debug("silent log yellow line", "clipboard is no longer null after # of tries:", count)
         break
      }
      copy()
      Sleep, 10
   }
   iniPP("after wait for clip contents")

   return Clipboard

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
*/

;TODO options (like a timeout)
;TODO options "notEqual" (then condense the ClipWait and ClipWaitNot into one
;Waits for the clipboard to contain a specified string (exact match)
ClipWait(clipboardContentsToWaitFor, options="")
{
   Loop 10
   {
      ClipboardContents := Clipboard
      if (ClipboardContents == clipboardContentsToWaitFor)
         break

      Sleep, 10
   }
}

ClipWaitNot(clipboardContentsToWaitFor, options="")
{
   Loop 10
   {
      ClipboardContents := Clipboard
      if (ClipboardContents != clipboardContentsToWaitFor)
         break

      Sleep, 10
   }
}

;This is kinda similar to the Send or SendInput methods, except that it uses the clipboard to send text
SendViaClip(text)
{
   ;hey wait... we know what we want to put on the clipboard, so just check if that is equal

   knownClipboard:=""
   Clipboard:=knownClipboard
   ClipWait(knownClipboard)
   Clipboard:=text
   ClipWaitNot(knownClipboard)
   paste()
}

;TODO ClipWaitNull(), ClipWaitNotNull()
; maybe waiting for it to be empty is the best solution... who would ever copy nothing? answer: me, when I am trying to scan through empty cells in Mel's ASE macro
; then again, there are probably some times when we want to wait for it to contain the text "null"
