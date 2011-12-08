#include FcnLib.ahk

debug("Starting hotkey unit tests") ;{{{

;close all friggin pidgin windows so i don't spam them
Loop 10
   Process, Close, pidgin.exe
   ;WinClose, ahk_class gdkWindowToplevel

TestDirExist()
TestIsMinimizedIsMaximized()
TestForceWinFocusIfExist()
TestDebugBool()
TestGetXmlElement()
;TODO run tests for OCR lib
;TestSendViaClipboard() ;TODO let's stop testing this for now and make something that will test the entire clipboard lib well...
;TODO test InStr with case insensitivity

debug("Tests have finished") ;}}}

;#####################################################

TestDebugBool() ;{{{
{
   falseVar:=false
   trueVar:=true

   ;Vals that are blank
   AssertDebugBool("empty", "")
   AssertDebugBool("empty", undefVar)

   ;Vals that equate to 0
   AssertDebugBool("false", falseVar)
   AssertDebugBool("false", 0)

   ;Vals that equate to 1
   AssertDebugBool("true", trueVar)
   AssertDebugBool("true", 1)

   ;Other values
   AssertDebugBool("Some text", "Some text")
   AssertDebugBool("Other darned text", "Other darned text")
}

AssertDebugBool(assert, var)
{
   result:=DebugBool(var)
   if NOT InStr(result, assert)
      Errord("Failed Test:", A_ThisFunc, "Provided:", var, "Expected:", assert, "Actual:", result)
} ;}}}

TestIsMinimizedIsMaximized() ;{{{
{
   SetTitleMatchMode, RegEx

   ;Skip this test if we can't run it
   IfWinExist, Notepad
   {
      Errord("Skipped Test of IsMinimized() and IsMaximized()", "window named 'notepad' already exists")
      return
   }

   Run, Notepad.exe
   WinWait, Notepad
   ;Sleep 500
   AssertIsMaximized(false, "Notepad", "Should be windowed")
   AssertIsMinimized(false, "Notepad", "Should be windowed")
   WinMaximize, Notepad
   ;Sleep 500
   AssertIsMaximized(true, "Notepad", "Should be maximized")
   AssertIsMinimized(false, "Notepad", "Should be maximized")
   WinMinimize, Notepad
   ;Sleep 500
   AssertIsMaximized(false, "Notepad", "Should be minimized")
   AssertIsMinimized(true, "Notepad", "Should be minimized")
   WinClose, Notepad
}

AssertIsMaximized(assert, var, description)
{
   if (IsMaximized(var)<>assert)
      Errord("Failed Test:", A_ThisFunc, description, var)
}

AssertIsMinimized(assert, var, description)
{
   if (IsMinimized(var)<>assert)
      Errord("Failed Test:", A_ThisFunc, description, var)
} ;}}}

TestDirExist() ;{{{
{
   AssertDirExist(true,  A_ProgramFiles, "Program Files")
   AssertDirExist(true,  A_WinDir, "Windows Dir")
   AssertDirExist(false, "C:\dirifaasdfkh", "Fake-o")
   AssertDirExist(false, "C:\Program Files\asdfakjsh", "Sub fake-o")
}

AssertDirExist(assert, var, description)
{
   result:=DirExist(var)
   if (result<>assert)
      Errord("Failed Test:", A_ThisFunc, description, var)
} ;}}}

TestForceWinFocusIfExist() ;{{{
{
   SetTitleMatchMode, RegEx

   ;Skip this test if we can't run it
   IfWinExist, Notepad
   {
      Errord("Skipped Test of AssertForceWinFocusIfExist()", "window named 'notepad' already exists")
      return
   }

   Run, Notepad.exe
   WinWait, Notepad
   Sleep, 100
   AssertForceWinFocusIfExist(true, "Notepad", "Window should exist")
   Sleep, 100
   WinMaximize, Notepad
   Sleep, 100
   AssertForceWinFocusIfExist(true, "Notepad", "Window should exist")
   Sleep, 100
   WinClose, Notepad
   Sleep, 100
   AssertForceWinFocusIfExist(false, "Notepad", "Window should not exist")
}

AssertForceWinFocusIfExist(assert, var, description)
{
   if (ForceWinFocusIfExist(var)<>assert)
      Errord("Failed Test:", A_ThisFunc, description, var)
} ;}}}

TestSendViaClipboard() ;{{{
{
   ;Skip this test if we can't run it
   IfWinExist, Notepad
   {
      Errord("Skipped Test:", A_ThisFunc, "window named 'notepad' already exists")
      return
   }

   AssertSendViaClipboard("Before, before, before", "Sent via clipboard", "basic test of send text")
   AssertSendViaClipboard("Prior", "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboard", "Test of Sending a large chunk of text")
   AssertSendViaClipboard("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, before", "Sent via clipboard", "Testing replacing a large chunk that was already on the clipboard")
   AssertSendViaClipboard("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, beforeefore, before, before", "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboardent via clipboard", "Testing both a large chunk prior and sending a large chunk via clipboard")
}

AssertSendViaClipboard(before, var, description)
{
   path:="C:\DataExchange\AhkTesting"
   FileCreateDir, %path%
   time:=CurrentTime()
   fileResult=%path%\%time%-result.txt
   fileExpected=%path%\%time%-expected.txt

   Run, Notepad.exe
   WinWaitActive, Notepad

   Send, %before%
   Sleep, 100
   Send, ^a^x
   Sleep, 100

   Send, ^v{ENTER 2}
   SendViaClipboard(var)
   Send, {ENTER 2}^v

   Send, ^s
   WinWaitActive, Save As
   Sleep, 100
   SendInput, %fileResult%{ENTER}
   Sleep, 1000

   WinClose, Notepad

   FileAppend, %before%`n`n%var%`n`n%before%, %fileExpected%

   result:=IsFileEqual(fileExpected, fileResult)
   if NOT result
      Errord("Failed Test:", A_ThisFunc, description, before, var)

   FileDelete, %fileExpected%
   FileDelete, %fileResult%
} ;}}}

TestGetXmlElement() ;{{{
{
   AssertGetXmlElement("5", "joe", "<joe>5</joe>", "simple test")
   AssertGetXmlElement("5", "joe", "sgdsafd<joe>5</joe>dsfsfdafds", "remove excess on ends")
   AssertGetXmlElement("asdf", "joe", "<joe>asdf</joe>", "multiple characters retreived")
   AssertGetXmlElement("5", "html.head.title", "<html><head><title>5</title></head></html>", "navigate through multiple emements")
}

;TODO finish this
AssertGetXmlElement(assert, path, xml, description)
{
   result:=GetXmlElement(xml, path)
   if (result<>assert)
      Errord("Failed Test:", A_ThisFunc, description, path, xml)
} ;}}}
