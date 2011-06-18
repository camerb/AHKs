#include FcnLib.ahk
#include thirdParty/COM.ahk

;Awesome use of COM to log in to att

AutoTrim, Off

COM_Init()
pwb := COM_CreateObject("InternetExplorer.Application")
COM_Invoke(pwb , "Visible=", "True")
;COM_Invoke(pwb, "Navigate", "javascript: alert('Hello World!')")

url:="https://www.att.com/olam/loginAction.olamexecute?customerType=W"
COM_Invoke(pwb, "Navigate", url)
WaitIEReady(pwb)

user:="9723529639"
;StringReplace, user, user, -
COM_Invoke(pwb, "document.all.userid.value", user)
;COM_Invoke(pwb, "document.all.userid.value", "javascript: alert('Hello World!')")
COM_Invoke(pwb, "document.all.password.value", SexPanther("att"))

;Sleep, 200
;Send, {ENTER}
;Sleep, 200
;Send, {ENTER}
SleepSeconds(5)

;WaitIEReady(pwb)

COM_Invoke(pwb, "Quit")
COM_Term()

ExitApp

WaitIEReady(pwb)
{
   While, COM_Invoke( pwb, "ReadyState" ) <> 4
      Sleep, 10
   SleepSeconds(1)
}
