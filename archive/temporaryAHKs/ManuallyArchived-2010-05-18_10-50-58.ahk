#include FcnLib.ahk

dd=%1%
if (dd=="")
   fatalerror("INCORRECT USAGE`n`nPROPER USAGE IS: ahk.exe ssmsAppPath user pass destDbName")

ssmsAppPath=%1%
user=%2%
pass=%3%
destDbName=%4%

Run, %ssmsAppPath%

WinWait, Connect to Server
Sleep, 100
Click(200, 190)

Send, ^a
Sleep, 100
Send, %user%{TAB}
Sleep, 100
Send, ^a
Sleep, 100
Send, %pass%
Sleep, 100

Click(110, 280)

ForceWinFocus("Microsoft SQL Server Management Studio ahk_class wndclass_desked_gsk", "Exact")

WaitForImageSearch("C:\DataExchange\InstantAhkImage\20100513154755ExpandDatabases.bmp")
ClickIfImageSearch("C:\DataExchange\InstantAhkImage\20100513154755ExpandDatabases.bmp")

WaitForImageSearch("C:\DataExchange\InstantAhkImage\20100513154921RightClickDb.bmp")
ClickIfImageSearch("C:\DataExchange\InstantAhkImage\20100513154921RightClickDb.bmp", "Right")

WaitForImageSearch("C:\DataExchange\InstantAhkImage\20100513155051HoverOverTasksMenu.bmp")
ClickIfImageSearch("C:\DataExchange\InstantAhkImage\20100513155051HoverOverTasksMenu.bmp")

WaitForImageSearch("C:\DataExchange\InstantAhkImage\20100513155206ClickCopyDatabase.bmp")
ClickIfImageSearch("C:\DataExchange\InstantAhkImage\20100513155206ClickCopyDatabase.bmp")

WinWait, Copy Database Wizard
Sleep, 100
Click(430, 470)

WinWait, , Which server do you want to move or copy the databases from?
;Click(310, 240)
;used to type login info here
Sleep, 100
Click(430, 470)

WinWait, , Which server do you want to move or copy the databases to?
;Click(310, 240)
;used to type login info here
Sleep, 100
Click(430, 470)

WinWait, , How would you like to transfer the data?
Click(430, 470)

WinWait, , Which databases would you like to move or copy?
Click(430, 470)

WinWait, , Specify database file names and whether to overwrite existing databases at the destination.
SendInput, destDbName
Sleep, 100
Click(430, 470)

;IfWinExist, , Database name already exists at destination
   ;fatalerror()

WinWait, , The wizard will create a Integration Services package with the properties you specify below.
Click(430, 470)

WinWait, , Schedule the SSIS Package
Click(430, 470)

WinWait, , Verify the choices made in the wizard and click Finish.
Click(500, 470)

seen:=WaitForImageSearch("C:\DataExchange\InstantAhkImage\20100513161714WaitForSuccessMessage.bmp", 0, 1000)
if NOT seen
   fatalerror()

WinClose, Copy Database Wizard
WinClose, Microsoft SQL Server Management Studio ahk_class wndclass_desked_gsk

FatalError(description="Fatal Error")
{
   debug(description)
   ExitApp 1
}
