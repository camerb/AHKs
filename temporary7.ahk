#include FcnLib.ahk
#include FcnLib-Clipboard.ahk

;testing clipboard functions

Loop 20000
{
TestIt("hi")
TestIt("hi")
TestIt("hi")
TestIt("asdfsfs adsf adsf qfsswer qewr qwer")
TestIt("asdf adsfsdfgsdf adsf qwer qewr qwer")
TestIt("asdf adsf adsf qwer qewsdfgsr qwer")
TestIt("asdf adfgsdfgsf adsf qwer qewr qwer")
TestIt("asdf adsf adsf qwsdfgesr qewr qwer")
}
;debug("results:", allResults)

ExitApp

TestIt(text)
{
   global allResults
   file=C:\Dropbox\AHKs\gitExempt\ClipboardTest.txt
   RunAhk("ClipboardTest.ahk")
   ForceWinFocus("AHK Clipboard Test")
   expected:=text
   FileCreate(text, file)

   ;testing clipboard functionsGetPath("ClipboardTest.txt"))
   Sleep, 100
   Send, !l
   Send, ^a
   actual:=CopyWait()
   ;actual=
   result := (expected == actual)

   ;debug("", result, expected, actual)
   Send, !e
   if NOT result
   {
      allResults.="X"
      iniPP("CopyWait Test Failed")
      iniPP("CopyWait Test gave " . actual . " expected:" . expected)
   }
   else
   {
      allResults.="."
      iniPP("CopyWait Test Succeeded")
   }
   ;Sleep, 1000

   return result
}

#include fireflyButtons.ahk

