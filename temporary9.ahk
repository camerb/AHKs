#include FcnLib.ahk
#include thirdParty/COM.ahk

;show the jayski page in IE for 5 seconds

COM_Init()
pwb := COM_CreateObject("InternetExplorer.Application")
COM_Invoke(pwb , "Visible=", "True")
;COM_Invoke(pwb, "Navigate", "javascript: alert('Hello World!')")

url:="http://www.jayski.com"
COM_Invoke(pwb, "Navigate", url)
SleepSeconds(5)
COM_Invoke(pwb, "Quit")
COM_Term()
