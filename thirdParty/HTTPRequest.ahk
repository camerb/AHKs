; ##################################################################################################
; ###                                       HTTPRequest                                          ###
; ##################################################################################################
/*
Copyright © 2011 [VxE]. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted
provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions
and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions
and the following disclaimer in the documentation and/or other materials provided with the
distribution.

3. The name "[VxE]" may not be used to endorse or promote products derived from this software
without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY [VxE] "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL [VxE] BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
SUCH DAMAGE.
*/

HTTPRequest( url, byref in_POST_out_DATA="", byref inout_HEADERS="", options="" ) { ; --------------
; Function by [VxE]. Special thanks to derRaphael for inspiring this function. Version (11-03-2011).
; Available @: http://www.autohotkey.com/forum/viewtopic.php?t=66290
; VersionInfo: http://dl.dropbox.com/u/13873642/mufl_httprequest.txt
; Submits one request to the specified URL and returns the number of bytes in the response.
; 'in_POST_out_DATA' must be a variable, which may contain data to be send as POST data. If the
; request completes successfully, 'in_POST_out_DATA' receives the response data. 'inout_HEADERS'
; must be a variable, and may contain headers to use for the request. If the request completes
; successfully, 'inout_HEADERS' receives the response headers; otherwise it receives an error summary.
; NOTE: If the function encounters an error, an error message will be put into 'inout_HEADERS' and
; the function will return '0'. Since it is possible for a successful request to elicit a response
; with zero bytes, you should consult the response headers to determine if an error occured. On the
; other hand, if you are requesting data, a zero-byte response would indicate an error anyways.
;
; IMPORTANT: each header in 'inout_HEADERS' must conform to the following format:
; "<header name>: <header text>", and multiple headers MUST be separated by a linefeed.
;
; THE FOLLOWING HEADERS ARE HANDLED SPECIALLY:
; Cookie          -> The flag INTERNET_FLAG_NO_COOKIES is applied to the request.
; Content-Length  -> The header is added automatically IF AND ONLY IF the post data is not empty.
;                    Use the Content-Length header to override data length auto-detection.
; Content-MD5     -> The value is computed automatically IF AND ONLY IF the VALUE is left blank.
;                    If the response headers contain a 'Content-MD5' header, a 'Computed-MD5'
;                    header is appended to the response headers with the calculated MD5 hash.
; User-Agent      -> The header is set automatically if it isn't specified or if the value is blank.
;                    NOTE: The automatic user-agent contains the script file's name and OS version.
;                    If this is not desirable, please specify your own user-agent.
; Referrer        -> Is uncorrected to 'Referer' because that's the actual official header name.
;
; Any of the following may appear in the 'options' parameter:
; +FlagName          Use this to set custom flags for a request. 'FlagName' can either be the name
;                    of one of the internet flags specified below OR an exact power of 2.
;                    E.g: "+INTERNET_FLAG_FORMS_SUBMIT", OR "+0x40"
; -FlagName          This can remove an internet flag in case you want to negate one of the default
;                    flags. Default flags include KEEP_CONNECTION, RELOAD and NO_CACHE_WRITE.
; > FilePath         Use this to write the downloaded data to a file (overwriting the file).
;                    After the data has been written to the indicated file, the file is read into
;                    'in_POST_out_DATA' (this function still returns the number of bytes downloaded,
;                    which may not be the actual length of the data). This will overwrite the file
;                    if it already exists. This is functionally similar to URLDownloadToFile.
;                    In version (09-10-2011) and later, the '>' may be preceeded by either 'n', 'r'
;                    or both. 'N' prevents HTTPRequest from reading the file's contents into the
;                    data output variable (in_POST_out_DATA is made blank). 'R' causes HTTPRequest
;                    to resume a download, if the file already exists.
; AutoProxy          Connects using internet explorer's proxy configuration in the registry.
;                    This means that if internet explorer is configured to use a proxy, HTTPRequest
;                    will use that same configuration. NOTE: If this doesn't work, it could mean
;                    that your system is preventing registry access.
; Binary             Tells HTTPReqeust to treat the response data as non-text (i.e: HTTPRequest
;                    won't change the character encoding or update the output variable's length).
; Callback: F[, VAL] Use this to specify a callback function to handle upload/download progress.
;                    The function should require a maximum of 3 parameters. During POST upload, the
;                    function is called with the current fraction of the upload minus 1 as parameter
;                    1, the total number of bytes in the upload as parameter 2, and 'VAL' as
;                    parameter 3. During data download, the function is called with the current
;                    fraction of the download as parameter 1, the total number of bytes in the
;                    download as parameter 2, and 'VAL' as parameter 3. Finally, the function may
;                    return the word "cancel" to cancel the current operation (either upload or
;                    download), possibly terminating the transaction.
; CodePage           Tells HTTPRequest to convert text POST data to the stated codepage.
;                    This option MUST be accompanied by a 'Content-Type' header WITH the 'Charset'
;                    attribute. HTTPRequest will convert the POST data text from the script's
;                    codepage to the one specified as the 'Charset' value.
; Method: VERB       Use the specified HTTP method verb when submitting the request. Normally, the
;                    'POST' verb is used when submitting POST data, otherwise 'GET' is used. Some
;                    APIs require other verbs for certain functions. Supported verbs are 'GET',
;                    'HEAD', 'POST', 'PUT', 'DELETE', 'OPTIONS', and 'TRACE'.
; Proxy: HostURL     Use this options to specify a proxy service to use when making the request.
; ProxyBypass: Host  Use this to define a host (repeat this for multiple hosts) that HTTPRequest
;                    should access directly, not through any proxy.
; Upload: FilePath   Uses the contents of the file at 'filepath' as the POST data, instead of
;                    whatever is in 'in_POST_out_DATA'. This option reads from the file as it
;                    uploads, so only a few KB of the file will be in memory at a time.
;
; ! IMPORTANT ! when submitting text as POST data, be mindful of the character encoding (charset,
; or codepage). HTTPRequest will assume the server will accept the POST data AS-IS unless you
; specifically tell it otherwise. This is particularly important for UNICODE versions of AHK; either
; user StrPut() to convert text to the desired codepage, or use the 'CodePage' option (see above)
; along with a 'Content-Type' header that has the 'charset' attribute.

     Static WorA := "", psz, pty, macp, macs, ModuleName := "WinINet.dll"
	, URL_Components, Scheme, Host, User, Pass, UrlPath, ExtraInfo
	, grep_text_type_content := "text/.*|.*/(?:atom|html|json|soap|xhtml|xml|x-www-form-urlencoded)"
	, iFlagList := "
; The list of internet flags and values has been condensed and obfuscated for version (09-10-2011).
; Flag values may be found here > http://msdn.microsoft.com/en-us/library/aa383661%28v=vs.85%29.aspx
( LTRIM JOIN|INTERNET_FLAG_
	....
	NEED_FILE
	MUST_CACHE_REQUEST|.
	FWD_BACK|.
	FORMS_SUBMIT|..
	PRAGMA_NOCACHE|.
	NO_UI|.
	HYPERLINK|.
	RESYNCHRONIZE|.
	IGNORE_CERT_CN_INVALID|.
	IGNORE_CERT_DATE_INVALID|.
	IGNORE_REDIRECT_TO_HTTPS|.
	IGNORE_REDIRECT_TO_HTTP|..
	RESTRICTED_ZONE|.
	NO_AUTH|.
	NO_COOKIES|.
	READ_PREFETCH|.
	NO_AUTO_REDIRECT|.
	KEEP_CONNECTION|.
	SECURE|.
	FROM_CACHE
	OFFLINE|.
	MAKE_PERSISTENT|.
	DONT_CACHE|...
	NO_CACHE_WRITE|.
	RAW_DATA|.
	RELOAD|
)"
	, CPList := "|
; Codepage list taken from here > http://msdn.microsoft.com/en-us/library/dd317756%28v=vs.85%29.aspx
( LTRIM JOIN|
	00037=IBM037|00437=IBM437|00500=IBM500|00708=ASMO-708|00720=DOS-720|00737=ibm737
	00775=ibm775|00850=ibm850|00852=ibm852|00855=IBM855|00857=ibm857|00858=IBM00858|00860=IBM860
	00861=ibm861|00862=DOS-862|00863=IBM863|00864=IBM864|00865=IBM865|00866=cp866|00869=ibm869
	00870=IBM870|00874=windows-874|00875=cp875|00932=shift_jis|00936=gb2312|00949=ks_c_5601-1987
	00950=big5|01026=IBM1026|01047=IBM01047|01140=IBM01140|01141=IBM01141|01142=IBM01142
	01143=IBM01143|01144=IBM01144|01145=IBM01145|01146=IBM01146|01147=IBM01147|01148=IBM01148
	01149=IBM01149|01200=utf-16|01201=unicodeFFFE|01250=windows-1250|01251=windows-1251
	01252=Windows-1252|01253=windows-1253|01254=windows-1254|01255=windows-1255
	01256=windows-1256|01257=windows-1257|01258=windows-1258|01361=Johab|10000=macintosh
	10001=x-mac-japanese|10002=x-mac-chinesetrad|10003=x-mac-korean|10004=x-mac-arabic
	10005=x-mac-hebrew|10006=x-mac-greek|10007=x-mac-cyrillic|10008=x-mac-chinesesimp
	10010=x-mac-romanian|10017=x-mac-ukrainian|10021=x-mac-thai|10029=x-mac-ce
	10079=x-mac-icelandic|10081=x-mac-turkish|10082=x-mac-croatian|12000=utf-32|12001=utf-32BE
	20000=x-Chinese-CNS|20001=x-cp20001|20002=x-Chinese-Eten|20003=x-cp20003|20004=x-cp20004
	20005=x-cp20005|20105=x-IA5|20106=x-IA5-German|20107=x-IA5-Swedish|20108=x-IA5-Norwegian
	20127=us-ascii|20261=x-cp20261|20269=x-cp20269|20273=IBM273|20277=IBM277|20278=IBM278
	20280=IBM280|20284=IBM284|20285=IBM285|20290=IBM290|20297=IBM297|20420=IBM420|20423=IBM423
	20424=IBM424|20833=x-EBCDIC-KoreanExtended|20838=IBM-Thai|20866=koi8-r|20871=IBM871
	20880=IBM880|20905=IBM905|20924=IBM00924|20932=EUC-JP|20936=x-cp20936|20949=x-cp20949
	21025=cp1025|21866=koi8-u|28591=iso-8859-1|28592=iso-8859-2|28593=iso-8859-3|28594=iso-8859-4
	28595=iso-8859-5|28596=iso-8859-6|28597=iso-8859-7|28598=iso-8859-8|28599=iso-8859-9
	28603=iso-8859-13|28605=iso-8859-15|29001=x-Europa|38598=iso-8859-8-i|50220=iso-2022-jp
	50221=csISO2022JP|50222=iso-2022-jp|50225=iso-2022-kr|50227=x-cp50227|51932=euc-jp
	51936=EUC-CN|51949=euc-kr|52936=hz-gb-2312|54936=GB18030|57002=x-iscii-de|57003=x-iscii-be
	57004=x-iscii-ta|57005=x-iscii-te|57006=x-iscii-as|57007=x-iscii-or|57008=x-iscii-ka
	57009=x-iscii-ma|57010=x-iscii-gu|57011=x-iscii-pa|65000=utf-7|65001=utf-8|
)"

	If ( WorA = "" ) ; Initialize Static Varaibles
	{
		WorA := A_IsUnicode ? "W" : "A" ; Either 'A' (ansi) or 'W' (wide-chars).
	; Filling the URL_Components structure with the addresses of static variables only needs to
	; happen once per script instance. For unicode, the string capacities are doubled.
	; URL_COMPONENTS structure > http://msdn.microsoft.com/en-us/library/aa385420%28v=VS.85%29.aspx
		psz := A_PtrSize = "" ? 4 : A_PtrSize, pty := A_PtrSize = 8 ? "Ptr" : "UInt"
		macp := WorA = "W" ? "01200" : SubStr( 100000.0 + DllCall("GetACP"), 2, 5 )
		StringGetPos, pos, CPList, % "|" macp "="
		StringMid, macs, CPList, pos + 8, InStr( CPList, "|", 0, pos ) - pos - 8
		VarSetCapacity( URL_Components, 4 * 9 + ( 6 * psz ) , 0 )
		NumPut( 60, URL_Components, 0, "Int" )
		VarSetCapacity( Scheme, 16 << !! A_IsUnicode, 0 )
		NumPut( &Scheme, URL_Components, 4, "UInt" )
		VarSetCapacity( Host, 2048 << !! A_IsUnicode, 0 )
		NumPut( &Host, URL_Components, 12 + psz, "UInt" )
		VarSetCapacity( User, 2048 << !! A_IsUnicode, 0 )
		NumPut( &User, URL_Components, 20 + 2 * psz, "UInt" )
		VarSetCapacity( Pass, 2048 << !! A_IsUnicode, 0 )
		NumPut( &Pass, URL_Components, 24 + 3 * psz, "UInt" )
		VarSetCapacity( UrlPath, 4096 << !! A_IsUnicode, 0 )
		NumPut( &UrlPath, URL_Components, 28 + 4 * psz, "UInt" )
		VarSetCapacity( ExtraInfo, 4096 << !! A_IsUnicode, 0 )
		NumPut( &ExtraInfo, URL_Components, 32 + 5 * psz, "UInt" )
	}

	iOpenType := 1, iDoCallback := Ignore_Text := output_resume := inohash := ifail := 0
	hRequest := hConnection := hInternet := hModule := 0
	options := "`n" options "`n"

	; Properly format the headers. For each line in the headers, check to make sure it's formatted
	; like a header (Name: Value) and if it is, then append it to the the actual headers followed
	; by CRLF. Also, check the headers for additional flags the user may want to use.
	VarSetCapacity( inout_HEADERS, StrLen( buffer := inout_HEADERS ) << ( WorA = "W" ), 0 )
	Loop, Parse, buffer, `n
		IfInString, A_LoopField, :
		{
			StringReplace, buffer, A_LoopField, :, `n
			Loop, Parse, buffer, `n, % "`t`r "
				If ( A_Index = 1 )
					buffer := A_LoopField
				Else If ( buffer = "Accept" )
;					inout_HEADERS .= "Accept: " ( Accept_Types := A_LoopField )
					Accept_Types := A_LoopField
				Else If ( buffer = "User-Agent" )
					inout_HEADERS .= "User-Agent: " ( Agent := A_LoopField ) "`r`n"
				Else If ( buffer = "Content-MD5" ) && ( A_LoopField = "" )
					inout_HEADERS .= "Content-MD5: `r`n"
				Else If ( buffer = "Referer" || headername = "Referrer" )
					inout_HEADERS .=  "Referer: " ( Referer_URL := A_LoopField ) "`r`n"
				Else If ( buffer = "Content-Length" )
					Content_Length := A_LoopField
				Else If ( buffer = "Content-Type" )
				{
					content := A_LoopField
					Loop, Parse, content, % ";", % "`t "
						If ( A_Index = 1 )
							content_type := A_LoopField
						Else If InStr( A_LoopField, "charset=" ) = 1
							StringTrimLeft, content_charset, A_LoopField, 8
				}
				Else inout_HEADERS .= buffer ": " A_LoopField "`r`n"
		}

	Flags := 0 ; Typical flags for normal HTTP requests.
	| 0x400000 ; INTERNET_FLAG_KEEP_CONNECTION
	| 0x80000000 ; INTERNET_FLAG_RELOAD
	| 0x20000000 ; INTERNET_FLAG_NO_CACHE_WRITE
	| ( InStr( "`r`n" inout_HEADERS, "`r`nCookie: " ) ? 0x80000 : 0 ) ; INTERNET_FLAG_NO_COOKIES

	; Handle any other options specified
	Loop, Parse, options, `n, % "`t`r "
		If InStr( "+-", SubStr( A_LoopField " ", 1, 1 ) ) ; flags begin with either + or -
		{
			options := RegexReplace( A_LoopField, "i)[+-](flag)?\W*" )
			If options IS NOT INTEGER
			{
				StringGetPos, pos, iFlagList, % "|" SubStr( A_LoopField, 2 ) "|"
				If ( ErrorLevel )
					StringGetPos, pos, iFlagList, % "|INTERNET_FLAG_" SubStr( A_LoopField, 2 ) "|"
				If ( ErrorLevel )
					Continue
				StringLeft, options, iFlagList, pos
				StringReplace, options, options, ., ., UseErrorLevel
				options := 1 << ErrorLevel
			}
			Else If ( options != 1 << Round( Ln( options ) / Ln( 2 ) ) )
				Continue
			flags := Asc( A_LoopField ) = 45 ? ~options & flags : options | flags
		}
		Else If ( pos := InStr( A_LoopField, ">" ) + 3 >> 2 = 1 )
			Loop, Parse, A_LoopField, >, % "`t`n`r "
				If ( A_Index != 1 ) && ( !InStr( A_LoopField, "\" ) || FileExist( RegexReplace( A_LoopField, ".*\K\\.*" ) ) )
				{
					output_file := A_LoopField
					no_output := !!InStr( output_options, "n" )
					If ( output_resume := InStr( output_options, "r" ) && FileExist( output_file ) )
					{
						FileGetSize, output_resume, % output_file
						inout_Headers .= "Range: bytes=" . SubStr( output_resume + 0.0, 1, 1
						+ Floor( Log( output_resume ) ) ) "-" RegexReplace( "`r`n" inout_Headers, "i)\v+\KRange:\V*\v+" )
					}
				}
				Else output_options .= A_LoopField
		Else If ( A_LoopField = "binary" )
			Ignore_Text := 1
		Else If ( A_LoopField = "codepage" )
			Do_Codepage := 1
		Else If ( A_LoopField = "autoproxy" )
			iOpenType := 0
		Else If ( A_LoopField = "nohash" )
			inohash := 1
		Else IfInString, A_LoopField, :
		{
			StringReplace, options, A_LoopField, :, `n
			Loop, Parse, options, `n, % "`t`r "
				If ( A_Index = 1 )
					options := A_LoopField
				Else If ( options = "Callback" ) ; use a transfer progress callback
				{
					RegexMatch( A_LoopField, "(?<_func>[\w@#$]*)[\h,]*(?<_val>.*)", iDoCallback )
					iDoCallback := IsFunc( iDoCallback_func ) + 3 >> 2 = 1 ; OK if 0,1,2,3 params needed
					StringReplace, iDoCallback_val, iDoCallback_val, ``n, `n, A
				}
				Else If ( options = "Upload" ) ; upload this file instead of the POST data
					bDoFileUpload := "" != FileExist( upload_file := A_LoopField )
				Else If ( options = "Proxy" ) ; use a proxy (don't bother checking the URL validity)
					proxy_url := A_LoopField, iOpenType := 3, bUseProxy := 1
				Else If ( options = "ProxyBypass" ) ; bypass the proxy for these hosts
					proxy_bypass .= A_LoopField "`r`n"
				Else If ( options = "Method" ) && ( A_LoopField = "GET" || A_LoopField = "HEAD"
					|| A_LoopField = "POST" || A_LoopField = "PUT" || A_LoopField = "DELETE"
					|| A_LoopField = "OPTIONS" || A_LoopField = "TRACE" )
					StringUpper, Method, A_LoopField
		}
	StringTrimRight, proxy_bypass, proxy_bypass, 2

	If ( Accept_Types = "" )
		Accept_Types := "text/xml, text/json q=0.4, text/html q=0.3, text/* q=0.2, */* q=0.1"
	If ( Agent = "" )
		inout_HEADERS .= "User-Agent: " ( Agent := RegexReplace( A_ScriptName, ".*\K\..*" ) "/1.0 (Language=AutoHotkey/" A_AhkVersion "; Platform=" A_OSVersion ")" ) "`r`n"
	If ( Content_Length = "" )
		If ( bDoFileUpload )
			FileGetSize, Content_Length, % upload_file
		Else StringLen, Content_Length, in_POST_out_DATA
	If ( Method = "" )
		Method := Content_Length ? "POST" : "GET"

	; If there IS POST data (length > zero) then make sure there is also a content-type header.
	If ( Content_Length := SubStr( Content_Length + 0.0, 1, 1 + Floor( Log( Content_Length ))))
	{
		; Detect the content type in the input headers. Default is either XML or forms data.
		If ( Content_Type = "" ) || ( Content_Type = "charset" )
		{
			StringGetPos, pos, in_POST_out_DATA, <?xml
			Content_Type := !ErrorLevel && pos < 5 ? "text/xml" : "application/x-www-form-urlencoded"
		}
		If ( Content_Charset = "" )
			Content_Charset := macs
		; For text POST data, make sure the charset attribute is also in the content-type header.
		If RegexMatch( Content_Type, "i)" grep_text_type_content )
		{
			If ( Content_Charset = "" )
			{
				pos := 7 + InStr( CPList, "|" macp "=" )
				StringMid, Content_Charset, CPList, pos, InStr( CPList, "|", 0, pos ) - pos
			}
			StringGetPos, pos, CPList, % "=" Content_Charset "|"
			StringMid, CodePage, CPList, pos - 4, 5

			If ( Do_Codepage ) && ( CodePage != macp )
			{
				If ( WorA = "W" )
					buffer := in_POST_out_DATA
				Else
				{
				; MultiByteToWideChar > http://msdn.microsoft.com/en-us/library/dd319072%28v=vs.85%29.aspx
					Content_Length := DllCall( "MultiByteToWideChar"
						, "UInt", macp, "UInt", 0
						, pty, &in_POST_out_DATA, "UInt", size := Content_Length
						, pty, 0, "UInt", 0 )
					VarSetCapacity( buffer, Content_Length + 1 << 1, 0 )
					DllCall( "MultiByteToWideChar"
						, "UInt", macp, "UInt", 0
						, pty, &in_POST_out_DATA, "UInt", size
						, pty, &buffer, "UInt", Content_Length )
				}
				; WideCharToMultiByte > http://msdn.microsoft.com/en-us/library/dd374130%28v=vs.85%29.aspx
				Content_Length := DllCall( "WideCharToMultiByte"
					, "UInt", CodePage, "UInt", 0
					, pty, &buffer, "UInt", size := Content_Length
					, pty, 0, "UInt", 0
					, pty, 0, pty, 0 )
				VarSetCapacity( in_POST_out_DATA, Content_Length + 1, 0 )
				DllCall( "WideCharToMultiByte"
					, "UInt", CodePage, "UInt", 0
					, pty, &buffer, "UInt", size
					, pty, &in_POST_out_DATA, "UInt", Content_Length
					, pty, 0, pty, 0 )
				buffer := ""
				inout_HEADERS .= "Content-Length: " ( Content_Length := SubStr( Content_Length + 0.0, 1, 1 + Floor( Log( size ) ) ) ) "`r`n"
			}
			inout_HEADERS .= "Content-Type: " Content_Type "; Charset=" Content_Charset "`r`n"
		}
		Else inout_HEADERS .= "Content-Type: " Content "`r`n"
	}
	IfInString, inout_HEADERS, % "Content-MD5: `r`n"
		StringReplace, inout_HEADERS, inout_HEADERS, % "Content-MD5: `r`n", % "Content-MD5: " HTTPRequest_MD5( in_POST_out_DATA, bDoFileUpload ? upload_file : Content_Length ) "`r`n"

	size := 0
	; Load WinINet.dll
	If !( hModule := DllCall( "LoadLibrary" WorA, pty, &ModuleName ) )
		inout_HEADERS := "There was a problem loading WinINet.dll. ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
	Else Loop 1 ; Version (10-9-2011) uses a loop so 'Break' jumps to the cleanup step.
{
	; Put the sizes into the URL_Components structure (the sizes are the same for unicode and ansi
	; because the sizes are actually a character count, not a byte count).
	NumPut( 0016, URL_Components, 04 + 1 * psz, "Int" )
	NumPut( 2048, URL_Components, 12 + 2 * psz, "Int" )
	NumPut( 2048, URL_Components, 20 + 3 * psz, "Int" )
	NumPut( 2048, URL_Components, 24 + 4 * psz, "Int" )
	NumPut( 4096, URL_Components, 28 + 5 * psz, "Int" )
	NumPut( 4096, URL_Components, 32 + 6 * psz, "Int" )

	URL := InStr( URL, "://" ) >> 2 = 1 ? URL : "http://" URL ; add scheme if it doesn't seem to be there
	; InternetCrackUrl > http://msdn.microsoft.com/en-us/library/aa384376%28VS.85%29.aspx
	If !DllCall( "WinINet\InternetCrackUrl" WorA, pty, &URL, "Int", StrLen( URL ), "UInt", 0, pty, &URL_Components )
	{
		inout_HEADERS := "There was a problem with the provided URL (InternetCrackUrl). ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
		Break
	}
	; The port should always be 80... but if it's zero, then something went terribly wrong
	If !( Port := NumGet( URL_Components, 24, "UShort" ) )
	{
		inout_HEADERS := "There was a problem with the provided URL. The connection port could not be determined."
		Break
	}

	; Update the internal lengths of the strings that were just cracked
	VarSetCapacity( Scheme, -1 )
	VarSetCapacity( Host, -1 )
	VarSetCapacity( User, -1 )
	VarSetCapacity( Pass, -1 )
	VarSetCapacity( UrlPath, -1 )
	VarSetCapacity( ExtraInfo, -1 )
	Query := UrlPath ExtraInfo

	If ( Scheme = "https" ) ; Apply the following flags to HTTPS requests:
	; INTERNET_FLAG_IGNORE_CERT_CN_INVALID, INTERNET_FLAG_IGNORE_CERT_DATE_INVALID, INTERNET_FLAG_SECURE
		Flags |= 0x1000 | 0x2000 | 0x800000 ; Technically, INTERNET_FLAG_SECURE is redundant for https
	Else If ( Scheme != "http" )
	{
	; Schemes other than HTTP and HTTPS are not supported by this function.
		inout_HEADERS := "HTTPRequest does not support '" Scheme "' type connections."
		Break
	}

	; Tweak the accept type string to look like a list
	Loop, Parse, Accept_Types, `,, % "`t`r "
		Loop, Parse, A_LoopField, % Chr( 59 + !( pos := A_Index ) ), % "`t`n`r "
			If ( A_Index = 1 )
				If ( pos = 1 )
					Accept_Types := A_LoopField
				Else Accept_Types .= "`n" A_LoopField
	VarSetCapacity( int_array, ( pos + 1 ) * psz, pos := 0 )

	; Build an array of pointers to the valid accept type strings and insert nulls into the
	; accept types string to make it look like a collection of null-terminated strings.
	Loop, Parse, Accept_Types, `n
		If ( WorA = "W" )
		{
			NumPut( &Accept_Types + pos, int_array, ( A_Index - 1 ) * psz, pty )
			NumPut( 0, Accept_Types, -2 + pos += 1 + StrLen( A_LoopField ) << 1, "UShort" )
		}
		Else
		{
			NumPut( &Accept_Types + pos, int_array, ( A_Index - 1 ) * psz, pty )
			NumPut( 0, Accept_Types, -1 + pos += 1 + StrLen( A_LoopField ), "UChar" )
		}

	; Get an internet handle. InternetOpen > http://msdn.microsoft.com/en-us/library/aa385096(v=VS.85).aspx
	If !( hInternet := DllCall( "WinINet\InternetOpen" WorA
		, pty, &Agent
		, "UInt", iOpenType ; INTERNET_OPEN_TYPE:( _PRECONFIG = 0 | _DIRECT = 1 | _PROXY = 3 )
		, pty, bUseProxy ? &proxy_url : 0
		, pty, bUseProxy && proxy_bypass = "" ? 0 : &proxy_bypass
		, "UInt", 0 ) )
	{
		inout_HEADERS := "There was a problem opening an internet handle. ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
		Break
	}

	; Open a connection. InternetConnect > http://msdn.microsoft.com/en-us/library/aa384363%28v=VS.85%29.aspx
	If !( hConnection := DllCall( "WinINet\InternetConnect" WorA, pty, hInternet
		, pty, &Host
		, "UInt", Port
		, pty, &User
		, pty, &Pass
		, "UInt", 3 ; INTERNET_SERVICE_HTTP = 3
		, "UInt", Flags
		, "UInt", 0 ) )
	{
		inout_HEADERS := "There was a problem opening a connection to the host. ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
		Break
	}

	; Open a request. HttpOpenRequest > http://msdn.microsoft.com/en-us/library/aa384233%28v=VS.85%29.aspx
	If !( hRequest := DllCall( "WinINet\HttpOpenRequest" WorA, pty, hConnection
		, pty, &Method
		, pty, &Query
		, pty, &( scheme := "HTTP/1.1" )
		, pty, &Referer_URL
		, pty, &int_array
		, "UInt", Flags ) )
	{
		inout_HEADERS := "There was a problem opening the request. ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
		Break
	}

	; apply the headers to the request ( to allow header errors to be detected and reported )
	If !( DllCall( "WinINet\HttpAddRequestHeaders" WorA, pty, hRequest
		, pty, &inout_HEADERS
		, "UInt", StrLen( inout_HEADERS )
		, "UInt", 0x20000000 ) ) ; HTTP_ADDREQ_FLAG_ADD = 0x20000000
	{
		inout_HEADERS := "There was a problem applying one or more headers to the request. ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError "`nHeaders:`n" inout_HEADERS
		StringReplace, inout_HEADERS, inout_HEADERS, `r`n, `n, A
		Break
	}

	; Tweak: version (10-19-2011). Apply the SECURITY_FLAG_IGNORE_UNKNOWN_CA flag
	; WINHTTP_OPTION_SECURITY_FLAGS = 31, SECURITY_FLAG_IGNORE_UNKNOWN_CA = 0x100
	; Uncomment the next two lines if you're receiving ERROR_INTERNET_INVALID_CA (12045)
;	If DllCall( "WinINet\InternetQueryOption" WorA, pty, hRequest, "UInt", 31, "UInt*", pos, "UInt*", 4 )
;		DllCall( "WinINet\InternetSetOption" WorA, pty, hRequest, "UInt", 31, "UInt*", pos |= 0x100, "UInt*", 4 )

	; Update: Version (7-1-2011) - To implement the upload progress callback, I needed to swap out
	; the HttpSendRequest function for HttpSendRequestEx, which allows tighter control over the
	; POST operation. GET requests still use the HttpSendRequest function (for simplicity).
	If ( 0 < Content_Length )
	{
		VarSetCapacity( int_array, 40, 0 )
		NumPut( 40, int_array, 0, "Int" )
		NumPut( Content_Length, int_array, 28, "Int" )
		; Send the POST request. HttpSendRequestEx > http://msdn.microsoft.com/en-us/library/aa384318%28v=VS.85%29.aspx
		If !( DllCall( "WinINet\HttpSendRequestEx" WorA, pty, hRequest
			, pty, &int_array, "UInt", 0, pty, 0, "UInt", 0 ) )
		{
			inout_HEADERS := "There was a problem sending the " method " request. ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
			Break
		}

		If ( iDoCallback ) && "cancel" = %iDoCallback_func%( -1, Content_Length, iDoCallback_val )
		{
			inout_HEADERS := "The callback function '" iDoCallback_func "' returned 'cancel' to terminate the data upload."
			Break
		}
		; (9-10-2011) See if the user wants to upload a file from disk, rather than from memory.
		If ( bDoFileUpload )
		{
			VarSetCapacity( buffer, 4096, 0 ) ; Use a 4K buffer
			If !( hFile := DllCall( "CreateFile" WorA, pty, &upload_file
				, "UInt", 0x80000000 ; GENERIC_READ = 0x80000000
 				, "UInt", 0, pty, 0
				, "UInt", 4 ; OPEN_ALWAYS = 4
				, "UInt", 0, pty, 0 ) )
			{
				inout_HEADERS := "There was a problem opening the file """ upload_file """. ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
				Break
			}
			Loop ; Read the file and upload it in 4K chunks
				If ( Content_Length <= size )
					Break
				Else
				{
					pos := size + 4096 < Content_Length ? 4096 : Content_Length - size
					; ReadFile > http://msdn.microsoft.com/en-us/library/aa365467%28v=VS.85%29.aspx
					If ( ifail := !DllCall( "ReadFile", pty, hFile
						, pty, &buffer
						, "UInt", pos
						, "Int*", int_array
						, pty, 0 ) )
						{
							inout_HEADERS := "There was a problem reading from the file """ upload_file """. ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
							Break
						}
					pos := int_array
					; InternetWriteFile > http://msdn.microsoft.com/en-us/library/aa385128%28v=VS.85%29.aspx
					If !( ifail := DllCall( "WinINet\InternetWriteFile", pty, hRequest
						, pty, &buffer
						, "UInt", pos
						, "Int*", int_array ) )
					{
						inout_HEADERS := "There was a problem uploading the POST data. ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
						Break
					}
					size += int_array

					If ( ifail := ( iDoCallback ) && "cancel" = %iDoCallback_func%( size / Content_Length - 1, Content_Length, iDoCallback_val ) )
					{
						inout_HEADERS := "The callback function '" iDoCallback_func "' returned 'cancel' to terminate the data upload."
						Break
					}
				}
			DllCall( "CloseHandle", pty, hFile )
		}
		Else Loop ; Submit the POST data from memory in 4K chunks
				If ( Content_Length <= size )
					Break
				Else
				{
					If ( ifail := !DllCall( "WinINet\InternetWriteFile", pty, hRequest
						, pty, &in_POST_out_DATA + size
						, "Int", size + 4096 < Content_Length ? 4096 : Content_Length - size
						, "Int*", int_array ) )
					{
						inout_HEADERS := "There was a problem uploading the POST data. ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
						Break
					}
					size += int_array

					If ( ifail := ( iDoCallback ) && "cancel" = %iDoCallback_func%( size / Content_Length - 1, Content_Length, iDoCallback_val ) )
					{
						inout_HEADERS := "The callback function '" iDoCallback_func "' returned 'cancel' to terminate the data upload."
						Break
					}
				}
		; A request opened by HttpSendRequestEx must be closed by HttpEndRequest.
		; HttpEndRequest > http://msdn.microsoft.com/en-us/library/aa384230%28v=VS.85%29.aspx
		DllCall( "WinINet\HttpEndRequest" WorA, pty, hRequest, pty, 0, "UInt", 0, pty, 0 )
		If ( ifail )
			Break

		If ( iDoCallback ) && "cancel" = %iDoCallback_func%( "", 0, iDoCallback_val )
		{
			inout_HEADERS := "The callback function '" iDoCallback_func "' returned 'cancel' to terminate the transaction."
			DllCall( "WinINet\HttpEndRequest" WorA, pty, hRequest, pty, 0, "UInt", 0, pty, 0 )
			DllCall( "WinINet\InternetCloseHandle", pty, hRequest )
			DllCall( "WinINet\InternetCloseHandle", pty, hConnection )
			DllCall( "WinINet\InternetCloseHandle", pty, hInternet )
			DllCall( "FreeLibrary", pty, hModule )
			Return 0
		}
	}
	Else	; Send no POST data. HttpSendRequest > http://msdn.microsoft.com/en-us/library/aa384247%28v=VS.85%29.aspx
		If !( DllCall( "WinINet\HttpSendRequest" WorA, pty, hRequest
			, pty, 0, "UInt", 0, pty, 0, "UInt", 0 ) )
		{
			inout_HEADERS := "There was a problem sending the " method " request. ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
			Break
		}

	; Query the request for ready data. Actually, it waits for data to become ready.
	; InternetQueryDataAvailable > http://msdn.microsoft.com/en-us/library/aa385100%28v=VS.85%29.aspx
	DllCall( "WinINet\InternetQueryDataAvailable", pty, hRequest, "Int*", int_array, "UInt", 0, pty, 0 )

	VarSetCapacity( inout_HEADERS, int_array := 4096, 0 ) ; use 4K as first-try for response header length.
	Loop 2 ; Get the response headers separated by CRLF. The first line has the HTTP response code
	{
		; HttpQueryInfo > http://msdn.microsoft.com/en-us/library/aa384238%28v=VS.85%29.aspx
		If ( pos := DllCall( "WinINet\HttpQueryInfo" WorA, pty, hRequest
			, "UInt", 22 ; HTTP_QUERY_RAW_HEADERS_CRLF = 22
			, pty, &inout_HEADERS
			, "Int*", int_array
			, pty, 0 ) )
				Break

		If ( A_LastError = 122 ) ; ERROR_INSUFFICIENT_BUFFER = 122
			VarSetCapacity( inout_HEADERS, int_array + 2, 0 )
	}

	If !( pos )
	{
		inout_HEADERS := "There was a problem reading the response headers. ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError
		Break
	}

	; Update response header outputvar length and remove carriage returns
	VarSetCapacity( inout_HEADERS, -1 )
	StringReplace, inout_HEADERS, inout_HEADERS, `r`n, `n, A
	StringMid, ResponseCode, inout_HEADERS, InStr( inout_HEADERS, " " ) + 1, 3
	; Get the content length header (since the content-length header is not guaranteed to be in
	; the response headers, the value is only used in the progress callback function).
	RegexMatch( inout_HEADERS "`nContent-Length: 65536", "i)`nContent-Length: \K\d+", Content_Length )

	; Download the response data
	Size := 0
	If ( iDoCallback ) && "cancel" = %iDoCallback_func%( ( output_resume + size )
	/ ( Content_Length + output_resume ), Content_Length + output_resume, iDoCallback_val )
		inout_HEADERS .= "The callback function '" iDoCallback_func "' returned 'cancel' to terminate the download. Only " size " bytes were downloaded.`n"
	Else If ( output_resume && ResponseCode != "206" )
		inout_HEADERS .= "Resume download failed: the server did not respond with '206 Partial Content'.`n"
	Else If ( output_file != "" )
	{
		; If the user isn't resuming a download, then delete the file if it exists.
		If !( output_resume ) && FileExist( output_file )
			FileDelete, % output_file

		; Use binary-mode file write. CreateFile > http://msdn.microsoft.com/en-us/library/aa363858%28v=vs.85%29.aspx
		If !( hFile := DllCall( "CreateFile" WorA, pty, &output_file
				, "UInt", 0x40000000 ; GENERIC_WRITE = 0x40000000
 				, "UInt", 0, pty, 0
				, "UInt", 4 ; OPEN_ALWAYS = 4
				, "UInt", 0, pty, 0 ) )
			inout_HEADERS .= "HTTPRequest Error: Could not create/open the file for writing. ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError "`n"
		Else
		{
			If ( output_resume ) ; output_resume holds the size in bytes of the partially downloaded file
			; SetFilePointerEx > http://msdn.microsoft.com/en-us/library/aa365542%28v=VS.85%29.aspx
				DllCall( "SetFilePointerEx", pty, hfile
					, "Int64", output_resume
					, pty, 0, "UInt", 0 )
			If ( no_output )
				VarSetCapacity( in_POST_out_DATA, 0 )
			; Read from the internet response and write to the file
			Loop
			{
				VarSetCapacity( buffer, 4096, 0 ) ; Use a 4K buffer
				; InternetReadFile > http://msdn.microsoft.com/en-us/library/aa385103%28v=VS.85%29.aspx

				If !( pos := DllCall( "WinINet\InternetReadFile", pty, hRequest
					, pty, &buffer
					, "UInt", 4096
					, "Int*", int_array ) ) || !int_array
				{
					; CloseHandle > http://msdn.microsoft.com/en-us/library/ms724211%28v=vs.85%29.aspx
					If !( pos )
						inout_HEADERS .= "HTTPRequest Warning: InternetReadFile Failed. ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError "`n"
					Else If !( no_output )
					; ReadFile > http://msdn.microsoft.com/en-us/library/aa365467%28v=VS.85%29.aspx
						VarSetCapacity( in_POST_out_DATA, size + 2, 0 )
						, DllCall( "ReadFile", pty, hFile, pty, &in_POST_out_DATA, "UInt", size, pty, 0, pty, 0 )
					DllCall( "CloseHandle", pty, hFile )
					Break
				}
				Sleep -1
				Size += int_array
				; WriteFile > http://msdn.microsoft.com/en-us/library/aa365747%28v=vs.85%29.aspx
				If !DllCall( "WriteFile", pty, hFile, pty, &buffer, "UInt", int_array, "Int*", int_array, pty, 0 )
				{
					inout_HEADERS .= "HTTPRequest Error: There was a problem writing to the file. ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError "`n"
					DllCall( "CloseHandle", pty, hFile )
					FileDelete, % output_file
					Break
				}
				Sleep -1
				If ( iDoCallback ) && "cancel" = %iDoCallback_func%( ( size + output_resume )
				/ ( Content_Length + output_resume ), Content_Length + output_resume, iDoCallback_val )
				{
					inout_HEADERS .= "The callback function '" iDoCallback_func "' returned 'cancel' to terminate the download. Only " size " bytes were downloaded.`n"
					DllCall( "CloseHandle", pty, hFile )
					Break
				}
			}
			buffer := ""
			If !inohash && InStr( inout_HEADERS, "`nContent-MD5: " )
				inout_HEADERS .= "Computed-MD5: " HTTPRequest_MD5( buffer, output_file ) "`n"
		}
	}
	Else
	{
		; Read the response and store it into a pseudo-array of buffers
		Loop
		{
			buffer := A_Index
			VarSetCapacity( HTTPRequest_Buffer_%A_Index% := "", 4096, 0 )
			; InternetReadFile > http://msdn.microsoft.com/en-us/library/aa385103%28v=VS.85%29.aspx
			pos := DllCall( "WinINet\InternetReadFile", pty, hRequest
				, pty, &HTTPRequest_Buffer_%A_Index%
				, "UInt", 4096
				, "Int*", int_array )
			If !( pos && int_array )
				Break
			Size += HTTPRequest_BufferSize_%A_Index% := int_array
			Sleep -1
			If ( iDoCallback ) && "cancel" = %iDoCallback_func%( ( size + output_resume )
			/ ( Content_Length + output_resume ), Content_Length + output_resume, iDoCallback_val )
			{
				inout_HEADERS .= "The callback function '" iDoCallback_func "' returned 'cancel' to terminate the download. Only " size " bytes were downloaded.`n"
				Break
			}
		}
		If !( pos )
			inout_HEADERS .= "HTTPRequest Warning: InternetReadFile Failed. ErrorLevel = " ErrorLevel ", A_LastError = " A_LastError "`n"
		VarSetCapacity( in_POST_out_DATA, Size + 1 << !!A_IsUnicode, 0 ) ; always put an ending null, even for non-text data
		Size := 0
		Loop % buffer - 1 ; Then copy the buffered data into the output parameter.
		{
			; MoveMemory > http://msdn.microsoft.com/en-us/library/aa366788%28v=vs.85%29.aspx
			DllCall( "RtlMoveMemory"
				, pty, &in_POST_out_DATA + Size
				, pty, &HTTPRequest_Buffer_%A_Index%
				, "UInt", HTTPRequest_BufferSize_%A_Index% )
			Size += HTTPRequest_BufferSize_%A_Index%
			HTTPRequest_Buffer_%A_Index% := ""
		}
		If !inohash && InStr( inout_HEADERS, "`nContent-MD5: " )
			inout_HEADERS .= "Computed-MD5: " HTTPRequest_MD5( in_POST_out_DATA, size ) "`n"
	} ; End Else
}
	If ( iDoCallback )
		%iDoCallback_func%( 1, Content_Length, iDoCallback_val )

	; Convert the text result's codepage to the instance's codepage
	If ( !Ignore_Text && size ) && RegexMatch( inout_HEADERS, "i)`nContent-Type: \K\V+", Content )
	&& RegexMatch( SubStr( Content, 1, InStr( Content " ", " " ) - 1 ), "i)" grep_text_type_content )
		If !InStr( Content ";", " charset=" macs ";" )
		{
			StringGetPos, pos, CPList, % RegexReplace( Content, "i).*\bcharset(=[\w-]+).*", "$1|" )
			StringMid, CodePage, CPList, pos - 4, 5
			size := DllCall( "MultiByteToWideChar"
				, "UInt", CodePage, "UInt", 0
				, pty, &in_POST_out_DATA, "UInt", Content_Length := size
				, pty, 0, "UInt", 0 )
			VarSetCapacity( buffer, size + 1 << 1, 0 )
			DllCall( "MultiByteToWideChar"
				, "UInt", CodePage, "UInt", 0
				, pty, &in_POST_out_DATA, "UInt", Content_Length
				, pty, &buffer, "UInt", size )
			If ( WorA = "W" )
				VarSetCapacity( buffer, -1 ), in_POST_out_DATA := buffer
			Else
			{
				size := DllCall( "WideCharToMultiByte"
					, "UInt", macp, "UInt", 0
					, pty, &buffer, "UInt", Content_Length := size
					, pty, 0, "UInt", 0
					, pty, 0, pty, 0 )
				VarSetCapacity( in_POST_out_DATA, 0 )
				VarSetCapacity( in_POST_out_DATA, size + 1, 0 )
				DllCall( "WideCharToMultiByte"
					, "UInt", macp, "UInt", 0
					, pty, &buffer, "UInt", Content_Length
					, pty, &in_POST_out_DATA, "UInt", size
					, pty, 0, pty, 0 )
			}
			VarSetCapacity( in_POST_out_DATA, -1 )
		}
		Else VarSetCapacity( in_POST_out_DATA, -1 )

	; Version (10-9-2011) and later push the cleanup here.
	; InternetCloseHandle > http://msdn.microsoft.com/en-us/library/aa384350%28v=VS.85%29.aspx
	DllCall( "WinINet\InternetCloseHandle", pty, hRequest )
	DllCall( "WinINet\InternetCloseHandle", pty, hConnection )
	DllCall( "WinINet\InternetCloseHandle", pty, hInternet )
	DllCall( "FreeLibrary", pty, hModule )
	Return Size
} ; HTTPRequest( url, byref in_POST_out_DATA="", byref inout_HEADERS="", options="" ) --------------

HTTPRequest_MD5( byref data, length=-1 ) { ; -------------------------------------------------------
; Computes the MD5 hash of a data blob of length 'length'. If 'length' is less than zero, this
; function assumes that 'data' is a null-terminated string and determines the length automatically.
; If length is the path to a file, this function returns the
; Static variables and constants r[0~63], encoded here as bytes with an offset of 64
; ( that means the real value is the byte value minus 64, e.g: r[0] = 7, so 7 + 64 = 71 = 'G' )
	Static s, k, pty, u, p:=0, r := "GLQVGLQVGLQVGLQVEINTEINTEINTEINTDKPWDKPWDKPWDKPWFJOUFJOUFJOUFJOU"
	; Initialize the block buffer S and constants p and k[0~63]
	If !( p )
	{
		VarSetCapacity( k, 256 )
		VarSetCapacity( S, 64, 0 )
		u := !!A_IsUnicode
		pty := A_PtrSize = "" ? "UInt" : "Ptr"
		Loop, 64
			NumPut( i := Floor(Abs(Sin(A_Index)) * 0x100000000 ), k, A_Index - 1 << 2, "UInt" )
	}

	If length IS NOT NUMBER
		IfExist, % length ; use file-MD5 mode.
		{
			hFile := DllCall( "CreateFile" ( u ? "W" : "A" ), "Str", length
				, "UInt", 0x80000000 ; GENERIC_READ = 0x80000000
 				, "UInt", 0, pty, 0
				, "UInt", 4 ; OPEN_ALWAYS = 4
				, "UInt", 0, pty, 0 )
			VarSetCapacity( l, 8 )
			DllCall( "GetFileSizeEx", pty, hFile, pty, &l )
			length := NumGet( l, 0, "Int64" )
		}

	; autodetect message length if it's not specified (or is not positive)
	If Round( length ) < 1
		length := StrLen( dat ) << u

	; initialize running accumulators
	ha := 0x67452301, hb := 0xEFCDAB89, hc := 0x98BADCFE, hd := 0x10325476

	; Begin rolling the message. This loop does 1 iteration for each 64 byte block such that the
	; last block has fewer than 55 bytes in it ( to leave room for the terminator and data length )
	Loop % length + 72 >> 6
	{
		If ( f := length - 64 > ( e := A_Index - 1 << 6 ) ? 64 : length > e ? length - e : 0 )
			If ( hFile )
				DllCall( "ReadFile", pty, hFile, pty, &s, "UInt", f, pty, &l, pty, 0 )
			Else DllCall( "RtlMoveMemory", pty, &s, pty, &data + e, "UInt", f ) ; copy the block
		If ( f != 64 && e <= length ) ; append the terminator to the message
			NumPut( 128, s, f, "UChar" )
		If ( f < 56 )
			Loop 8 ; if this is the real last block, insert the data length in BITS
				NumPut( ( ( length << 3 ) >> ( A_Index - 1 << 3 ) ) & 255, s, 55 + A_Index, "UChar" )

		a := ha, b := hb, c := hc, d := hd ; copy running accumulators to intermediate variables

		Loop 64 ; begin rolling the block. These operations have been condensed and obfuscated.
		{
			e := NumGet( r, ( i := A_Index - 1 ) << u, "UChar" ) & 31
			f := 0 = ( j := i >> 4 ) ? (b&c)|(~b&d) : j=1 ? (d&b)|(~d&c) : j=2 ? b^c^d : c^(~d|b)
			g := &s + (( i * ( 3817 >> j * 3 & 7 ) + ( 328 >> j * 3 & 7 ) & 15 ) << 2 )
			w := (*(g+3) << 24 | *(g+2) << 16 | *(g+1) << 8 | *g) + a + f + NumGet(k,i<<2,"UInt")
			a := d, d := c, c := b, b += w << e | (( w & 0xFFFFFFFF ) >> ( 32 - e ))

		}
		; add the intermediate variables to the running accumlators (making sure to mod by 2**32)
		ha := ha+a&0xFFFFFFFF, hb := hb+b&0xFFFFFFFF, hc := hc+c&0xFFFFFFFF, hd := hd+d&0xFFFFFFFF
		VarSetCapacity( S, 64, 0 ) ; zero the block
	}
	If ( hFile )
		DllCall( "CloseHandle", pty, hFile )
	Loop 32 ; convert the running accumulators into 32 hex digits
		g:=1&(i:=A_Index-1), e:=Chr(97+(i>>3))
		, f:=15&(h%e%>>((!g-g+i&7)<<2)), s.=Chr(48+f+39*(9<f))
	s .= "0000"
	Loop 6
		Loop, % 4+0*(g := Abs("0x" SubStr( s,A_Index*6-5,6)))
			i:=(g>>6*(4-A_Index))&63, s.=i=63 ? "/" : i=62 ? "+" : Chr(i<26 ? i+65 : i<52 ? i+71 : i-4)
	Return SubStr( s, 37, 22 ) "==" ; return the base 64 encoded MD5 hash.
} ; HTTPRequest_MD5( byref data, length=-1 ) -------------------------------------------------------

HTTPRequest_Base64Encode( byref data, length ) { ; -------------------------------------------------
; Returns the byte stream encoded using base64. If 'length' is the path to a file (instead of a
; number), this function returns the file's contents in base64 encoding.
	Static u, pty, b64 := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	If !( u )
		u := !!A_IsUnicode, pty := A_PtrSize = "" ? "UInt" : "Ptr"
	oel := ErrorLevel, b := &data
	If length IS NOT NUMBER
		IfExist, % length ; use file base64 encode mode
		{
			hFile := DllCall( "CreateFile" ( u ? "W" : "A" ), "Str", length
				, "UInt", 0x80000000 ; GENERIC_READ = 0x80000000
 				, "UInt", 0, pty, 0
				, "UInt", 4 ; OPEN_ALWAYS = 4
				, "UInt", 0, pty, 0 )
			VarSetCapacity( l, 8 )
			DllCall( "GetFileSizeEx", pty, hFile, pty, &l )
			length := NumGet( l, 0, "Int64" )
			VarSetCapacity( buffer, 3072, 0 )
		}
	VarSetCapacity( output, ( 16 + length * 4 ) / 3 << u, 0 )
	Loop, % length // 3
	{
		If ( !( A_Index - 1 & 1023 ) && hFile )
			DllCall( "ReadFile", pty, hFile, pty, b := &buffer, "UInt", A_Index * 3 < length ? 3072 : length + 3072 - A_Index * 3, pty, &l, pty, 0 )
		i := ( *( b ) << 16 ) | ( *( b + 1 ) << 8 ) | ( *( b + 2 ) )
		StringMid, ch1, b64, 1 + ( i >> 18 & 63 ), 1
		StringMid, ch2, b64, 1 + ( i >> 12 & 63 ), 1
		StringMid, ch3, b64, 1 + ( i >> 6 & 63 ), 1
		StringMid, ch4, b64, 1 + ( i & 63 ), 1
		output .= ch1 ch2 ch3 ch4, b += 3
	}
	If Mod( length, 3 )
	{
		If ( b = 3069 && hFile )
			DllCall( "ReadFile", pty, hFile, pty, b := &buffer, "UInt", Mod( length, 3 ), pty, &l, pty, 0 )
		i := ( *( b ) << 16 ) | ( Mod( length, 3 ) = 2 ? *( b + 1 ) << 8 : 0 )
		StringMid, ch1, b64, 1 + ( i >> 18 & 63 ), 1
		StringMid, ch2, b64, 1 + ( i >> 12 & 63 ), 1
		StringMid, ch3, b64, 1 + ( i >> 6 & 63 ), 1
		output .= ch1 ch2 ( Mod( length, 3 ) = 2 ? ch3 : "=" ) "="
	}
	If ( hFile )
		DllCall( "CloseHandle", pty, hFile )
	return output, ErrorLevel := oel
} ; HTTPRequest_Base64Encode( byref data, length ) -------------------------------------------------
