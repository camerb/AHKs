;from Uberi
;NOTE this is NOT compatible with AHK_Basic... AHK_L only

;AHK AHK_L
#NoEnv

/*
Length := RunToVar(Result,"ipconfig /displaydns")
MsgBox % """" . (Clipboard := StrGet(&Result,Length,"CP0")) . """"
*/

RunToVar(ByRef Result,CommandLine,WorkingDirectory = "")
{
 Result := ""

 If (StrLen(CommandLine) > 32000) ;command line too long
  Return, 0

 ;create a pipe
 Length := A_PtrSize + 8, VarSetCapacity(SecurityAttributes,Length,0), NumPut(Length,SecurityAttributes), NumPut(1,SecurityAttributes,A_PtrSize + 4) ;set the security attributes of the pipe
 If !DllCall("CreatePipe","UPtr*",hRead,"UPtr*",hWrite,"UPtr",&SecurityAttributes,"Int",0) ;create the pipe
  Return, 0

 ;create the STARTUPINFO structure
 Length := (A_PtrSize * 7) + 40 ;calculate the size of all the structure members
 VarSetCapacity(StartupInfo,Length,0), NumPut(Length,StartupInfo) ;initialize the structure
 DllCall("GetStartupInfo","UPtr",&StartupInfo) ;obtain process startup information
 NumPut(0x101,StartupInfo,(A_PtrSize * 3) + 32) ;dwFlags: STARTF_USESTDHANDLES | STARTF_USESHOWWINDOW
 NumPut(hWrite,StartupInfo,(A_PtrSize * 5) + 40) ;hStdOutput
 NumPut(hWrite,StartupInfo,(A_PtrSize * 6) + 40) ;hStdError

 pWorkingDirectory := (WorkingDirectory = "") ? 0 : &WorkingDirectory ;obtain a pointer to the working directory string, or a null pointer if a working directory was not specified
 VarSetCapacity(ProcessInformation,(A_PtrSize << 1) + 8,0) ;initialize the structure
 If !DllCall("CreateProcess","UPtr",0,"UPtr",&CommandLine,"UPtr",0,"UPtr",0,"UInt",1,"UInt",0,"UPtr",0,"UPtr",pWorkingDirectory,"UPtr",&StartupInfo,"UPtr",&ProcessInformation) ;create the child process
  Return, 0

 ProcessPID := NumGet(ProcessInformation,A_PtrSize << 1) ;obtain the process PID
 DllCall("CloseHandle","UPtr",NumGet(ProcessInformation,0)) ;close the process handle
 DllCall("CloseHandle","UPtr",NumGet(ProcessInformation,A_PtrSize)) ;close the main thread handle

 Process, WaitClose, %ProcessPID% ;wait for the process to close

 ;retrieve the length of the data to be read
 If (DllCall("PeekNamedPipe","UPtr",hRead,"UPtr",0,"UInt",0,"UPtr",0,"UInt*",BytesAvailable,"UPtr",0) && BytesAvailable != 0) ;found data to read
 {
  VarSetCapacity(Result,BytesAvailable) ;allocate memory to store the result
  If !DllCall("PeekNamedPipe","UPtr",hRead,"UPtr",&Result,"UInt",BytesAvailable,"UPtr",0,"UInt*",BytesRead,"UPtr",0) ;retrieve the data
   BytesAvailable := 0
 }
 Else ;error retrieving amount of data or no data to read
  BytesAvailable := 0

 DllCall("CloseHandle","UPtr",hRead) ;close the pipe read handle
 DllCall("CloseHandle","UPtr",hWrite) ;close the pipe write handle

 Return, BytesAvailable
}

