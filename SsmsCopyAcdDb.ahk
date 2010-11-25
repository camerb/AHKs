#SingleInstance

;Sleeps for a specified number of minutes
SleepMinutes(minutes)
{
   SleepSeconds(minutes*60)
}

;Sleeps for a specified number of seconds
SleepSeconds(seconds)
{
   Sleep 1000*seconds
}

;Quick way to get a short message for debugging that disappears after one second
Debug(text)
{
   MsgBox, , , %text%, 1
}

CustomTitleMatchMode(options="")
{
   ;By default this uses RegEx and Fast (no hidden window text detected)
   if (InStr(options, "Start"))
      SetTitleMatchMode, 1
   else if (InStr(options, "Contain") || InStr(options, "Anywhere"))
      SetTitleMatchMode, 2
   else if (InStr(options, "Exact"))
      SetTitleMatchMode, 3
   else if (InStr(options, "RegEx"))
      SetTitleMatchMode, RegEx
   else if (InStr(options, "Default"))
   {
      SetTitleMatchMode, 2
      SetTitleMatchMode, Fast
   }
   else
      SetTitleMatchMode, RegEx
}

ForceWinFocus(titleofwin, options="")
{
   CustomTitleMatchMode(options)

   WinWait, %titleofwin%,
   IfWinNotActive, %titleofwin%,
   WinActivate, %titleofwin%,
   WinWaitActive, %titleofwin%,

   CustomTitleMatchMode("Default")
}

ForceWinFocusIfExist(titleofwin, options="")
{
   returned:=false
   CustomTitleMatchMode(options)

   IfWinExist, %titleofwin%,
   {
      WinWait, %titleofwin%,
      IfWinNotActive, %titleofwin%,
      WinActivate, %titleofwin%,
      WinWaitActive, %titleofwin%,
      returned:=true
   }

   CustomTitleMatchMode("Default")

   return returned
}

;TESTME
SendViaClipboard(text)
{
   Sleep 100

   ;Save previous clipboard item
   ClipSaved := ClipboardAll

   Sleep 100

   ;Put item on the clipboard
   Clipboard := text

   ;May need to wait for a while
   ClipWait, 1

   MaxTimeToWait:=CurrentTimePlus(1)
   while (!CurrentlyAfter(MaxTimeToWait))
   {
      if (text==Clipboard)
         break
      if (text==ClipboardAll)
         break
      Sleep 50
   }

   Sleep 100

   ;Paste
   Send, ^v

   Sleep 100

   ;Restore clipboard contents, clear memory for storage variable
   Clipboard := ClipSaved
   ClipSaved=

   Sleep 100
}

;If you see the image, click it
ClickIfImageSearch(filename, clickOptions="left Mouse")
{
   if NOT FileExist(filename)
   {
      errord(A_ThisFunc, filename, "does not exist")
      return false
   }

   WinGetPos, no, no, winWidth, winHeight
   ImageSearch, xvar, yvar, 0, 0, winWidth, winHeight, %filename%

   if NOT ErrorLevel
      Click(xvar, yvar, clickOptions)

   return NOT ErrorLevel
}

;Wait until a certain image appears
WaitForImageSearch(filename, variation=0, timeToWait=20, sleepTime=20) ;TODO option to exit ahk if not found
{
   if NOT FileExist(filename)
   {
      errord(A_ThisFunc, filename, "does not exist")
      return false
   }

   TimeToStop:=CurrentTimePlus(timeToWait)
   while (CurrentlyBefore(TimeToStop))
   {
      WinGetPos, no, no, winWidth, winHeight
      ImageSearch, no, no, 0, 0, winWidth, winHeight, *%variation% %filename%

      if NOT ErrorLevel
         return true

      Sleep, sleepTime
   }

   return false
}

IsRegExMatch(Haystack, Needle)
{
   return RegExMatch(Haystack, Needle)<>""
}

Remap(input, remap1, replace1, remap2=0, replace2=0, remap3=0, replace3=0, remap4=0, replace4=0, remap5=0, replace5=0, remap6=0, replace6=0)
{
   if input=remap1
           return %replace1%
   if input=remap2
           return %replace2%
   if input=remap3
           return %replace3%
   if input=remap4
           return %replace4%
   if input=remap5
           return %replace5%
   if input=remap6
           return %replace6%
   return input
}

