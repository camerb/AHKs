#include FcnLib.ahk
#include thirdParty/Anchor.ahk

/*
Name:     Find Me
Version:  1.6 (Wed July 06, 2011)
Author:     tidbit
Description: Find all matching text/phrases inside of files of a sepecified directory.

right-click: context Menu
esc: stop searching and replacing
ctrl+w: exit the program

add a * (asterisks) as the first letter in the File text field to recurse into sub folders.
   NOTE: Use with caution. it may take much longer.
*/

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
SetBatchLines, -1

Menu, copymenu, Add, Copy Text, copymenu
Menu, copymenu, Add, Select All, selmenu
selall:=0

gui, +Default +Resize +minsize

Gui, Add, Edit, x6 y10 w190 h20 vseldir, %A_desktop%
Gui, Add, Button, xp+192 y10 w58 h20 vseldirbtn gbrowse, Browse

Gui, Add, Radio, x6 y+2   w80  h20 vextmode +Checked cblue, Extensions:
Gui, Add, Radio, x6 y+2   w80  h20 cred, Ignore:
Gui, Add, Edit, x+2 yp-22 w168 h20 vexts  gext, txt`,ahk`,htm`,html
Gui, Add, Edit, xp y+2    w168 h20 vXexts gext, bmp`,gif`,jpg`,png`,svg`,tif`,mid`,mp3`,wav`,wma`,avi`,flv`,mov`,mp4`,mpg`,swf`,vob`,wmv`,app`,exe`,msi`,pif`,vb`,wsf

Gui, Add, Text, x6 yp+22 w60 h20 , Find:
Gui, Add, Edit, xp+62 yp w108 h20 vword, Regex is Enabled. Case Insensitive
Gui, Add, Button, xp+110 yp w20 h20 vwordhelp gregexhelp,?
Gui, Add, Button, xp+22 yp w58 h20 vwordsearch gsearch +Default, Search

Gui, add, Checkbox, x6 yp+22 gusereplace vusereplace, Replace?
Gui, Add, Edit, xp+72 yp w120 h20 vreplace +Disabled, Regex is Enabled. Case Insensitive.
Gui, Add, Button, xp+122 yp w58 h20 vreplacebtn greplace, Replace

Gui, Add, ListView, x6 yp+22 w250 h210 vlist hwndhListView glistview Count5000 +Checked, File|Line|Offset|Sample|Path

LV_ModifyCol(1, "80 Left")
LV_ModifyCol(2, "40 Integer Center")
LV_ModifyCol(3, "40 Integer Center")
LV_ModifyCol(4, "250 Left")
LV_ModifyCol(5, "80 Left")

