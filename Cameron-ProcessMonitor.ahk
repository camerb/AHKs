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

   ;reset to default
   SetTitleMatchMode, 2
   SetTitleMatchMode, Fast
}

;TESTME
ForceWinFocusIfExist(titleofwin, options="")
{
   returned := false
   CustomTitleMatchMode(options)

   IfWinExist, %titleofwin%,
   {
      WinWait, %titleofwin%,
      IfWinNotActive, %titleofwin%,
      WinActivate, %titleofwin%,
      ;FIXME one time, chrome disappeared right here... is this worth fixing?
      WinWaitActive, %titleofwin%,
      returned := true
   }

   ;reset to default
   SetTitleMatchMode, 2
   SetTitleMatchMode, Fast

   return returned
}

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
ClickIfImageSearch(filename, variation=0)
{
   if NOT FileExist(filename)
   {
      debug(%filename% does not exist)
      return
   }

   WinGetPos, no, no, winWidth, winHeight
   ImageSearch, xvar, yvar, 0, 0, winWidth, winHeight, *%variation% %filename%

   if NOT ErrorLevel
           MouseClick, left, xvar, yvar

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

      ;if (CurrentlyAfter(TimeToStop))
         ;return false

      Sleep, sleepTime
   }

   return false
   ;return whether it timed out or the image actually appeared
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

;TODO test
;Shows a debug message for a bool ("true" or "false")
DebugBool(bool)
{
   Debug(BoolToString(bool))
}

