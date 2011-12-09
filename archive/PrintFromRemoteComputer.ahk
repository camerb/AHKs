;an awesome little print helper that lagomorph made for using in his office
;this way one user uses cutepdf to save to a folder, then it is automatically printed from the other computer
;note that this could be used with Dropbox or with a shared network drive

printer := "\\129.174.79.115\HP Deskjet 9800 Series"
 
Loop
{
Sleep 1000
If (FileExist("I:\Catering\DONTTOUCH-AUTOPRINT\*.PDF"))
	{
	If (GetDefaultPrinter() != Printer) 
	   SetDefaultPrinter(Printer)
	Loop, I:\Catering\DONTTOUCH-AUTOPRINT\*.PDF
		{
		TrayTip, AHK » Printers and Faxes, Now printing file for Laura., 10, 17 
		Run, print %A_LoopFileLongPath%
		Sleep 10000
		FileDelete, %A_LoopFileLongPath%
		}
	}
}

GetDefaultPrinter() 
{ 
   nSize := VarSetCapacity(gPrinter, 256) 
   DllCall(A_WinDir . "\system\winspool.drv\GetDefaultPrinterA", "str", gPrinter, "UintP", nSize) 
   Return gPrinter 
} 
       
SetDefaultPrinter(sPrinter) 
{ 
   DllCall(A_WinDir . "\system\winspool.drv\SetDefaultPrinterA", "str", sPrinter) 
   TrayTip, AHK » Printers and Faxes, %sPrinter% set as default printer., 10, 17 
   Sleep, 3000 
   TrayTip 
} 
return 