Gui, Add, StatusBar,,
Gui, Show, AutoSize, Find Me`, By: tidbit
SB_SetText("Awaiting Action.", 1, 0)
Gosub, guisize
Return

Guisize:
	SB_SetParts((A_GuiWidth/3)+30, A_GuiWidth/3, A_GuiWidth/3)
	SB_SetText("Press Escape to abort a search.", 2, 0)
	SB_SetText("Right-click for context menu..", 3, 0)

	Anchor("seldir", "w")
	Anchor("seldirbtn", "x")

	Anchor("exts", "w")
	Anchor("Xexts", "w")

	Anchor("word", "w")
	Anchor("wordhelp", "x")
	Anchor("wordsearch", "x")

	Anchor("replace", "w")
	Anchor("replacebtn", "x")

	Anchor("list", "wh")
Return




usereplace:
	gui, Submit, NoHide
	If (usereplace==1)
		guiControl, Enable, replace
	Else
		guiControl, Disable, replace
Return

replace:
	gui, Submit, NoHide
	If (usereplace==0)
		Return

	SB_SetText("Replacing... ", 1, 0)

	Loop % LV_GetCount()
	{

		If (getkeystate("esc","p"))
			Break

		SendMessage, 4140, A_index - 1, 0xF000, SysListView321  ; 4140 is LVM_GETITEMSTATE.  0xF000 is LVIS_STATEIMAGEMASK.
		isChecked := (ErrorLevel >> 12) - 1
		; isChecked := LV_GetNext(iteration, "Checked")

		If (isChecked==0)
			Continue

		LV_GetText(line, A_index, 2)
		LV_GetText(file, A_index, 5)
		LV_Modify(A_Index, "-Check")

		SB_SetText("Replacing in: " file, 1, 0)

		TF_RegExReplaceInLines("!" file, line, line, "i)" word, replace)
	}

	SB_SetText("Awaiting Action.", 1, 0)
Return


ext:
	gui, Submit, NoHide
	If exts Contains .,%A_Space%
	{
		StringReplace, exts, exts, .,, All
		StringReplace, exts, exts, %A_Space%,, All
		GuiControl, text, exts, %exts%
	}
Return


browse:
	FileSelectFolder, seldir, *%seldir%, 3, Select a folder.
	If (RegExMatch(seldir, "^\s*$"))
		Return
	Else
		GuiControl, , seldir, %seldir%
Return

listview:
	If (A_GuiEvent=="DoubleClick")
	{
		LV_GetText(Filetorun, A_EventInfo,5)
		If (filetorun=="File")
			Return
		run, %filetorun%
	}
	If (A_GuiEvent = "ColClick")
		LV_SortArrow(hListView, A_EventInfo)
Return


search:
	gui, Submit, NoHide
	LV_ModifyCol(4, "AutoHdr", "Sample: (0)")

	If (RegExMatch(seldir, "^\s*$"))
		Return


	if (SubStr(seldir, 1, 1)=="*")
	{
		recurseMode:=1
		seldir:=SubStr(seldir, 2)
	}
	Else
		recurseMode:=0

	LV_Delete()
	selall:=0
	flist:=""
	max:=0
	Loop,%seldir%\*.*, 0, %recurseMode%
	{
	ToolTip %extmode%
		if (extmode==1)
		{
			If A_LoopFileExt in %exts%
			{
				max+=1
				flist.=A_LoopFileFullPath "`n"
				SB_SetText("Counting files: "A_Index, 1, 0)
			}
		}

		If (extmode==2)
		{
			If A_LoopFileExt in %Xexts%
				Continue
			Else
			{
				max+=1
				flist.=A_LoopFileFullPath "`n"
				SB_SetText("Counting files: "A_Index, 1, 0)
			}
		}
		Continue
	}
	sort, flist, R

	Loop, parse, flist, `n, `r
	{
		If (getkeystate("esc","p"))
			Break

		filepath:=A_LoopField
		SplitPath, filepath, fileName
		SB_SetText("file: "A_Index "/" max " -- " fileName, 1, 0)

		FileRead, filetext, %filepath%
		filetext:=unHTM(filetext)
		If (!RegExMatch(filetext, "i`n)" word))
			Continue

		loop, parse, filetext, `n, `r
		{
				If (getkeystate("esc","p"))
					Break

			If (pos:=RegExMatch(A_LoopField, "i`n)" word))
			{
				If (pos==-1)
					pos=NULL
				LV_Add("", fileName, A_index, pos, ConvertEntities(unHTM(A_LoopField)), filepath)
				LV_ModifyCol(4, "AutoHdr", "Sample: (" LV_GetCount() ")")
			}
			LV_ModifyCol(4, "AutoHdr", "Sample: (" LV_GetCount() ")")
		}
	}

	LV_ModifyCol(1, "Auto")
	LV_ModifyCol(4, "Auto")
	SB_SetText("Awaiting Action.", 1, 0)
Return