;I now think that moving to 0,0 is a better solution
MoveToRandomSpotInWindow()
{
   WinGetPos, no, no, winWidth, winHeight
   Random, xCoordinate, 0, winWidth
   Random, yCoordinate, 0, winHeight
   MouseMove, xCoordinate, yCoordinate
}

WeightedRandom(OddsOfa1, OddsOfa2, OddsOfa3=0, OddsOfa4=0, OddsOfa5=0)
{
   Random, input, 1, 100
   ;debug(input)
   OddsOfa2+=OddsOfa1
   OddsOfa3+=OddsOfa2
   OddsOfa4+=OddsOfa3
   OddsOfa5+=OddsOfa4
   if % input<=OddsOfa1
           return 1
   if % input<=OddsOfa2
           return 2
   if % input<=OddsOfa3
           return 3
   if % input<=OddsOfa4
           return 4
   if % input<=OddsOfa5
           return 5
   return 6
}

;Shows a debug message for a bool ("true" or "false")
DebugBool(bool)
{
   Debug(BoolToString(bool))
}

;Change a boolean to a string (more readable)
BoolToString(bool)
{
   if (bool)
      return "true"
   else
      return "false"
}

;TODO write
;Returns true if color1 is darker than color2
ColorIsDarkerThan(color1, color2)
{
;split into rgb numbers
;add rgb
;determine difference
}

;TODO write
;Continuously checks a pixel's color until it stabilizes at a certain color
;returns the color that it is holding at
WaitUntilColorStopsChanging(x, y)
{
   PixelGetColor, lastColor, x, y
   while lastColor<>currentColor
   {
      PixelGetColor, currentColor, x, y
      Sleep, 50
   }
   return currentColor
}

;TODO write
;Keeps clicking a spot until it is as dark/as light as possible
;(for selecting/deselecting a checkbox)
ForcePixelColorChangeByClicking(x, y, lightestOrDarkest, checkboxStates=2)
{
;MouseMove x, y
;current=WaitUntilColorStopsChanging(x, y)
;max=current
;Loop % checkboxStates
;{
;current=WaitUntilColorStopsChanging(x, y)
;if ColorIsDarkerThan(current, max)
;   max=current
;}
;while ColorIsDarkerThan(current, max)
;{
;
;current=WaitUntilColorStopsChanging(x, y)
;}
}

;TODO write
;Clicks at a specified location with ControlClick, MouseClick or Click
Click(xCoord, yCoord, options="Left Mouse")
{
   if (InStr(options, "Standard"))
   {
      if (InStr(options, "Right"))
         Click, right, %xCoord%, %yCoord%
      else
         Click, left, %xCoord%, %yCoord%
   }
   else if (InStr(options, "Mouse"))
   {
      if (InStr(options, "Right"))
         MouseClick, right, %xCoord%, %yCoord%
      else
         MouseClick, left, %xCoord%, %yCoord%
   }
   else if (InStr(options, "Control"))
   {
      if (InStr(options, "Right"))
         ControlClick, x%xCoord% y%yCoord%, , , right
      else
         ControlClick, x%xCoord% y%yCoord%, , , left
   }
   else
   {
      if (InStr(options, "Right"))
         Click, right, %xCoord%, %yCoord%
      else
         Click, left, %xCoord%, %yCoord%
   }
}

;TODO write
;Closes a window as gracefully as possible
CloseWindowGracefully(title, text="", xClickToClose="", yClickToClose="")
{
;Check if winexist each time (then return)

}

;Gets the current time (unique, increasing)
CurrentTime(hyphenated=false) ;TODO enable slashes or colons?
{
   if (hyphenated)
      FormatTime, returned,, yyyy-MM-dd_HH-mm-ss
   else
      FormatTime, returned,, yyyyMMddHHmmss
   return returned
}

;FIXME does not account for 60-99 seconds, etc...
;Gets the current time so that later a time comparison is possible
CurrentTimePlus(seconds)
{
   return CurrentTime() + seconds
}

;WRITEME TESTME
TimePlus(one, two)
{
   returned:=0
   returned+=Mod(one, 100) + Mod(two, 100)
   ;one/=100
   ;two/=100
   returned+=one
   return returned
}

;Checks if the current time is before the time that is passed in
CurrentlyBefore(time)
{
   return CurrentTime() < time
}

;Checks if the current time is after the time that is passed in
CurrentlyAfter(time)
{
   return CurrentTime() > time

;i.e.:
;Debug("starting timer")
;TimeToStop:=CurrentTimePlus(2)
;while true
;{
;   sleep 100 ; CheckSomeFooBar()...
;
;   if (CurrentlyAfter(TimeToStop))
;      break
;}
;Debug(TimeToStop)

}

