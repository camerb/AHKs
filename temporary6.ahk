#include FcnLib.ahk

Process, Exist, openvpn-gui.exe
debug(errorlevel)
Run, C:\Program Files\Astaro\Astaro SSL VPN Client\bin\openvpn-gui.exe

;how on earth do i tell it to open the connect dialog via the command line?