regexhelp:
	Gui, 11: Destroy
	Gui, 11: Default
	help=
	(
.	Matches any character.	cat. matches catT and cat2 but not catty
[]	Bracket expression. Matches one of any characters enclosed.	gr[ae]y matches gray or grey
[^]	Negates a bracket expression. Matches one of any characters EXCEPT those enclosed.	1[^02] matches 13 but not 10 or 12
[-]	Range. Matches any characters within the range.	[1-9] matches any single digit EXCEPT 0
?	Preceeding item must match one or zero times.	colou?r matches color or colour but not colouur
()	Parentheses. Creates a substring or item that metacharacters can be applied to	a(bee)?t matches at or abeet but not abet
{n}	Bound. Specifies exact number of times for the preceeding item to match.	[0-9]{3} matches any three digits
{n,}	Bound. Specifies minimum number of times for the preceeding item to match.	[0-9]{3,} matches any three or more digits
{n,m}	Bound. Specifies minimum and maximum number of times for the preceeding item to match.	[0-9]{3,5} matches any three, four, or five digits
|	Alternation. One of the alternatives has to match.	July (first|1st|1) will match July 1st but not July 2
[:alnum:]	alphanumeric character	[[:alnum:]]{3} matches any three letters or numbers, like 7Ds
[:alpha:]	alphabetic character, any case	[[:alpha:]]{5} matches five alphabetic characters, any case, like aBcDe
[:blank:]	space and tab	[[:blank:]]{3,5} matches any three, four, or five spaces and tabs
[:digit:]	digits	[[:digit:]]{3,5} matches any three, four, or five digits, like 3, 05, 489
[:lower:]	lowercase alphabetics	[[:lower:]] matches a but not A
[:punct:]	punctuation characters	[[:punct:]] matches ! or . or , but not a or 3
[:space:]	all whitespace characters, including newline and carriage return	[[:space:]] matches any space, tab, newline, or carriage return
[:upper:]	uppercase alphabetics	[[:upper:]] matches A but not a
//	Default delimiters for pattern	/colou?r/ matches color or colour
i	Append to pattern to specify a case insensitive match	/colou?r/i matches COLOR or Colour
\b	A word boundary, the spot between word (\w) and non-word (\W) characters	/\bfred\b/i matches Fred but not Alfred or Frederick
\B	A non-word boundary	/fred\B/i matches Frederick but not Fred
\d	A single digit character	/a\db/i matches a2b but not acb
\D	A single non-digit character	/a\Db/i matches aCb but not a2b
\n	The newline character. (ASCII 10)	/\n/ matches a newline
\r	The carriage return character. (ASCII 13)	/\r/ matches a carriage return
\s	A single whitespace character	/a\sb/ matches a b but not ab
\S	A single non-whitespace character	/a\Sb/ matches a2b but not a b
\t	The tab character. (ASCII 9)	/\t/ matches a tab.
\w	A single word character - alphanumeric and underscore	/\w/ matches 1 or _ but not ?
\W	A single non-word character	/a\Wb/i matches a!b but not a2b
	)

	Gui, 11: add, text, y6 x6, Basic Regex Help
	Gui, 11:add, ListView, y26 x6 w450 r25 vlist, Key|Description|Example


	Loop, Parse, help, `n
	{
		StringSplit, col, A_LoopField, %A_Tab%
		LV_Add( "", col1, col2, col3)
	}

	LV_ModifyCol(1, "Auto")
	LV_ModifyCol(2, 200)
	LV_ModifyCol(3, "Auto")

	gui, 11: show, x45 , Regex Help
Return



GuiContextMenu:
	If (A_GuiControl!="list")
		return
	RCrow:=A_EventInfo ; Right-Clicked row
	Menu, copymenu, Show, %A_GuiX%, %A_GuiY%
return

copymenu:
	LV_GetText(copytext, RCrow, 4)
	Clipboard:=copytext
Return

selmenu:
	selall:=!selall
	if (selall==1)
		LV_Modify(0, "Check")
	else
		LV_Modify(0, "-Check")
Return




; ------ Functions ---
; --------------------




; thanks SKAN! http://www.autohotkey.com/forum/viewtopic.php?t=51342&highlight=remove+html
UnHTM( HTM ) {   ; Remove HTML formatting / Convert to ordinary text   by SKAN 19-Nov-2009
 Static HT,C=";" ; Forum Topic: www.autohotkey.com/forum/topic51342.html  Mod: 16-Sep-2010
 IfEqual,HT,,   SetEnv,HT, % "&aacuteá&acircâ&acute´&aeligæ&agrave� &amp&aringå&atildeã&au"
 . "mlä&bdquo„&brvbar¦&bull•&ccedilç&cedil¸&cent¢&circˆ&copy©&curren¤&dagger� &dagger‡&deg"
 . "°&divide÷&eacuteé&ecircê&egraveè&ethð&eumlë&euro€&fnofƒ&frac12½&frac14¼&frac34¾&gt>&h"
 . "ellip…&iacuteí&icircî&iexcl¡&igraveì&iquest¿&iumlï&laquo«&ldquo“&lsaquo‹&lsquo‘&lt<&m"
 . "acr¯&mdash—&microµ&middot·&nbsp &ndash–&not¬&ntildeñ&oacuteó&ocircô&oeligœ&ograveò&or"
 . "dfª&ordmº&oslashø&otildeõ&oumlö&para¶&permil‰&plusmn±&pound£&quot""&raquo»&rdquo”&reg"
 . "®&rsaquo›&rsquo’&sbquo‚&scaronš&sect§&shy &sup1¹&sup2²&sup3³&szligß&thornþ&tilde˜&tim"
 . "es×&trade™&uacuteú&ucircû&ugraveù&uml¨&uumlü&yacuteý&yen¥&yumlÿ"
 $ := RegExReplace( HTM,"<[^>]+>" )               ; Remove all tags between  "<" and ">"
 Loop, Parse, $, &`;                              ; Create a list of special characters
   L := "&" A_LoopField C, R .= (!(A_Index&1)) ? ( (!InStr(R,L,1)) ? L:"" ) : ""
 StringTrimRight, R, R, 1
 Loop, Parse, R , %C%                               ; Parse Special Characters
  If F := InStr( HT, L := A_LoopField )             ; Lookup HT Data
    StringReplace, $,$, %L%%C%, % SubStr( HT,F+StrLen(L), 1 ), All
  Else If ( SubStr( L,2,1)="#" )
    StringReplace, $, $, %L%%C%, % Chr(((SubStr(L,3,1)="x") ? "0" : "" ) SubStr(L,3)), All