;TODO test
;Starts a timer--to be used in conjunction with ElapsedTime()
StartTimer()
{
   return A_TickCount
}

;TODO test ;TODO rename to StopTimer?
;Provides the elapsed time since StartTimer() was called
ElapsedTime(StartTime)
{
returned := A_TickCount - StartTime
return returned
}

;TODO write
;Formats a millisec-time into something a bit more pretty
PrettyTime(TimeToFormat)
{

}

;Determines if the specified window is minimized
IsMinimized(title="", text="")
{
   SetTitleMatchMode, RegEx
   WinGet, winstate, MinMax, %title%, %text%
   IfWinExist, %title%, %text%
   {
      if (winstate=-1)
         return true
   }
   return false
}

;Determines if the specified window is minimized
IsMaximized(title="", text="")
{
   SetTitleMatchMode, RegEx
   WinGet, winstate, MinMax, %title%, %text%
   IfWinExist, %title%, %text%
   {
      if (winstate=1)
         return true
   }
   return false
}

;Closes open applications that usually are difficult for windows to shut down (preps for a restart)
CloseDifficultApps()
{
   while true
   {
      IfWinNotExist ahk_class MozillaUIWindowClass
         break
      WinClose ahk_class MozillaUIWindowClass
   }
}

;WRITEME
;Gets the parent directory of the specified directory

;WRITEME
;Returns true if the specified path is a directory, false if it is a file

;WRITEME
;Returns true if the specified path is a file, or false if it is a directory

;WRITEME
;Creates the parent dir if necessary
EnsureDirExists(path)
{
   ;if path is a file, this ensures that the parent dir exists
   ;if path is a directory, this ensures that that dir exists
   ;simply: this ensures that the entire specified dir structure exists

;figure out if it is a file or dir
;split off filename if applicable
   ;FileCreateDir,
}

;Returns if the directory exists
DirExist(dirPath)
{
   return InStr(FileExist(dirPath), "D") ? 1 : 0
}

