#include FcnLib.ahk

Loop 20
{
   ProcessClose("vmware-vmx.exe")
   ProcessClose("vmplayer.exe")
}
Sleep, 10000

Run, C:\XPVM\Windows XP Professional.vmx

;Run, "C:\Program Files (x86)\VMware\VMware Player\vmplayer.exe"
;ForceWinFocus("ahk_class VMPlayerFrame")
;file=images\vmware\phosphorusVmButton.bmp
;WaitForImageSearch(file)
;ClickIfImageSearch(file)
;Click

;if (A_ComputerName = "PHOSPHORUS")
   ;Send, ^!5
