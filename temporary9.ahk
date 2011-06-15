#include FcnLib.ahk
#include thirdParty/COM.ahk
;#include thirdParty/IEReady.ahk

;Awesome use of COM to log in to usaa

COM_Init()
pwb := COM_CreateObject("InternetExplorer.Application")
COM_Invoke(pwb , "Visible=", "True")
;COM_Invoke(pwb, "Navigate", "javascript: alert('Hello World!')")

url:="http://www.usaa.com"
COM_Invoke(pwb, "Navigate", url)
WaitIEReady(pwb)
COM_Invoke(pwb, "document.all.j_username.value", "macnmel17")
COM_Invoke(pwb, "document.all.j_password.value", SexPanther())
Sleep, 200
;COM_Invoke(pwb, "document.getElementsByTagName[input].item[11].click")
Send, {ENTER}
Sleep, 200
Send, {ENTER}
WaitIEReady(pwb)
text := COM_Invoke(pwb, "document.documentElement.innerText")
text := COM_Invoke(pwb, "document.documentElement.innerHTML")
COM_Invoke(pwb, "Quit")
COM_Term()

debug(text)
ExitApp

WaitIEReady(pwb)
{
   While, COM_Invoke( pwb, "ReadyState" ) <> 4
      Sleep, 10
   SleepSeconds(1)
}
