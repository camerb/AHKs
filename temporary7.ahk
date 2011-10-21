#include FcnLib.ahk
#include FcnLib-Nightly.ahk

Loop 20
{
ProcessClose("firefox.exe")
ProcessClose("firefoxPortable.exe")
}

TestIMacro("usaa.com")
TestIMacro("google.com")
TestIMacro("yahoo.com")
TestIMacro("bing.com")


TestIMacro(url)
{
   ;REMOVEME
   result := "bad "

   imacro=URL GOTO=%url%
   RunIMacro(imacro)
   page := iMacroUrlDownloadToVar()
   if InStr(page, url)
   {
      boolResult := true
      result := "good"
   }
   AddToTrace(result, url, A_ComputerName)
}
