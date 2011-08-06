;?add Modified by Tuncay, 2010
;?add Prefix ping_ added to all functions besides the main two functions.
;?add User function A_ping() renamed to ping() and internal Ping() renamed to ping_().
; Originally Ping function by Drugwash May 28, 2009
; v1.1
;*********************************
ping_(adr, data, timeout) ;?mod main routine for internal use, formerly known as ping()  
{
static reply
ErrorLevel = 0
SetFormat, IntegerFast, H
cAdr := DllCall("wsock32\inet_addr", UInt, &adr, UInt)   ; convert address to 32bit UInt
if cAdr = 0xFFFFFFFF
   cAdr := DllCall("ws2_32\inet_addr", str, adr, Int) ; second attempt at conversion, using ws2_32
      if cAdr = 0xFFFFFFFF
         {
         ErrorLevel = 1
         return err := "Error: Cannot convert address to UInt."
         }
; test for function presence since it's located in different libs through various OS
hLib := DllCall("LoadLibrary", str, "iphlpapi.dll")
if hLib
   {
   hPrAdr := DllCall("GetProcAddress", UInt, hLib, str, "IcmpCreateFile")
   if hPrAdr
;      hPort := DllCall("iphlpapi\IcmpCreateFile", UInt)   ; open a port (iphlpapi.dll in XP+)
      hPort := DllCall(hPrAdr, UInt)   ; open a port (iphlpapi.dll in XP+)
   else
      DllCall("FreeLibrary", UInt, hLib)
   }
if !hPort
   hPort := DllCall("icmp\IcmpCreateFile", UInt)   ; open a port (icmp.dll in Win2000 and lower)
if !hPort
   {
   ErrorLevel = 1
   return err := "Error: Cannot open port."
   }
SetFormat, Integer, D
szreply = 278                ; ICMP_ECHO_REPLY structure
VarSetCapacity(reply, szreply, 0)
DllCall("icmp\IcmpSendEcho", UInt, hPort, UInt, cAdr, UInt, &data, UInt, StrLen(data), UInt, NULL, UInt, &reply, UInt, szreply, UInt, timeout, UInt)
errcode := NumGet(reply, 4, "UInt")   ; check for status
errcode := errcode <> 0 ? errcode : errcode+11000
if errcode = 11001   ; function returned 'buffer too small' so we increase it and try again
   {
   VarSetCapacity(reply, NumGet(reply, 12, "UShort")+16)
   DllCall("icmp\IcmpSendEcho", UInt, hPort, UInt, cAdr, UInt, &data, UInt, StrLen(data), UInt, NULL, UInt, &reply, UInt, szreply, UInt, timeout, UInt)
   errcode := NumGet(reply, 4, "UInt")   ; another check for status on 2-nd attempt
   errcode := errcode <> 0 ? errcode : errcode+11000
   }
err := ping_GetError(errcode, "IcmpSendEcho")   ; error handling
DllCall("icmp\IcmpCloseHandle", UInt, hPort)   ; close port
if errcode != 11000            ; IP_SUCCESS
   {
   ErrorLevel = 1
   return err
   }
else
; on success returns ICMP_ECHO_REPLY structure address for external processing of data
   return err := &reply
}
;*********************************
ping_GetError(code, func="[ukn]")      ; error translation
{
str := "Success|Reply buffer too small|Destination network unreachable|Destination host unreachable|Destination protocol unreachable|Destination port unreachable|Insufficient IP resources|Bad IP option specified|Hardware error|Packet too big|Request timed out|Bad request|Bad route|TTL expired in transit|TTL expired during fragment reassembly|Parameter problem|Datagrams are arriving too fast to be processed and datagrams may have been discarded|IP option too big|Bad destination|General failure (possible malformed ICMP packets)"
Loop, Parse, str, |
   {
   if (code = 11000 + A_Index - 1) || (A_Index = 20 && code = 11050)
      return err := "Error " code " [" A_LoopField "] in function " func
   }
return err := "Function " func " returned " code
}
;*********************************
ping_Host2IP(name)
{
ErrorLevel = 0
type := SubStr(name, 1, 1)
if type is alpha
   {
   hostent := DllCall("ws2_32\gethostbyname", UInt, &name, UInt) ; http://msdn.microsoft.com/en-us/library/ms738524(VS.85).aspx
   if !hostent
      {
      err := DllCall("ws2_32\WSAGetLastError")
      ErrorLevel = 1
      return err
      }
   ; string containing protocol types (mainly for debug purposes)
   str := "local to host (pipes, portals)|internetwork: UDP, TCP, etc.|arpanet imp addresses|pup protocols: e.g. BSP|mit CHAOS protocols|XEROX NS protocols or IPX protocols: IPX, SPX, etc.|ISO protocols or OSI is ISO|european computer manufacturers|datakit protocols|CCITT protocols, X.25 etc|IBM SNA|DECnet|Direct data link interface|LAT|NSC Hyperchannel|AppleTalk|NetBios-style addresses|VoiceView|Protocols from Firefox|Unknown - Somebody is using this!|Banyan|Native ATM Services|Internetwork Version 6|Microsoft Wolfpack|IEEE 1284.4 WG AF"
   ptrName := NumGet(hostent+0, 0, "UInt")
   pt := NumGet(hostent+0, 8, "UShort")
   Loop, Parse, str, |
      if (A_Index = pt)
         type := A_LoopField
   len := NumGet(hostent+0, 10, "UShort")
   ptrAddress := NumGet(hostent+0, 12, "UInt")
   ptrIPAddress := NumGet(ptrAddress+0, 0, "UInt")
   strAddress := NumGet(ptrIPAddress+0, 0, "UInt")
   VarSetCapacity(adr, 16, 32)
   DllCall("lstrcpy", UInt, &adr, UInt, DllCall("ws2_32\inet_ntoa", UInt, strAddress))
   VarSetCapacity(adr, -1)
   VarSetCapacity(pname, 260, 32)
   DllCall("lstrcpy", UInt, &pname, UInt, ptrName)
   VarSetCapacity(pname, -1)
   return adr
   }
else
   return name
}
;*********************************
ping_DW2IP(adr)
{
res := NumGet(adr+0, 0, "Uchar") "." NumGet(adr+0, 1, "Uchar") "." NumGet(adr+0, 2, "Uchar") "." NumGet(adr+0, 3, "Uchar")
return res
}
;*********************************
ping(addr, data="AHK ping test", timeout="500") ;?mod shortcut for user, formerly known as A_ping() 
{
; Sockets initialization http://msdn.microsoft.com/en-us/library/ms741563(VS.85).aspx
VarSetCapacity(WSADATA, 12+257+129, 0)   ; WSADATA structure initialization
err := DllCall("wsock32\WSAStartup", Short, 0x101, UInt, &WSADATA, UInt)
if err > 0
   {
   ErrorLevel = 1
   err = Socket initialization error %err%      ; Failed to initialize sockets
   goto error
   }
address := ping_Host2IP(addr)               ; address conversion to DWORD
err := ping_GetError(address, "Host2IP")         ; error handling
if ErrorLevel
   goto error
err := ping_(address, data, timeout)         ; ping function call
error:
EL := ErrorLevel
DllCall("wsock32\WSACleanup")            ; Sockets cleanup & close
ErrorLevel := EL
return err
} 
