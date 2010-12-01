#include FcnLib.ahk

dggg("hello")
dggg("hello", "mult params", "222", 333)
dggg("noLog", "do not log this one params", "222", 333)
dggg("noLog TrayMsg", "sdfasd fasdfa sdfa sdf sd")

;Debug vs Errord: Silent/Traytip/Msgbox/Overlay, Logged/Not, Info/Warning/Error
;
;Send an error message with as many parameters as necessary, save debug information to dropbox logs section
dggg(textOrOptions, text1="", text2="", text3="", text4="", text5="", text6="", text7="", text8="", text9="", text10="", text11="", text12="", text13="", text14="", text15="")
{
   loggedMode:=true
   silentMode:=false
   trayMsgMode:=false
   errordMode:=false
   if (InStr(textOrOptions, "trayMsg"))
      trayMsgMode := true
   if (InStr(textOrOptions, "silent"))
      silentMode := true
   if (InStr(textOrOptions, "log"))
      loggedMode := true
   if (InStr(textOrOptions, "nolog"))
      loggedMode := false
   if (InStr(textOrOptions, "errord"))
      errordMode := true

   ;put together the message
   if (errordMode)
      messageText:="ERROR: "
   else
      messageText:="Debug: "
   messageText.=CurrentTime("hyphenated")
   messageText.=A_Space
   messageText.=A_ScriptFullPath
   messageText.=A_Space
   messageText.=textOrOptions
   loop 15
   {
      messageText.=A_Space
      messageText.=text%A_Index%
   }
   messageText.="`n`n"

   ;log the message right away
   if loggedMode
   {
      logPath=%A_WorkingDir%\logs
      FileCreateDir, %logPath%
      FileAppend, %messageText%, %logPath%\%A_ComputerName%.log
   }

   ;display info to the user
   if NOT silentMode
   {
      if trayMsgMode
      {
         if (errordMode)
            TrayMsg("AHK Error", messageText, 20, 3)
         else
            TrayMsg("AHK Debug", messageText, 20, 3)
      }
      else if overlayMode
         msgbox, , , %messageText%, 2
      else
         msgbox, , , %messageText%, 2
   }
}

eggg(textOrOptions, text1="", text2="", text3="", text4="", text5="", text6="", text7="", text8="", text9="", text10="", text11="", text12="", text13="", text14="", text15="")
{
   textOrOptions=%textOrOptions% log errord
   dggg(textOrOptions, text1, text2, text3, text4, text5, text6, text7, text8, text9, text10, text11, text12, text13, text14, text15)
}
