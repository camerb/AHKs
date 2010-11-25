#include iWeb.ahk

;~ log into gmail
email=email@google.com
pass=123456
iWeb_Init()
gmail:=iWeb_Model()
iWeb_nav(gmail,"http://mail.google.com/mail?hl=en")
iWeb_setDomObj(gmail,"Email,Passwd",email "," pass)
iWeb_clickValue(gmail,"Sign in")
iWeb_Release(gmail)
iWeb_Term()

;~ log into msn
login=email@google.com
passwd=123456
iWeb_Init()
msn:=iWeb_Model()
iWeb_nav(msn,"http://mail.live.com/")
iWeb_setDomObj(msn,"login,passwd",login "," passwd)
iWeb_clickValue(msn,"Sign in")
iWeb_Release(msn)
iWeb_Term()