;TESTME
;TODO Perhaps this should be done with other items, like the windows user folder
;Returns the correct program files location (error message if the file doesn't exist)
ProgramFilesDir(relativePath)
{
   ;ensure that the rel path starts with a slash
   if (SubStr(relativePath, 1, 1)="\")
      relativePath=\%relativePath%

   ;test the standard dir
   baseDir:="C:\Program Files"
   stdPath=%baseDir%%relativePath%
   if (FileExist(stdPath))
      return stdPath

   ;test the x86 dir
   x86:=" (x86)"
   x86Path=%baseDir%%x86%%relativePath%
   if (FileExist(x86Path))
      return x86Path

   Errord(A_ThisFunc, "was not able to find 'relativePath':", relativePath)
}

;TESTME especially silentMode
;TODO silentError parameter (meaning don't show the error message) maybe a quick parameter would be good, too (debug())
;Send an error message with as many parameters as necessary, save debug information to dropbox logs section
Errord(text, text1="", text2="", text3="", text4="", text5="", text6="", text7="", text8="", text9="", text10="", text11="", text12="", text13="", text14="", text15="")
{
   if (InStr(text, "silent"))
      silentMode := true

   errorMsg:="ERROR: "
   errorMsg.=CurrentTime("hyphenated")
   errorMsg.=A_Space
   errorMsg.=text
   loop 15
   {
      errorMsg.=A_Space
      errorMsg.=text%A_Index%
   }
   errorMsg.="`n`n"

   logPath=%A_WorkingDir%\logs
   FileCreateDir, %logPath%
   FileAppend, %errorMsg%, %logPath%\%A_ComputerName%.log

   if NOT silentMode
      MsgBox, , , %errorMsg%, 20
}

SelfDestruct()
{
   filename=SelfDestruct.ahk
   ;TODO TESTME filename=%A_ScriptFullPath%
   FileDelete, %filename%
   ;TODO the self destruct macro could have a loop and check if the file exists (pointless?)
   FileAppend, Sleep 100`nFileDelete`, %A_ScriptFullPath%, %filename%
   Run, %filename%
   Exit

   ;TODO try and TESTME
   ;FileDelete, %A_ScriptFullPath%
   ;Exit
}

RunAhkAndBabysit(filename)
{
   if NOT FileExist(filename)
      errord("silent", A_ThisFunc, filename, "file was not found")

   SetTitleMatchMode, RegEx

   Run, %filename%
   WinWait, %filename%, Error.*The program will exit., 10
   ;TODO if it fails on reload... "The previous version will remain in effect."
   if NOT ERRORLEVEL ;if it saw the window above
   {
      ForceWinFocus(filename)
      Send, {ENTER}
   }
}

GetProcesses()
{
   d = `n  ; string separator
   s := 4096  ; size of buffers and arrays (4 KB)

   Process, Exist  ; sets ErrorLevel to the PID of this running script
   ; Get the handle of this script with PROCESS_QUERY_INFORMATION (0x0400)
   h := DllCall("OpenProcess", "UInt", 0x0400, "Int", false, "UInt", ErrorLevel)
   ; Open an adjustable access token with this process (TOKEN_ADJUST_PRIVILEGES = 32)
   DllCall("Advapi32.dll\OpenProcessToken", "UInt", h, "UInt", 32, "UIntP", t)
   VarSetCapacity(ti, 16, 0)  ; structure of privileges
   NumPut(1, ti, 0)  ; one entry in the privileges array...
   ; Retrieves the locally unique identifier of the debug privilege:
   DllCall("Advapi32.dll\LookupPrivilegeValueA", "UInt", 0, "Str", "SeDebugPrivilege", "Int64P", luid)
   NumPut(luid, ti, 4, "int64")
   NumPut(2, ti, 12)  ; enable this privilege: SE_PRIVILEGE_ENABLED = 2
   ; Update the privileges of this process with the new access token:
   DllCall("Advapi32.dll\AdjustTokenPrivileges", "UInt", t, "Int", false, "UInt", &ti, "UInt", 0, "UInt", 0, "UInt", 0)
   DllCall("CloseHandle", "UInt", h)  ; close this process handle to save memory

   hModule := DllCall("LoadLibrary", "Str", "Psapi.dll")  ; increase performance by preloading the libaray
   s := VarSetCapacity(a, s)  ; an array that receives the list of process identifiers:
   c := 0  ; counter for process idendifiers
   DllCall("Psapi.dll\EnumProcesses", "UInt", &a, "UInt", s, "UIntP", r)
   Loop, % r // 4  ; parse array for identifiers as DWORDs (32 bits):
   {
      id := NumGet(a, A_Index * 4)
      ; Open process with: PROCESS_VM_READ (0x0010) | PROCESS_QUERY_INFORMATION (0x0400)
      h := DllCall("OpenProcess", "UInt", 0x0010 | 0x0400, "Int", false, "UInt", id)
      VarSetCapacity(n, s, 0)  ; a buffer that receives the base name of the module:
      e := DllCall("Psapi.dll\GetModuleBaseNameA", "UInt", h, "UInt", 0, "Str", n, "UInt", s)
      DllCall("CloseHandle", "UInt", h)  ; close process handle to save memory
      if (n && e)  ; if image is not null add to list:
         l .= n . d, c++
   }
   DllCall("FreeLibrary", "UInt", hModule)  ; unload the library to free memory
   Sort, l, C  ; uncomment this line to sort the list alphabetically
   ;MsgBox, 0, %c% Processes, %l%
   return l
}

;Returns whether or not two files are equal
;TODO make this work for big files, too (this version reads it all into memory first)
IsFileEqual(filename1, filename2)
{
   FileRead, file1, %filename1%
   FileRead, file2, %filename2%

   return file1==file2
}

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

WaitForImageSearch("ExpandDatabases.bmp")
ClickIfImageSearch("ExpandDatabases.bmp")

WaitForImageSearch("RightClickDb.bmp")
ClickIfImageSearch("RightClickDb.bmp", "Right")

WaitForImageSearch("HoverOverTasksMenu.bmp")
ClickIfImageSearch("HoverOverTasksMenu.bmp")

WaitForImageSearch("ClickCopyDatabase.bmp")
ClickIfImageSearch("ClickCopyDatabase.bmp")

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
SendInput, %destDbName%
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

seen:=WaitForImageSearch("WaitForSuccessMessage.bmp", 0, 1000)
if NOT seen
   fatalerror()

WinClose, Copy Database Wizard
WinClose, Microsoft SQL Server Management Studio ahk_class wndclass_desked_gsk

FatalError(description="Fatal Error")
{
   errord(description)
   ExitApp 1
}
