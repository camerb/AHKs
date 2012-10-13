#include FcnLib.ahk
#include FcnLib-Nightly.ahk
;#include Lynx-FcnLib.ahk
;#include Lynx-ProcedureParts.ahk
;#include Lynx-UpdateParts.ahk

servers=release,test,t-2008,t-2003,t-1,t-800,primaryfo,secondaryfo,kp
Loop, parse, servers, CSV
{
   allInfo .= GetLynxVersionOnServer(A_LoopField, "test") . "`n"
   allInfo .= GetLynxVersionOnServer(A_LoopField, "security") . "`n"
}
debug(allInfo)


GetLynxVersionOnServer(server, user)
{
iMacro=
(
VERSION BUILD=7401004 RECORDER=FX
TAB T=1
URL GOTO=http://%server%/cgi/logon.plx?Option=Logout
URL GOTO=http://%server%/login/
TAG POS=1 TYPE=INPUT:TEXT FORM=NAME:Login_Form ATTR=NAME:UserID CONTENT=%user%
SET !ENCRYPTION NO
TAG POS=1 TYPE=INPUT:PASSWORD FORM=NAME:Login_Form ATTR=NAME:Password CONTENT=test
TAG POS=1 TYPE=INPUT:SUBMIT FORM=NAME:Login_Form ATTR=NAME:Enter&&VALUE:Enter<SP>Site
URL GOTO=http://%server%/cgi/home.plx
)

   RunIMacro(imacro)
   homePageText := IMacroUrlDownloadToVar(server . "/cgi/home.plx")
   ;ProcessCloseAll("firefox.exe")
   RegExMatch(homePageText, "Ver\=(\d(\.\d+){3})", match)
   if match1
   {
      versionNumber := match1
      ini := GetPath("LynxStats.ini")
      IniWrite( ini, "VersionsOnServers", server, versionNumber )
   }
   ;else
      ;versionNumber := "N/A"

   ;msg=%versionNumber% %server%
   return versionNumber
   ;return msg
}
