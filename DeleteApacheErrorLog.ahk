#include FcnLib.ahk

path=C:\Program Files (x86)\Apache Software Foundation\Apache2.2\logs\error.log
RunWait, "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\bin\httpd.exe" -w -n "Apache2.2" -k stop
FileDelete, %path%
FileAppend, hello world`n, %path%
RunWait, "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\bin\httpd.exe" -w -n "Apache2.2" -k start
