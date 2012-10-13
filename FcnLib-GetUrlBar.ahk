
#include thirdParty/DDE/DDEML.ahk

;gets the contents of the url bar for firefox, iexplore or opera, and soon chrome, too!!!
GetURLbar(browser)
{
   if (browser = "chrome")
   {
      prevMode  := A_TitleMatchMode
      prevSpeed := A_TitleMatchModeSpeed
      SetTitleMatchMode, RegEx
      SetTitleMatchMode, Slow
      WinGetText, winText, .* \- Google Chrome ahk_class Chrome_WidgetWin_1
      SetTitleMatchMode, %prevMode%
      SetTitleMatchMode, %prevSpeed%
      ;debug(wintext)
      ;RegExMatch(winText, "(.*)\n([^\n])", line)
      ;urlRegEx=(?i)\b((?:[a-z][\w-]+:(?:/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?«»“”‘’]))
      ;RegExMatch(winText, urlRegEx, match)
      RegExMatch(winText, "(?i)\b((?:[a-z][\w-]+:(?:/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'"".,<>?«»“”‘’]))", url)
      ;FIXME - it appears that the URL is always on the last line, not sure
      ;  maybe we need to use a regex to find the https, or /, or something

      ;StringSplit, line, winText, `n

      ;TODO REMOVEME - this will not work in a public lib
      QuickFileOutput("browser: " . browser . "`nI think this is the url: " . url . "`n`nwintext:`n" . wintext)

      return url
   }
   else if ( RegExMatch(browser, "^(firefox|iexplore|opera)$") )
   {
      ;browser ;sServer := "firefox"   ; iexplore, opera
      sTopic  := "WWW_GetWindowInfo"
      sItem   := "0xFFFFFFFF"

      idInst  := DdeInitialize()

      hServer := DdeCreateStringHandle(idInst, browser)
      hTopic  := DdeCreateStringHandle(idInst, sTopic )
      hItem   := DdeCreateStringHandle(idInst, sItem  )

      hConv := DdeConnect(idInst, hServer, hTopic)
      hData := DdeClientTransaction(0x20B0, hConv, hItem)   ; XTYP_REQUEST
      ddeText := DdeAccessData(hData)

      DdeFreeStringHandle(idInst, hServer)
      DdeFreeStringHandle(idInst, hTopic )
      DdeFreeStringHandle(idInst, hItem  )

      DdeUnaccessData(hData)
      DdeFreeDataHandle(hData)
      DdeDisconnect(hConv)
      DdeUninitialize(idInst)

      Loop, parse, ddeText, CSV
      {
         returned := A_LoopField
         break
      }

      return returned
   }
   else
   {
      returned := browser . " IS NOT A VALID OPTION FOR BROWSER PARAMETER - possible options are: firefox, chrome, iexplore, opera"
      return returned
   }
}
