#include FcnLib.ahk

Run, C:\LynxCD\Server 7.11\Setup\apache_2.2.8-win32-x86-openssl-0.9.8g.msi

SleepSeconds(1)
SleepSend("!n")
SleepSend("!a")
SleepSend("!n")
SleepSend("!n")
SleepSend("!n")
SleepSend("!n")
SleepSend("!n")
SleepSend("!i")
WinWaitActive, , The Installation Wizard has successfully installed Apache
SleepSend("!f")

SleepSeconds(1)
FileCopy("C:\LynxCD\Server 7.11\Setup\httpd.conf", "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\conf\httpd.conf", "overwrite")

RestartService("apache2.2")