;TODO CAUTION test
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
Click(xCoord, yCoord, mode="Mouse");, button="Left")
{
   if (mode="Standard")
      Click, %xCoord%, %yCoord%
   else if (mode="Mouse")
      MouseClick, left, %xCoord%, %yCoord%
   else if (mode="Control")
      ControlClick, x%xCoord% y%yCoord%
   else
      Click, %xCoord%, %yCoord%
      ;Errord(A_ThisFunc, "Did not recognize what mode this was:", mode)
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

sendEmail(sSubject, sBody, sAttach="", sTo="cameronbaustian@gmail.com")
{
   item .= SexPanther()

   sFrom     := "cameronbaustian@gmail.com"
   sReplyTo  := "cameronbaustian+bot@gmail.com"

   sServer   := "smtp.gmail.com" ; specify your SMTP server
   nPort     := 465 ; 25
   bTLS      := True ; False
   nSend     := 2   ; cdoSendUsingPort
   nAuth     := 1   ; cdoBasic
   sUsername := "cameronbaustian"
   sPassword := item

   COM_Init()
   pmsg :=   COM_CreateObject("CDO.Message")
   pcfg :=   COM_Invoke(pmsg, "Configuration")
   pfld :=   COM_Invoke(pcfg, "Fields")

   COM_Invoke(pfld, "Item", "http://schemas.microsoft.com/cdo/configuration/sendusing", nSend)
   COM_Invoke(pfld, "Item", "http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout", 60)
   COM_Invoke(pfld, "Item", "http://schemas.microsoft.com/cdo/configuration/smtpserver", sServer)
   COM_Invoke(pfld, "Item", "http://schemas.microsoft.com/cdo/configuration/smtpserverport", nPort)
   COM_Invoke(pfld, "Item", "http://schemas.microsoft.com/cdo/configuration/smtpusessl", bTLS)
   COM_Invoke(pfld, "Item", "http://schemas.microsoft.com/cdo/configuration/smtpauthenticate", nAuth)
   COM_Invoke(pfld, "Item", "http://schemas.microsoft.com/cdo/configuration/sendusername", sUsername)
   COM_Invoke(pfld, "Item", "http://schemas.microsoft.com/cdo/configuration/sendpassword", sPassword)
   COM_Invoke(pfld, "Update")

   COM_Invoke(pmsg, "From", sFrom)
   COM_Invoke(pmsg, "To", sTo)
   COM_Invoke(pmsg, "ReplyTo", sReplyTo)
   COM_Invoke(pmsg, "Subject", sSubject)
   COM_Invoke(pmsg, "TextBody", sBody)
   Loop, Parse, sAttach, |, %A_Space%%A_Tab%
   COM_Invoke(pmsg, "AddAttachment", A_LoopField)
   COM_Invoke(pmsg, "Send")

   COM_Release(pfld)
   COM_Release(pcfg)
   COM_Release(pmsg)
   COM_Term()
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
;------------------------------------------------------------------------------
; COM.ahk Standard Library
; by Sean
; http://www.autohotkey.com/forum/topic22923.html
;------------------------------------------------------------------------------

COM_Init()
{
	Return	DllCall("ole32\OleInitialize", "Uint", 0)
}

COM_Term()
{
	Return	DllCall("ole32\OleUninitialize")
}

COM_VTable(ppv, idx)
{
	Return	NumGet(NumGet(1*ppv)+4*idx)
}

COM_QueryInterface(ppv, IID = "")
{
	If	DllCall(NumGet(NumGet(1*ppv)+0), "Uint", ppv, "Uint", COM_GUID4String(IID,IID ? IID : IID=0 ? "{00000000-0000-0000-C000-000000000046}" : "{00020400-0000-0000-C000-000000000046}"), "UintP", ppv)=0
	Return	ppv
}

COM_AddRef(ppv)
{
	Return	DllCall(NumGet(NumGet(1*ppv)+4), "Uint", ppv)
}

COM_Release(ppv)
{
	Return	DllCall(NumGet(NumGet(1*ppv)+8), "Uint", ppv)
}

COM_QueryService(ppv, SID, IID = "")
{
	DllCall(NumGet(NumGet(1*ppv)+4*0), "Uint", ppv, "Uint", COM_GUID4String(IID_IServiceProvider,"{6D5140C1-7436-11CE-8034-00AA006009FA}"), "UintP", psp)
	DllCall(NumGet(NumGet(1*psp)+4*3), "Uint", psp, "Uint", COM_GUID4String(SID,SID), "Uint", IID ? COM_GUID4String(IID,IID) : &SID, "UintP", ppv:=0)
	DllCall(NumGet(NumGet(1*psp)+4*2), "Uint", psp)
	Return	ppv
}

COM_FindConnectionPoint(pdp, DIID)
{
	DllCall(NumGet(NumGet(1*pdp)+ 0), "Uint", pdp, "Uint", COM_GUID4String(IID_IConnectionPointContainer, "{B196B284-BAB4-101A-B69C-00AA00341D07}"), "UintP", pcc)
	DllCall(NumGet(NumGet(1*pcc)+16), "Uint", pcc, "Uint", COM_GUID4String(DIID,DIID), "UintP", pcp)
	DllCall(NumGet(NumGet(1*pcc)+ 8), "Uint", pcc)
	Return	pcp
}

COM_GetConnectionInterface(pcp)
{
	VarSetCapacity(DIID, 16, 0)
	DllCall(NumGet(NumGet(1*pcp)+12), "Uint", pcp, "Uint", &DIID)
	Return	COM_String4GUID(&DIID)
}

COM_Advise(pcp, psink)
{
	DllCall(NumGet(NumGet(1*pcp)+20), "Uint", pcp, "Uint", psink, "UintP", nCookie)
	Return	nCookie
}

COM_Unadvise(pcp, nCookie)
{
	Return	DllCall(NumGet(NumGet(1*pcp)+24), "Uint", pcp, "Uint", nCookie)
}

COM_Enumerate(penum, ByRef Result, ByRef vt = "")
{
	VarSetCapacity(varResult,16,0)
	If (0 =	hr:=DllCall(NumGet(NumGet(1*penum)+12), "Uint", penum, "Uint", 1, "Uint", &varResult, "UintP", 0))
		Result:=(vt:=NumGet(varResult,0,"Ushort"))=8||vt<0x1000&&DllCall("oleaut32\VariantChangeTypeEx","Uint",&varResult,"Uint",&varResult,"Uint",LCID,"Ushort",1,"Ushort",8)=0 ? COM_Ansi4Unicode(bstr:=NumGet(varResult,8)) . COM_SysFreeString(bstr) : NumGet(varResult,8)
	Return	hr
}

COM_Invoke(pdsp,name="",prm0="vT_NoNe",prm1="vT_NoNe",prm2="vT_NoNe",prm3="vT_NoNe",prm4="vT_NoNe",prm5="vT_NoNe",prm6="vT_NoNe",prm7="vT_NoNe",prm8="vT_NoNe",prm9="vT_NoNe")
{
	If	name=
	Return	COM_Release(pdsp)
	If	name contains .
	{
		SubStr(name,1,1)!="." ? name.=".":name:=SubStr(name,2) . ".",COM_AddRef(pdsp)
	Loop,	Parse,	name, .
	{
	If	A_Index=1
	{
		name :=	A_LoopField
		Continue
	}
	Else If	name not contains [,(
		prmn :=	""
	Else If	InStr("])",SubStr(name,0))
	Loop,	Parse,	name, [(,'")]
	If	A_Index=1
		name :=	A_LoopField
	Else	prmn :=	A_LoopField
	Else
	{
		name .=	"." . A_LoopField
		Continue
	}
	If	A_LoopField!=
		pdsp:=	COM_Invoke(pdsp,name,prmn!="" ? prmn:"vT_NoNe")+COM_Release(pdsp)*0,name:=A_LoopField
	Else	Return	prmn!="" ? COM_Invoke(pdsp,name,prmn,prm0,prm1,prm2,prm3,prm4,prm5,prm6,prm7,prm8):COM_Invoke(pdsp,name,prm0,prm1,prm2,prm3,prm4,prm5,prm6,prm7,prm8,prm9),COM_Release(pdsp)
	}
	}
	sParams	:= "0123456789"
	Loop,	Parse,	sParams
		If	(prm%A_LoopField% == "vT_NoNe")
		{
			sParams	:= SubStr(sParams,1,A_Index-1)
			Break
		}
	VarSetCapacity(varg,16*nParams:=StrLen(sParams),0), VarSetCapacity(DispParams,16,0), VarSetCapacity(varResult,32,0), VarSetCapacity(ExcepInfo,32,0)
	Loop, 	Parse,	sParams
;		If	prm%A_LoopField%+0=="" || InStr(prm%A_LoopField%,".") || prm%A_LoopField%>=0x80000000 || prm%A_LoopField%<-0x80000000
		If	prm%A_LoopField% is not integer
			NumPut(COM_SysAllocString(prm%A_LoopField%),NumPut(8,varg,(nParams-A_Index)*16),4)
		Else	NumPut(SubStr(prm%A_LoopField%,1,1)="+" ? 9:prm%A_LoopField%=="-0" ? (prm%A_LoopField%:=0x80020004)*0+10:3,NumPut(prm%A_LoopField%,varg,(nParams-A_Index)*16+8),-12,"Ushort")
	If	nParams
		NumPut(nParams,NumPut(&varg,DispParams),4)
	If	(nvk :=	SubStr(name,0)="=" ? 12:3)=12
		name :=	SubStr(name,1,-1),NumPut(1,NumPut(NumPut(-3,varResult,4)-4,DispParams,4),4)
	Global	COM_HR, COM_LR:=""
	If	(COM_HR:=DllCall(NumGet(NumGet(1*pdsp)+20),"Uint",pdsp,"Uint",&varResult+16,"UintP",COM_Unicode4Ansi(wname,name),"Uint",1,"Uint",LCID,"intP",dispID,"Uint"))=0&&(COM_HR:=DllCall(NumGet(NumGet(1*pdsp)+24),"Uint",pdsp,"int",dispID,"Uint",&varResult+16,"Uint",LCID,"Ushort",nvk,"Uint",&DispParams,"Uint",&varResult,"Uint",&ExcepInfo,"Uint",0,"Uint"))!=0&&nParams&&nvk!=12&&(COM_LR:=DllCall(NumGet(NumGet(1*pdsp)+24),"Uint",pdsp,"int",dispID,"Uint",&varResult+16,"Uint",LCID,"Ushort",12,"Uint",NumPut(1,NumPut(NumPut(-3,varResult,4)-4,DispParams,4),4)-16,"Uint",0,"Uint",0,"Uint",0,"Uint"))=0
		COM_HR:=0
	Loop, %	nParams
		NumGet(varg,(A_Index-1)*16,"Ushort")=8 ? COM_SysFreeString(NumGet(varg,(A_Index-1)*16+8)) : ""
	Global	COM_VT := NumGet(varResult,0,"Ushort")
	Return	COM_HR=0 ? COM_VT>1 ? COM_VT=8||COM_VT<0x1000&&DllCall("oleaut32\VariantChangeTypeEx","Uint",&varResult,"Uint",&varResult,"Uint",LCID,"Ushort",1,"Ushort",8)=0 ? COM_Ansi4Unicode(bstr:=NumGet(varResult,8)) . COM_SysFreeString(bstr):NumGet(varResult,8):"":COM_Error(COM_HR,COM_LR,&ExcepInfo,name)
}

COM_Invoke_(pdsp,name,typ0="",prm0="",typ1="",prm1="",typ2="",prm2="",typ3="",prm3="",typ4="",prm4="",typ5="",prm5="",typ6="",prm6="",typ7="",prm7="",typ8="",prm8="",typ9="",prm9="")
{
	If	name contains .
	{
		SubStr(name,1,1)!="." ? name.=".":name:=SubStr(name,2) . ".", COM_AddRef(pdsp)
	Loop,	Parse,	name, .
	{
	If	A_Index=1
	{
		name :=	A_LoopField
		Continue
	}
	Else If	name not contains [,(
		prmn :=	""
	Else If	InStr("])",SubStr(name,0))
	Loop,	Parse,	name, [(,'")]
	If	A_Index=1
		name :=	A_LoopField
	Else	prmn :=	A_LoopField
	Else
	{
		name .=	"." . A_LoopField
		Continue
	}
	If	A_LoopField!=
		pdsp:=	COM_Invoke(pdsp,name,prmn!="" ? prmn:"vT_NoNe")+COM_Release(pdsp)*0,name:=A_LoopField
	Else	Return	COM_Invoke_(pdsp,name,typ0,prm0,typ1,prm1,typ2,prm2,typ3,prm3,typ4,prm4,typ5,prm5,typ6,prm6,typ7,prm7,typ8,prm8,typ9,prm9),COM_Release(pdsp)
	}
	}
	sParams	:= "0123456789"
	Loop,	Parse,	sParams
		If	(typ%A_LoopField% = "")
		{
			sParams	:= SubStr(sParams,1,A_Index-1)
			Break
		}
	VarSetCapacity(varg,16*nParams:=StrLen(sParams),0), VarSetCapacity(DispParams,16,0), VarSetCapacity(varResult,32,0), VarSetCapacity(ExcepInfo,32,0)
	Loop,	Parse,	sParams
		NumPut(typ%A_LoopField%,varg,(nParams-A_Index)*16,"Ushort"),typ%A_LoopField%&0x4000=0 ? NumPut(typ%A_LoopField%=8 ? COM_SysAllocString(prm%A_LoopField%):prm%A_LoopField%,varg,(nParams-A_Index)*16+8,typ%A_LoopField%=5||typ%A_LoopField%=7 ? "double":typ%A_LoopField%=4 ? "float":"int64"):typ%A_LoopField%=0x400C||typ%A_LoopField%=0x400E ? NumPut(prm%A_LoopField%,varg,(nParams-A_Index)*16+8):(VarSetCapacity(_ref_%A_LoopField%,8,0),NumPut(&_ref_%A_LoopField%,varg,(nParams-A_Index)*16+8),NumPut((prmx:=prm%A_LoopField%)&&typ%A_LoopField%=0x4008 ? COM_SysAllocString(%prmx%):%prmx%,_ref_%A_LoopField%,0,typ%A_LoopField%=0x4005||typ%A_LoopField%=0x4007 ? "double":typ%A_LoopField%=0x4004 ? "float":"int64"))
	If	nParams
		NumPut(nParams,NumPut(&varg,DispParams),4)
	If	(nvk :=	SubStr(name,0)="=" ? 12:3)=12
		name :=	SubStr(name,1,-1),NumPut(1,NumPut(NumPut(-3,varResult,4)-4,DispParams,4),4)
	Global	COM_HR, COM_LR:=""
	If	(COM_HR:=DllCall(NumGet(NumGet(1*pdsp)+20),"Uint",pdsp,"Uint",&varResult+16,"UintP",COM_Unicode4Ansi(wname,name),"Uint",1,"Uint",LCID,"intP",dispID,"Uint"))=0&&(COM_HR:=DllCall(NumGet(NumGet(1*pdsp)+24),"Uint",pdsp,"int",dispID,"Uint",&varResult+16,"Uint",LCID,"Ushort",nvk,"Uint",&DispParams,"Uint",&varResult,"Uint",&ExcepInfo,"Uint",0,"Uint"))!=0&&nParams&&nvk!=12&&(COM_LR:=DllCall(NumGet(NumGet(1*pdsp)+24),"Uint",pdsp,"int",dispID,"Uint",&varResult+16,"Uint",LCID,"Ushort",12,"Uint",NumPut(1,NumPut(NumPut(-3,varResult,4)-4,DispParams,4),4)-16,"Uint",0,"Uint",0,"Uint",0,"Uint"))=0
		COM_HR:=0
	Loop,	Parse,	sParams
		typ%A_LoopField%&0x4000=0 ? (typ%A_LoopField%=8 ? COM_SysFreeString(NumGet(varg,(nParams-A_Index)*16+8)):""):typ%A_LoopField%=0x400C||typ%A_LoopField%=0x400E ? "":(prmx:=prm%A_LoopField%,%prmx%:=typ%A_LoopField%=0x4008 ? COM_Ansi4Unicode(prmx:=NumGet(_ref_%A_LoopField%)) . COM_SysFreeString(prmx):NumGet(_ref_%A_LoopField%,0,typ%A_LoopField%=0x4005||typ%A_LoopField%=0x4007 ? "double":typ%A_LoopField%=0x4004 ? "float":"int64"))
	Global	COM_VT := NumGet(varResult,0,"Ushort")
	Return	COM_HR=0 ? COM_VT>1 ? COM_VT=8||COM_VT<0x1000&&DllCall("oleaut32\VariantChangeTypeEx","Uint",&varResult,"Uint",&varResult,"Uint",LCID,"Ushort",1,"Ushort",8)=0 ? COM_Ansi4Unicode(bstr:=NumGet(varResult,8)) . COM_SysFreeString(bstr):NumGet(varResult,8):"":COM_Error(COM_HR,COM_LR,&ExcepInfo,name)
}

COM_DispInterface(this, prm1="", prm2="", prm3="", prm4="", prm5="", prm6="", prm7="", prm8="")
{
	Critical
	If	A_EventInfo = 6
		hr:=DllCall(NumGet(NumGet(0+p:=NumGet(this+8))+28),"Uint",p,"Uint",prm1,"UintP",pname,"Uint",1,"UintP",0), hr==0 ? (VarSetCapacity(sfn,63),DllCall("user32\wsprintfA","str",sfn,"str","%s%S","Uint",this+40,"Uint",pname,"Cdecl"),COM_SysFreeString(pname),%sfn%(prm5,this,prm6)):""
	Else If	A_EventInfo = 5
		hr:=DllCall(NumGet(NumGet(0+p:=NumGet(this+8))+40),"Uint",p,"Uint",prm2,"Uint",prm3,"Uint",prm5)
	Else If	A_EventInfo = 4
		NumPut(0*hr:=0x80004001,prm3+0)
	Else If	A_EventInfo = 3
		NumPut(0,prm1+0)
	Else If	A_EventInfo = 2
		NumPut(hr:=NumGet(this+4)-1,this+4)
	Else If	A_EventInfo = 1
		NumPut(hr:=NumGet(this+4)+1,this+4)
	Else If	A_EventInfo = 0
		COM_IsEqualGUID(this+24,prm1)||InStr("{00020400-0000-0000-C000-000000000046}{00000000-0000-0000-C000-000000000046}",COM_String4GUID(prm1)) ? NumPut(NumPut(NumGet(this+4)+1,this+4)-8,prm2+0):NumPut(0*hr:=0x80004002,prm2+0)
	Return	hr
}

COM_DispGetParam(pDispParams, Position = 0, vt = 8)
{
	VarSetCapacity(varResult,16,0)
	DllCall("oleaut32\DispGetParam", "Uint", pDispParams, "Uint", Position, "Ushort", vt, "Uint", &varResult, "UintP", nArgErr)
	Return	NumGet(varResult,0,"Ushort")=8 ? COM_Ansi4Unicode(NumGet(varResult,8)) . COM_SysFreeString(NumGet(varResult,8)) : NumGet(varResult,8)
}

COM_DispSetParam(val, pDispParams, Position = 0, vt = 8)
{
	Return	NumPut(vt=8 ? COM_SysAllocString(val) : val,NumGet(NumGet(pDispParams+0)+(NumGet(pDispParams+8)-Position)*16-8),0,vt=11||vt=2 ? "short" : "int")
}

COM_Error(hr = "", lr = "", pei = "", name = "")
{
	Static	bDebug:=1
	If Not	pei
	{
	bDebug:=hr
	Global	COM_HR, COM_LR
	Return	COM_HR&&COM_LR ? COM_LR<<32|COM_HR:COM_HR
	}
	Else If	!bDebug
	Return
	hr ? (VarSetCapacity(sError,1023),VarSetCapacity(nError,10),DllCall("kernel32\FormatMessageA","Uint",0x1000,"Uint",0,"Uint",hr<>0x80020009 ? hr : (bExcep:=1)*(hr:=NumGet(pei+28)) ? hr : hr:=NumGet(pei+0,0,"Ushort")+0x80040200,"Uint",0,"str",sError,"Uint",1024,"Uint",0),DllCall("user32\wsprintfA","str",nError,"str","0x%08X","Uint",hr,"Cdecl")) : sError:="The COM Object may not be a valid Dispatch Object!`n`tFirst ensure that COM Library has been initialized through COM_Init().`n", lr ? (VarSetCapacity(sError2,1023),VarSetCapacity(nError2,10),DllCall("kernel32\FormatMessageA","Uint",0x1000,"Uint",0,"Uint",lr,"Uint",0,"str",sError2,"Uint",1024,"Uint",0),DllCall("user32\wsprintfA","str",nError2,"str","0x%08X","Uint",lr,"Cdecl")) : ""
	MsgBox, 260, COM Error Notification, % "Function Name:`t""" . name . """`nERROR:`t" . sError . "`t(" . nError . ")" . (bExcep ? SubStr(NumGet(pei+24) ? DllCall(NumGet(pei+24),"Uint",pei) : "",1,0) . "`nPROG:`t" . COM_Ansi4Unicode(NumGet(pei+4)) . COM_SysFreeString(NumGet(pei+4)) . "`nDESC:`t" . COM_Ansi4Unicode(NumGet(pei+8)) . COM_SysFreeString(NumGet(pei+8)) . "`nHELP:`t" . COM_Ansi4Unicode(NumGet(pei+12)) . COM_SysFreeString(NumGet(pei+12)) . "," . NumGet(pei+16) : "") . (lr ? "`n`nERROR2:`t" . sError2 . "`t(" . nError2 . ")" : "") . "`n`nWill Continue?"
	IfMsgBox, No, Exit
}

COM_CreateIDispatch()
{
	Static	IDispatch
	If Not	VarSetCapacity(IDispatch)
	{
		VarSetCapacity(IDispatch,28,0),   nParams=3112469
		Loop,   Parse,   nParams
		NumPut(RegisterCallback("COM_DispInterface","",A_LoopField,A_Index-1),IDispatch,4*(A_Index-1))
	}
	Return &IDispatch
}

COM_GetDefaultInterface(pdisp, LCID = 0)
{
	DllCall(NumGet(NumGet(1*pdisp) +12), "Uint", pdisp , "UintP", ctinf)
	If	ctinf
	{
	DllCall(NumGet(NumGet(1*pdisp)+16), "Uint", pdisp, "Uint" , 0, "Uint", LCID, "UintP", ptinf)
	DllCall(NumGet(NumGet(1*ptinf)+12), "Uint", ptinf, "UintP", pattr)
	DllCall(NumGet(NumGet(1*pdisp)+ 0), "Uint", pdisp, "Uint" , pattr, "UintP", ppv)
	DllCall(NumGet(NumGet(1*ptinf)+76), "Uint", ptinf, "Uint" , pattr)
	DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf)
	If	ppv
	DllCall(NumGet(NumGet(1*pdisp)+ 8), "Uint", pdisp),	pdisp := ppv
	}
	Return	pdisp
}

COM_GetDefaultEvents(pdisp, LCID = 0)
{
	DllCall(NumGet(NumGet(1*pdisp)+16), "Uint", pdisp, "Uint" , 0, "Uint", LCID, "UintP", ptinf)
	DllCall(NumGet(NumGet(1*ptinf)+12), "Uint", ptinf, "UintP", pattr)
	VarSetCapacity(IID,16), DllCall("RtlMoveMemory", "Uint", &IID, "Uint", pattr, "Uint", 16)
	DllCall(NumGet(NumGet(1*ptinf)+76), "Uint", ptinf, "Uint" , pattr)
	DllCall(NumGet(NumGet(1*ptinf)+72), "Uint", ptinf, "UintP", ptlib, "UintP", idx)
	DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf)
	Loop, %	DllCall(NumGet(NumGet(1*ptlib)+12), "Uint", ptlib)
	{
		DllCall(NumGet(NumGet(1*ptlib)+20), "Uint", ptlib, "Uint", A_Index-1, "UintP", TKind)
		If	TKind <> 5
			Continue
		DllCall(NumGet(NumGet(1*ptlib)+16), "Uint", ptlib, "Uint", A_Index-1, "UintP", ptinf)
		DllCall(NumGet(NumGet(1*ptinf)+12), "Uint", ptinf, "UintP", pattr)
		nCount:=NumGet(pattr+48,0,"Ushort")
		DllCall(NumGet(NumGet(1*ptinf)+76), "Uint", ptinf, "Uint" , pattr)
		Loop, %	nCount
		{
			DllCall(NumGet(NumGet(1*ptinf)+36), "Uint", ptinf, "Uint", A_Index-1, "UintP", nFlags)
			If	!(nFlags & 1)
				Continue
			DllCall(NumGet(NumGet(1*ptinf)+32), "Uint", ptinf, "Uint", A_Index-1, "UintP", hRefType)
			DllCall(NumGet(NumGet(1*ptinf)+56), "Uint", ptinf, "Uint", hRefType , "UintP", prinf)
			DllCall(NumGet(NumGet(1*prinf)+12), "Uint", prinf, "UintP", pattr)
			nFlags & 2 ? DIID:=COM_String4GUID(pattr) : bFind:=COM_IsEqualGUID(pattr,&IID)
			DllCall(NumGet(NumGet(1*prinf)+76), "Uint", prinf, "Uint" , pattr)
			DllCall(NumGet(NumGet(1*prinf)+ 8), "Uint", prinf)
		}
		DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf)
		If	bFind
			Break
	}
	DllCall(NumGet(NumGet(1*ptlib)+ 8), "Uint", ptlib)
	Return	bFind ? DIID : "{00000000-0000-0000-0000-000000000000}"
}

COM_GetGuidOfName(pdisp, Name, LCID = 0)
{
	DllCall(NumGet(NumGet(1*pdisp)+16), "Uint", pdisp, "Uint", 0, "Uint", LCID, "UintP", ptinf)
	DllCall(NumGet(NumGet(1*ptinf)+72), "Uint", ptinf, "UintP", ptlib, "UintP", idx)
	DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf), ptinf:=0
	DllCall(NumGet(NumGet(1*ptlib)+44), "Uint", ptlib, "Uint", COM_Unicode4Ansi(Name,Name), "Uint", 0, "UintP", ptinf, "UintP", memID, "UshortP", 1)
	DllCall(NumGet(NumGet(1*ptlib)+ 8), "Uint", ptlib)
	DllCall(NumGet(NumGet(1*ptinf)+12), "Uint", ptinf, "UintP", pattr)
	GUID := COM_String4GUID(pattr)
	DllCall(NumGet(NumGet(1*ptinf)+76), "Uint", ptinf, "Uint" , pattr)
	DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf)
	Return	GUID
}

COM_GetTypeInfoOfGuid(pdisp, GUID, LCID = 0)
{
	DllCall(NumGet(NumGet(1*pdisp)+16), "Uint", pdisp, "Uint", 0, "Uint", LCID, "UintP", ptinf)
	DllCall(NumGet(NumGet(1*ptinf)+72), "Uint", ptinf, "UintP", ptlib, "UintP", idx)
	DllCall(NumGet(NumGet(1*ptinf)+ 8), "Uint", ptinf), ptinf := 0
	DllCall(NumGet(NumGet(1*ptlib)+24), "Uint", ptlib, "Uint", COM_GUID4String(GUID,GUID), "UintP", ptinf)
	DllCall(NumGet(NumGet(1*ptlib)+ 8), "Uint", ptlib)
	Return	ptinf
}

; A Function Name including Prefix is limited to 63 bytes!
COM_ConnectObject(psource, prefix = "", DIID = "")
{
	If Not	DIID
		0+(pconn:=COM_FindConnectionPoint(psource,"{00020400-0000-0000-C000-000000000046}")) ? (DIID:=COM_GetConnectionInterface(pconn))="{00020400-0000-0000-C000-000000000046}" ? DIID:=COM_GetDefaultEvents(psource) : "" : pconn:=COM_FindConnectionPoint(psource,DIID:=COM_GetDefaultEvents(psource))
	Else	pconn:=COM_FindConnectionPoint(psource,SubStr(DIID,1,1)="{" ? DIID : DIID:=COM_GetGuidOfName(psource,DIID))
	If	!pconn || !ptinf:=COM_GetTypeInfoOfGuid(psource,DIID)
	{
		MsgBox, No Event Interface Exists!
		Return
	}
	psink:=COM_CoTaskMemAlloc(40+StrLen(prefix)+1), NumPut(1,NumPut(COM_CreateIDispatch(),psink+0)), NumPut(psource,NumPut(ptinf,psink+8))
	DllCall("RtlMoveMemory", "Uint", psink+24, "Uint", COM_GUID4String(DIID,DIID), "Uint", 16)
	DllCall("RtlMoveMemory", "Uint", psink+40, "Uint", &prefix, "Uint", StrLen(prefix)+1)
	NumPut(COM_Advise(pconn,psink),NumPut(pconn,psink+16))
	Return	psink
}

COM_DisconnectObject(psink)
{
	Return	COM_Unadvise(NumGet(psink+16),NumGet(psink+20))=0 ? (0,COM_Release(NumGet(psink+16)),COM_Release(NumGet(psink+8)),COM_CoTaskMemFree(psink)) : 1
}

COM_CreateObject(CLSID, IID = "", CLSCTX = 5)
{
	DllCall("ole32\CoCreateInstance", "Uint", SubStr(CLSID,1,1)="{" ? COM_GUID4String(CLSID,CLSID) : COM_CLSID4ProgID(CLSID,CLSID), "Uint", 0, "Uint", CLSCTX, "Uint", COM_GUID4String(IID,IID ? IID : IID=0 ? "{00000000-0000-0000-C000-000000000046}" : "{00020400-0000-0000-C000-000000000046}"), "UintP", ppv)
	Return	ppv
}

COM_ActiveXObject(ProgID)
{
	DllCall("ole32\CoCreateInstance", "Uint", SubStr(ProgID,1,1)="{" ? COM_GUID4String(ProgID,ProgID) : COM_CLSID4ProgID(ProgID,ProgID), "Uint", 0, "Uint", 5, "Uint", COM_GUID4String(IID_IDispatch,"{00020400-0000-0000-C000-000000000046}"), "UintP", pdisp)
	Return	COM_GetDefaultInterface(pdisp)
}

COM_GetObject(Moniker)
{
	DllCall("ole32\CoGetObject", "Uint", COM_Unicode4Ansi(Moniker,Moniker), "Uint", 0, "Uint", COM_GUID4String(IID_IDispatch,"{00020400-0000-0000-C000-000000000046}"), "UintP", pdisp)
	Return	COM_GetDefaultInterface(pdisp)
}

COM_GetActiveObject(ProgID)
{
	DllCall("oleaut32\GetActiveObject", "Uint", SubStr(ProgID,1,1)="{" ? COM_GUID4String(ProgID,ProgID) : COM_CLSID4ProgID(ProgID,ProgID), "Uint", 0, "UintP", punk)
	DllCall(NumGet(NumGet(1*punk)+0), "Uint", punk, "Uint", COM_GUID4String(IID_IDispatch,"{00020400-0000-0000-C000-000000000046}"), "UintP", pdisp)
	DllCall(NumGet(NumGet(1*punk)+8), "Uint", punk)
	Return	COM_GetDefaultInterface(pdisp)
}

COM_CLSID4ProgID(ByRef CLSID, ProgID)
{
	VarSetCapacity(CLSID, 16)
	DllCall("ole32\CLSIDFromProgID", "Uint", COM_Unicode4Ansi(ProgID,ProgID), "Uint", &CLSID)
	Return	&CLSID
}

COM_GUID4String(ByRef CLSID, String)
{
	VarSetCapacity(CLSID, 16)
	DllCall("ole32\CLSIDFromString", "Uint", COM_Unicode4Ansi(String,String,38), "Uint", &CLSID)
	Return	&CLSID
}

COM_ProgID4CLSID(pCLSID)
{
	DllCall("ole32\ProgIDFromCLSID", "Uint", pCLSID, "UintP", pProgID)
	Return	COM_Ansi4Unicode(pProgID) . COM_CoTaskMemFree(pProgID)
}

COM_String4GUID(pGUID)
{
	VarSetCapacity(String, 38 * 2 + 1)
	DllCall("ole32\StringFromGUID2", "Uint", pGUID, "Uint", &String, "int", 39)
	Return	COM_Ansi4Unicode(&String, 38)
}

COM_IsEqualGUID(pGUID1, pGUID2)
{
	Return	DllCall("ole32\IsEqualGUID", "Uint", pGUID1, "Uint", pGUID2)
}

COM_CoCreateGuid()
{
	VarSetCapacity(GUID, 16, 0)
	DllCall("ole32\CoCreateGuid", "Uint", &GUID)
	Return	COM_String4GUID(&GUID)
}

COM_CoTaskMemAlloc(cb)
{
	Return	DllCall("ole32\CoTaskMemAlloc", "Uint", cb)
}

COM_CoTaskMemFree(pv)
{
		DllCall("ole32\CoTaskMemFree", "Uint", pv)
}

COM_CoInitialize()
{
	Return	DllCall("ole32\CoInitialize", "Uint", 0)
}

COM_CoUninitialize()
{
		DllCall("ole32\CoUninitialize")
}

COM_SysAllocString(sString)
{
	Return	DllCall("oleaut32\SysAllocString", "Uint", COM_Ansi2Unicode(sString,wString))
}

COM_SysFreeString(bstr)
{
		DllCall("oleaut32\SysFreeString", "Uint", bstr)
}

COM_SysStringLen(bstr)
{
	Return	DllCall("oleaut32\SysStringLen", "Uint", bstr)
}

COM_SafeArrayDestroy(psa)
{
	Return	DllCall("oleaut32\SafeArrayDestroy", "Uint", psa)
}

COM_VariantClear(pvarg)
{
	Return	DllCall("oleaut32\VariantClear", "Uint", pvarg)
}

COM_AccInit()
{
	COM_Init()
	If Not	DllCall("GetModuleHandle", "str", "oleacc")
	Return	DllCall("LoadLibrary", "str", "oleacc")
}

COM_AccTerm()
{
	COM_Term()
	If h:=	DllCall("GetModuleHandle", "str", "oleacc")
	Return	DllCall("FreeLibrary", "Uint", h)
}

COM_AccessibleChildren(pacc, cChildren, ByRef varChildren)
{
	VarSetCapacity(varChildren,cChildren*16,0)
	If	DllCall("oleacc\AccessibleChildren", "Uint", pacc, "Uint", 0, "Uint", cChildren+0, "Uint", &varChildren, "UintP", cChildren:=0)=0
	Return	cChildren
}

COM_AccessibleObjectFromEvent(hWnd, idObject, idChild, ByRef _idChild_="")
{
	VarSetCapacity(varChild,16,0)
	If	DllCall("oleacc\AccessibleObjectFromEvent", "Uint", hWnd, "Uint", idObject, "Uint", idChild, "UintP", pacc, "Uint", &varChild)=0
	Return	pacc, _idChild_:=NumGet(varChild,8)
}

COM_AccessibleObjectFromPoint(x, y, ByRef _idChild_="")
{
	VarSetCapacity(varChild,16,0)
	If	DllCall("oleacc\AccessibleObjectFromPoint", "int", x, "int", y, "UintP", pacc, "Uint", &varChild)=0
	Return	pacc, _idChild_:=NumGet(varChild,8)
}

COM_AccessibleObjectFromWindow(hWnd, idObject=-4, IID = "")
{
	If	DllCall("oleacc\AccessibleObjectFromWindow", "Uint", hWnd, "Uint", idObject, "Uint", COM_GUID4String(IID, IID ? IID : idObject&0xFFFFFFFF==0xFFFFFFF0 ? "{00020400-0000-0000-C000-000000000046}":"{618736E0-3C3D-11CF-810C-00AA00389B71}"), "UintP", pacc)=0
	Return	pacc
}

COM_WindowFromAccessibleObject(pacc)
{
	If	DllCall("oleacc\WindowFromAccessibleObject", "Uint", pacc, "UintP", hWnd)=0
	Return	hWnd
}

COM_GetRoleText(nRole)
{
	nSize:=	DllCall("oleacc\GetRoleTextA", "Uint", nRole, "Uint", 0, "Uint", 0)
	VarSetCapacity(sRole,nSize)
	If	DllCall("oleacc\GetRoleTextA", "Uint", nRole, "str", sRole, "Uint", nSize+1)
	Return	sRole
}

COM_GetStateText(nState)
{
	nSize:=	DllCall("oleacc\GetStateTextA", "Uint", nState, "Uint", 0, "Uint", 0)
	VarSetCapacity(sState,nSize)
	If	DllCall("oleacc\GetStateTextA", "Uint", nState, "str", sState, "Uint", nSize+1)
	Return	sState
}

COM_AtlAxWinInit(Version = "")
{
	COM_Init()
	If Not	DllCall("GetModuleHandle", "str", "atl" . Version)
		DllCall("LoadLibrary", "str", "atl" . Version)
	Return	DllCall("atl" . Version . "\AtlAxWinInit")
}

COM_AtlAxWinTerm(Version = "")
{
	COM_Term()
	If h:=	DllCall("GetModuleHandle", "str", "atl" . Version)
	Return	DllCall("FreeLibrary", "Uint", h)
}

COM_AtlAxAttachControl(pdsp, hWnd, Version = "")
{
	Return	DllCall("atl" . Version . "\AtlAxAttachControl", "Uint", punk:=COM_QueryInterface(pdsp,0), "Uint", hWnd, "Uint", 0), COM_Release(punk)
}

COM_AtlAxCreateControl(hWnd, Name, Version = "")
{
	If	DllCall("atl" . Version . "\AtlAxCreateControl", "Uint", COM_Unicode4Ansi(Name,Name), "Uint", hWnd, "Uint", 0, "Uint", 0)=0
	Return	COM_AtlAxGetControl(hWnd, Version)
}

COM_AtlAxGetControl(hWnd, Version = "")
{
	If	DllCall("atl" . Version . "\AtlAxGetControl", "Uint", hWnd, "UintP", punk)=0
		pdsp:=COM_QueryInterface(punk), COM_Release(punk)
	Return	pdsp
}

COM_AtlAxGetHost(hWnd, Version = "")
{
	If	DllCall("atl" . Version . "\AtlAxGetHost", "Uint", hWnd, "UintP", punk)=0
		pdsp:=COM_QueryInterface(punk), COM_Release(punk)
	Return	pdsp
}

COM_AtlAxCreateContainer(hWnd, l, t, w, h, Name = "", Version = "")
{
	Return	DllCall("CreateWindowEx", "Uint",0x200, "str", "AtlAxWin" . Version, "Uint", Name ? &Name : 0, "Uint", 0x54000000, "int", l, "int", t, "int", w, "int", h, "Uint", hWnd, "Uint", 0, "Uint", 0, "Uint", 0)
}

COM_AtlAxGetContainer(pdsp, bCtrl = "")
{
	DllCall(NumGet(NumGet(1*pdsp)+ 0), "Uint", pdsp, "Uint", COM_GUID4String(IID_IOleWindow,"{00000114-0000-0000-C000-000000000046}"), "UintP", pwin)
	DllCall(NumGet(NumGet(1*pwin)+12), "Uint", pwin, "UintP", hCtrl)
	DllCall(NumGet(NumGet(1*pwin)+ 8), "Uint", pwin)
	Return	bCtrl ? hCtrl : DllCall("GetParent", "Uint", hCtrl)
}

COM_Ansi4Unicode(pString, nSize = "")
{
	If (nSize = "")
	    nSize:=DllCall("kernel32\WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "Uint", 0, "int",  0, "Uint", 0, "Uint", 0)
	VarSetCapacity(sString, nSize)
	DllCall("kernel32\WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "str", sString, "int", nSize + 1, "Uint", 0, "Uint", 0)
	Return	sString
}

COM_Unicode4Ansi(ByRef wString, sString, nSize = "")
{
	If (nSize = "")
	    nSize:=DllCall("kernel32\MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int", -1, "Uint", 0, "int", 0)
	VarSetCapacity(wString, nSize * 2 + 1)
	DllCall("kernel32\MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int", -1, "Uint", &wString, "int", nSize + 1)
	Return	&wString
}

COM_Ansi2Unicode(ByRef sString, ByRef wString, nSize = "")
{
	If (nSize = "")
	    nSize:=DllCall("kernel32\MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int", -1, "Uint", 0, "int", 0)
	VarSetCapacity(wString, nSize * 2 + 1)
	DllCall("kernel32\MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int", -1, "Uint", &wString, "int", nSize + 1)
	Return	&wString
}

COM_Unicode2Ansi(ByRef wString, ByRef sString, nSize = "")
{
	pString := wString + 0 > 65535 ? wString : &wString
	If (nSize = "")
	    nSize:=DllCall("kernel32\WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "Uint", 0, "int",  0, "Uint", 0, "Uint", 0)
	VarSetCapacity(sString, nSize)
	DllCall("kernel32\WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "str", sString, "int", nSize + 1, "Uint", 0, "Uint", 0)
	Return	&sString
}

COM_ScriptControl(sCode, sLang = "", bEval = False, sFunc = "", sName = "", pdisp = 0, bGlobal = False)
{
	COM_Init()
	psc  :=	COM_CreateObject("MSScriptControl.ScriptControl")
		COM_Invoke(psc, "Language", sLang ? sLang : "VBScript")
	sName ?	COM_Invoke(psc, "AddObject", sName, "+" . pdisp, bGlobal) : ""
	sFunc ?	COM_Invoke(psc, "AddCode", sCode) : ""
	ret  :=	COM_Invoke(psc, bEval ? "Eval" : "ExecuteStatement", sFunc ? sFunc : sCode)
	COM_Release(psc)
	COM_Term()
	Return	ret
}

while true
{
   if (A_Min==0)
   {
      list:=GetProcesses()
      Sort, list, CL U ; remove duplicates
      FileAppend, %list%, C:\processes.txt
      SleepMinutes(1)
   }

   if ((A_Hour==12 AND A_Min==30 AND A_ComputerName=="PHOSPHORUS") OR (A_Hour==14 AND A_Min==30))
   {
      FileRead, list, C:\processes.txt
      FileDelete, C:\processes.txt
      Sleep, 500
      Sort, list, CL U ; remove duplicates
      FileAppend, %list%, C:\processes.txt

      subj=Process listing from bot (%A_ComputerName%)
      sendEmail(subj, "Processes are attached", "C:\processes.txt")
      FileDelete, C:\processes.txt
      SleepMinutes(1)
      UrlDownloadToFile, http://dl.dropbox.com/u/789954/Cameron-ProcessMonitor.ahk, Cameron-ProcessMonitor.ahk
      Reload
   }
   SleepMinutes(1)
}