Return RegExReplace( $, "(^\s*|\s*$)")            ; Remove leading/trailing white spaces
}

; thanks Uberi!
ConvertEntities(HTML)
{
 static EntityList := "|quot=34|apos=39|amp=38|lt=60|gt=62|nbsp=160|iexcl=161|cent=162|pound=163|curren=164|yen=165|brvbar=166|sect=167|uml=168|copy=169|ordf=170|laquo=171|not=172|shy=173|reg=174|macr=175|deg=176|plusmn=177|sup2=178|sup3=179|acute=180|micro=181|para=182|middot=183|cedil=184|sup1=185|ordm=186|raquo=187|frac14=188|frac12=189|frac34=190|iquest=191|Agrave=192|Aacute=193|Acirc=194|Atilde=195|Auml=196|Aring=197|AElig=198|Ccedil=199|Egrave=200|Eacute=201|Ecirc=202|Euml=203|Igrave=204|Iacute=205|Icirc=206|Iuml=207|ETH=208|Ntilde=209|Ograve=210|Oacute=211|Ocirc=212|Otilde=213|Ouml=214|times=215|Oslash=216|Ugrave=217|Uacute=218|Ucirc=219|Uuml=220|Yacute=221|THORN=222|szlig=223|agrave=224|aacute=225|acirc=226|atilde=227|auml=228|aring=229|aelig=230|ccedil=231|egrave=232|eacute=233|ecirc=234|euml=235|igrave=236|iacute=237|icirc=238|iuml=239|eth=240|ntilde=241|ograve=242|oacute=243|ocirc=244|otilde=245|ouml=246|divide=247|oslash=248|ugrave=249|uacute=250|ucirc=251|uuml=252|yacute=253|thorn=254|yuml=255|OElig=338|oelig=339|Scaron=352|scaron=353|Yuml=376|circ=710|tilde=732|ensp=8194|emsp=8195|thinsp=8201|zwnj=8204|zwj=8205|lrm=8206|rlm=8207|ndash=8211|mdash=8212|lsquo=8216|rsquo=8217|sbquo=8218|ldquo=8220|rdquo=8221|bdquo=8222|dagger=8224|Dagger=8225|hellip=8230|permil=8240|lsaquo=8249|rsaquo=8250|euro=8364|trade=8482|"
 FoundPos = 1
 While, (FoundPos := InStr(HTML,"&",False,FoundPos))
 {
  FoundPos ++, Entity := SubStr(HTML,FoundPos,InStr(HTML,"`;",False,FoundPos) - FoundPos), (SubStr(Entity,1,1) = "#") ? (EntityCode := SubStr(Entity,2)) : (Temp1 := InStr(EntityList,"|" . Entity . "=") + StrLen(Entity) + 2, EntityCode := SubStr(EntityList,Temp1,InStr(EntityList,"|",False,Temp1) - Temp1))
  StringReplace, HTML, HTML, &%Entity%`;, % Chr(EntityCode), All
 }
 Return, HTML
}

; thanks Solar! http://www.autohotkey.com/forum/viewtopic.php?t=69642
; h = ListView handle
; c = 1 based index of the column
; d = Optional direction to set the arrow. "asc" or "up". "desc" or "down".
LV_SortArrow(h, c, d="") {
   static ptr, ptrSize, lvColumn, LVM_GETCOLUMN, LVM_SETCOLUMN
   if (!ptr) {
      ptr := A_PtrSize ? "ptr" : "uint", PtrSize := A_PtrSize ? A_PtrSize : 4
      ,LVM_GETCOLUMN := A_IsUnicode ? 4191 : 4121, LVM_SETCOLUMN := A_IsUnicode ? 4192 : 4122
      ,VarSetCapacity(lvColumn, PtrSize + 4), NumPut(1, lvColumn, 0, "uint")
   }
   c -= 1, DllCall("SendMessage", ptr, h, "uint", LVM_GETCOLUMN, "uint", c, ptr, &lvColumn)
   if ((fmt := NumGet(lvColumn, 4, "int")) & 1024) {
      if (d && d = "asc" || d = "up")
         Return
      NumPut(fmt & ~1024 | 512, lvColumn, 4, "int")
   } else if (fmt & 512) {
      if (d && d = "desc" || d = "down")
         Return
      NumPut(fmt & ~512 | 1024, lvColumn, 4, "int")
   } else {
      Loop % DllCall("SendMessage", ptr, DllCall("SendMessage", ptr, h, "uint", 4127), "uint", 4608) {
         if ((i := A_Index - 1) = c)
            Continue
         DllCall("SendMessage", ptr, h, "uint", LVM_GETCOLUMN, "uint", i, ptr, &lvColumn)
         ,NumPut(NumGet(lvColumn, 4, "int") & ~1536, lvColumn, 4, "int")
         ,DllCall("SendMessage", ptr, h, "uint", LVM_SETCOLUMN, "uint", i, ptr, &lvColumn)
      }
      NumPut(fmt | ((d && d = "desc" || d = "down") ? 512 : 1024), lvColumn, 4, "int")
   }
   return DllCall("SendMessage", ptr, h, "uint", LVM_SETCOLUMN, "uint", c, ptr, &lvColumn)
}






; ------ TF() Stuff ---
; ---------------------
; Thanks hugov! http://www.autohotkey.com/forum/viewtopic.php?t=46195



TF_RegExReplaceInLines(Text, StartLine = 1, EndLine = 0, NeedleRegEx = "", Replacement = "")
	{
	 TF_GetData(OW, Text, FileName)
	 If (RegExMatch(Text, NeedleRegEx) < 1)
	 	Return ; NeedleRegEx not in file or error, do nothing
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
         	 If A_Index in %TF_MatchList%
			{
			 LoopField := RegExReplace(A_LoopField, NeedleRegEx, Replacement)
			 OutPut .= LoopField "`n"
			}
		 Else
			OutPut .= A_LoopField "`n"
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}


