/**
 * OCR library test script by camerb
 *
 * Tests to verify that the OCR script is running correctly
*/

#SingleInstance force
#Include OCR.ahk
;#Include C:\Dropbox\ahks\FcnLib.ahk

tests=GhettoBasicTest,GhettoBasicTest
tests=ReturnsTrue,ReturnsFalse
Loop, parse, tests, CSV
{
   testResults .= DynamicallyRunTest(A_LoopField)
}
msgbox %testresults%
ExitApp

if GhettoBasicTest()
   msgbox, tests passed
else
   msgbox, drat. tests failed

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;end of tests
ExitApp
;exit hotkeys
Esc:: ExitApp

hi()
{
   msgbox, hi
}
returnstrue()
{
   return true
}
returnsfalse()
{
   return false
}



DynamicallyRunTest(testName)
{
   results := %testName%()
   fullMessage=%results%: %testName%`n
   return fullMessage
}

GhettoBasicTest()
{
   expected=Company Processes
   img=C:\Dropbox\Public\ocr-tests\%expected%.jpg

   Run http://dl.dropbox.com/u/789954/ocr-tests/%expected%.jpg
   sleep, 2000

   ;FIXME not sure why, but if you don't move the window to the top-left
   ;   seems like it is using the Screen CoordMode, which seems odd
   WinMove, %expected%, , 0, 0
   Sleep 100

   text := GetOCR()
   sleep, 1000

   ToolTip, %text%
   Sleep, 2000

   returned := false
   if InStr(text, expected)
      returned := true

   return returned
}