TF_Count(String, Char)
	{
	StringReplace, String, String, %Char%,, UseErrorLevel
	Return ErrorLevel
	}


TF_GetData(byref OW, byref Text, byref FileName) ; HugoV, helper function to determine if VAR/TEXT or FILE is passed to TF
	{
	OW=0 ; default setting: asume it is a file and create file_copy
    If (SubStr(Text,1,1)="!") ; first we check for "overwrite"
		{
		 Text:=SubStr(Text,2)
		 OW=1 ; overwrite file (if it is a file)
		}
    IfNotExist, %Text% ; now we can check if the file exists, it doesn't so it is a var
		 {
		  If (OW=1) ; the variable started with a ! so we need to put it back because it is variable/text not a file
			Text:= "!" . Text
		  OW=2 ; no file, so it is a var or Text passed on directly to TF
		 }

    If (OW = 0) or (OW = 1)
		{
	 	 Text := (SubStr(Text,1,1)="!") ? (SubStr(Text,2)) : Text
		 FileName=%Text% ; Store FileName
		 FileRead, Text, %Text% ; Read file and return as Text
		}
	Return
	}


	TF_ReturnOutPut(OW, Text, FileName, TrimTrailing = 1, CreateNewFile = 0) { ; HugoV
	If (OW = 0) ; input was file, file_copy will be created, if it already exist file_copy will be overwritten
		{
		 IfNotExist, % FileName ; check if file Exist, if not return otherwise it would create an empty file. Thanks for the idea Murp|e
		 	{
		 	 If (CreateNewFile = 1) ; CreateNewFile used for TF_SplitFileBy* and others
				{
				 OW = 1
		 		 Goto CreateNewFile
				}
			 Else
				Return
			}
		 If (TrimTrailing = 1)
			 StringTrimRight, Text, Text, 1 ; remove trailing `n
		SplitPath, FileName,, Dir, Ext, Name
		 If (Dir = "") ; if Dir is empty Text & script are in same directory
			Dir := A_ScriptDir
		 IfExist, % Dir "\backup" ; if there is a backup dir, copy original file there
			FileCopy, % Dir "\" Name "_copy." Ext, % Dir "\backup\" Name "_copy.bak", 1
		 FileDelete, % Dir "\" Name "_copy." Ext
		 FileAppend, %Text%, % Dir "\" Name "_copy." Ext
		 Return Errorlevel ? False : True
		}
	 CreateNewFile:
	 If (OW = 1) ; input was file, will be overwritten by output
		{
		 IfNotExist, % FileName ; check if file Exist, if not return otherwise it would create an empty file. Thanks for the idea Murp|e
		 	{
		 	If (CreateNewFile = 0) ; CreateNewFile used for TF_SplitFileBy* and others
		 		Return
			}
		 If (TrimTrailing = 1)
			 StringTrimRight, Text, Text, 1 ; remove trailing `n
		 SplitPath, FileName,, Dir, Ext, Name
		 If (Dir = "") ; if Dir is empty Text & script are in same directory
			Dir := A_ScriptDir
		 IfExist, % Dir "\backup" ; if there is a backup dir, copy original file there
			FileCopy, % Dir "\" Name "." Ext, % Dir "\backup\" Name ".bak", 1
		 FileDelete, % Dir "\" Name "." Ext
		 FileAppend, %Text%, % Dir "\" Name "." Ext
		 Return Errorlevel ? False : True
		}
	If (OW = 2) ; input was var, return variable
		{
		 If (TrimTrailing = 1)
			StringTrimRight, Text, Text, 1 ; remove trailing `n
		 Return Text
		}
	}


_MakeMatchList(Text, Start = 1, End = 0)
	{
	ErrorList=
	 (join|
	 Error 01: Invalid StartLine parameter (non numerical character)
	 Error 02: Invalid EndLine parameter (non numerical character)
	 Error 03: Invalid StartLine parameter (only one + allowed)
	 )
	 StringSplit, ErrorMessage, ErrorList, |
	 Error = 0

 	 TF_MatchList= ; just to be sure
	 If (Start = 0 or Start = "")
		Start = 1

	 ; some basic error checking

	 ; error: only digits - and + allowed
	 If (RegExReplace(Start, "[ 0-9+\-\,]", "") <> "")
		 Error = 1

	 If (RegExReplace(End, "[0-9 ]", "") <> "")
		 Error = 2

	 ; error: only one + allowed
	 If (TF_Count(Start,"+") > 1)
		 Error = 3

	 If (Error > 0 )
		{
		 MsgBox, 48, TF Lib Error, % ErrorMessage%Error%
		 ExitApp
		}

 	 ; Option #1
	 ; StartLine has + character indicating startline + incremental processing.
	 ; EndLine will be used
	 ; Make TF_MatchList

	 IfInString, Start, `+
		{
		 If (End = 0 or End = "") ; determine number of lines
			End:= TF_Count(Text, "`n") + 1
		 StringSplit, Section, Start, `, ; we need to create a new "TF_MatchList" so we split by ,
		 Loop, %Section0%
			{
			 StringSplit, SectionLines, Section%A_Index%, `+
			 LoopSection:=End + 1 - SectionLines1
			 Counter=0
	         	 TF_MatchList .= SectionLines1 ","
			 Loop, %LoopSection%
				{
				 If (A_Index >= End) ;
					Break
				 If (Counter = (SectionLines2-1)) ; counter is smaller than the incremental value so skip
					{
					 TF_MatchList .= (SectionLines1 + A_Index) ","
					 Counter=0
					}
				 Else
					Counter++
				}
			}
		 StringTrimRight, TF_MatchList, TF_MatchList, 1 ; remove trailing ,
		 Return TF_MatchList
		}

	 ; Option #2
	 ; StartLine has - character indicating from-to, COULD be multiple sections.
	 ; EndLine will be ignored
	 ; Make TF_MatchList

	 IfInString, Start, `-
		{
		 StringSplit, Section, Start, `, ; we need to create a new "TF_MatchList" so we split by ,
		 Loop, %Section0%
			{
			 StringSplit, SectionLines, Section%A_Index%, `-
			 LoopSection:=SectionLines2 + 1 - SectionLines1
			 Loop, %LoopSection%
				{
				 TF_MatchList .= (SectionLines1 - 1 + A_Index) ","
				}
			}
		 StringTrimRight, TF_MatchList, TF_MatchList, 1 ; remove trailing ,
		 Return TF_MatchList
		}

	 ; Option #3
	 ; StartLine has comma indicating multiple lines.
	 ; EndLine will be ignored
	 IfInString, Start, `,
		{
		 TF_MatchList:=Start
		 Return TF_MatchList
		}

	 ; Option #4
	 ; parameters passed on as StartLine, EndLine.
	 ; Make TF_MatchList from StartLine to EndLine

	 If (End = 0 or End = "") ; determine number of lines
			End:= TF_Count(Text, "`n") + 1
	 LoopTimes:=End-Start
	 Loop, %LoopTimes%
		{
		 TF_MatchList .= (Start - 1 + A_Index) ","
		}
	 TF_MatchList .= End ","
	 StringTrimRight, TF_MatchList, TF_MatchList, 1 ; remove trailing ,
	 Return TF_MatchList
	}





; ------ Hotkeys ---
; ------------------

#IfWinActive, Find Me`, By: tidbit
^w::
GuiClose:
ExitApp
#IfWinActive
