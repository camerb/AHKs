#include FcnLib.ahk

/*
Author:         RaptorX	<graptorx@gmail.com>
Script Name:    PCtools
Script Version: 1.0

Creation Date: Jun 30 , 2010 | Modification Date: Jun 30 , 2010

[GUI Number Index]

GUI 99 - Splash
GUI 01 - Main [Hotkey Maker]
*/
;#Include C:\Documents and Settings\RaptorX\My Documents\AutoHotkey ; Current Library
#Include thirdParty\xpath.ahk

#NoEnv
#SingleInstance Force
;--
SendMode Input
SetWorkingDir %A_ScriptDir%

;---------[Basic Info]----------
s_name      := "PCtools"            ; Script Name
s_version   := 1.0                  ; Script Version
s_author    := "RaptorX"            ; Script Author
s_email     := "graptorx@gmail.com" ; Author's contact email

;------[General Variables]------
sec         :=  1000        ; 1 second
min         :=  sec * 60    ; 1 minute
hour        :=  min * 60    ; 1 hour
mid_scrw    :=  a_screenwidth / 2
mid_scrh    :=  a_screenheight / 2
;--
s_ini       := ; Optional ini file
s_xml       := ; Optional xml file

;-----[User Configuration]------
clipboard   :=
exc := "F13|F14|F15|F16|F17|F18|F19|F20|F21|F22|F23|F24|AppsKey|LWin|RWin|"
    . "LControl|RControl|LShift|RShift|LAlt|RAlt|Control|Alt|Shift|PrintScreen|CtrlBreak|Pause|Break|Help|Sleep|"
    . "ScrollLock|CapsLock|NumLock"
keylist := "None||" . keylist := klist("all",0,1, exc)
reg_addr    := "SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
RegRead, reg_exist, HKCU, %reg_addr%, %s_name%

; ListView Styles
NOSCROLL := 0x2000
;--

;-----------[Main]--------------
;if a_iscompiled
;{
    ;if !reg_exist
        ;RegWrite,  REG_SZ, HKCU, %reg_addr%, %s_name%, %a_scriptfullpath%
;}
;else
;{
    ;ifnotexist %a_startup%/%a_scriptname%.lnk
        ;FileCreateShortcut, %a_scriptfullpath%, %a_startup%\%a_scriptname%.lnk, %a_scriptdir%
;}

; Splash GUI
Gui, 99: -Caption +Border +AlwaysOnTop
Gui, 99: font, s15 w700, Verdana
Gui, 99: add, text, w400 center, Welcome to %s_name% %s_version%
Gui, 99: font, s10 w400, Verdana
Gui, 99: add, text, w420 x0 0x10
Gui, 99: add, text, w400 xp+5 yp+10 center, %s_name% has been activated

; Add New Hotkey GUI
Gui, 98: +AlwaysOnTop
Gui, 98: add, groupbox, w410 h80, Select Program
Gui, 98: add, edit, w280 xp+10 yp+20 vpPath, %a_programfiles%
Gui, 98: add, button, w100 h25 x+10, Browse...
Gui, 98: add, radio, x100 y+10 Checked vsel_type, Launch a File
Gui, 98: add, radio, x+20, Launch a Folder
Gui, 98: add, groupbox, x10 y+20 w410 h50, Select Hotkey
Gui, 98: add, dropdownlist, w170 xp+10 yp+20 vhk_ddl, %keylist%
Gui, 98: add, checkbox, x+10 yp+5 vmod_ctrl, Ctrl
Gui, 98: add, checkbox, x+20 vmod_alt, Alt
Gui, 98: add, checkbox, x+20 vmod_shift, Shift
Gui, 98: add, checkbox, x+20 vmod_win, Win
Gui, 98: add, text, w440 x0 y+20 0x10
Gui, 98: add, button, w100 h25 x200 yp+10, Save
Gui, 98: add, button, w100 h25 x+20, Cancel


; Main Gui [Hotkey Maker]
Gui, -Maximizebox
Gui, add, Tab2, w600 h300 x1 y1,Hotkeys|Hotstrings|Configure
Gui, Tab, Hotkeys
Gui, add, listview, w580 r12 %NOSCROLL% Grid vhk_list, Program Name|Current Hotkey|Program Location
Gui, add, text, w610 x0 y+10 0x10
Gui, add, button, w100 h25 x370 yp+10, Add New
Gui, add, button, w100 h25 x+20, Close
Gui, add, statusbar

Gui, 99: Show, w400
Gui, 98: Show, Hide
Gui, Show, Hide

Gosub, ReadXML
Sleep, 3 * sec
Gui, 99: Destroy

return
;----------[Labels]-------------
ResetGui:
 mod_list := "mod_ctrl|mod_alt|mod_shift|mod_win"
 GuiControl, 98:, pPath, %a_programfiles%
 GuiControl, 98:, sel_type, 1
 GuiControl, 98:, hk_ddl, |%keylist%
 Loop, parse, mod_list, |
    GuiControl, 98:, %a_loopfield%, 0
return

lvCheck:
 hkNotExist := True                                         ; We start assuming that the program is not listed

 Loop % LV_GetCount()
 {
    LV_GetText(pnExist, a_index, 1), LV_GetText(hkExist,a_index, 2), LV_GetText(pthExist,a_index, 3)
    if (pnExist = pName || hkExist = long_hk || pthExist = pDir)
        LV_Delete(a_index)                                  ; Delete any duplicate in the next rows
    if pnExist = %pName%                                    ; If the name of the program exist in that row
    {
        hkNotExist := False                             ; Prevents the adding a duplicate
        if hkExist <> %long_hk%                              ; Program name and hotkey are the same
            LV_Modify(a_index, "", pName, long_hk, pDir)    ; Updates current entry
    }
    else if hkExist = %long_hk%                             ; Name doesnt exist but hotkey does
    {
        hkNotExist := False
        if pnExist <> %pName%                                ; Same as above, This is for being double sure.
            LV_Modify(a_index, "", pName, long_hk, pDir)    ; Updates current entry
    }
    else if pthExist = %pDir%
    {
        hkNotExist := False
        if (pnExist <> pName || hkExist <> long_hk)           ; If name, hotkey and path are the same
            LV_Modify(a_index, "", pName, long_hk, pDir)    ; Updates current entry
    }
 }
return

ButtonAddNew:
 Gui, +Disabled
 Gui, 98: Show, w430,Add New hotkey
return

98ButtonBrowse...:
 Gui, 98: +OwnDialogs
 Gui, Submit, NoHide

 if sel_type = 1
 {
    FileSelectFile, tmp_path, 1, %a_programfiles%, Please select a program, Executable (*.exe)
    SplitPath, tmp_path,,pDir,, pName
    if pDir && pName
        GuiControl, 98:, pPath, %pDir%\%pName%.exe
 }
 else if sel_type = 2
 {
    FileSelectFolder, pDir, %a_programfiles%, 1, Please select the folder`nthat will be launched by your hotkey
    StringSplit, fName,pDir,\
    msgbox % fName0
    pause
    if pDir
        GuiControl, 98:, pPath, %pDir%
 }
 else
 {
    Gosub, ResetGui
 }
return

98ButtonSave:
 Gui, 1: -Disabled
 Gui, Submit ; Gui 1 must be disabled before sending the Gui submit, or it will hide both windows.
 Gui, 1: Default
 Gosub, ResetGui
 c_num := LV_GetCount("Col")
 if mod_ctrl
    mod_ctrl := "^"
 else
    mod_ctrl :=
 if mod_alt
    mod_alt := "!"
 else
    mod_alt :=
 if mod_shift
    mod_shift := "+"
 else
    mod_shift :=
 if mod_win
    mod_win := "#"
 else
    mod_win :=
 fHotkey := mod_ctrl . mod_alt . mod_shift . mod_win . hk_ddl
 long_hk := RegexReplace(fHotkey, "\+", "Shift + ")
 long_hk := RegexReplace(long_hk, "\^", "Ctrl + ")
 long_hk := RegexReplace(long_hk, "!", "Alt + ")
 long_hk := RegexReplace(long_hk, "#", "Win + ")
 Gosub, lvCheck         ; Check if  hotkey is already pressent
 if hkNotExist          ; This variable comes from the check above
    LV_Add("", pName, long_hk, pDir)
 Loop, % c_num
    LV_Modifycol(a_index, "autohdr")
 Gosub, SaveXML
 Gosub, ReadXML
return

SaveXML:
return

ReadXML:
 Gui, 1: Default
 r_num := LV_GetCount()
 SB_SetParts(250)
 SB_SetText(r_num . " Hotkeys active", 1)
return

GuiClose:
ButtonClose:
GuiEscape:
98GuiEscape:
98ButtonCancel:
 gui_toggle :=
 Gui, 1: -Disabled
 Gui, Hide
 Gosub, ResetGui
return
;--------[Functions]------------
/*
Function        : klist([ascii, mouse, keyboard, exclude, include])
Author          : RaptorX
Version         : 0.1
Updated         : July 01 , 2010

Description:
--------------
All arguments are optional.

This function returns a list of keys from the keyboard or mouse ready to be parsed.
Useful to create a bunch of hotkeys, display a list of keys on a combo box or any other general use in which you need a list of keys to
operate on and you dont want to manually type them.

When all parameters are omitted it returns a list of the common ascii characters (a-z, A-Z, 0-9, and punctuation
signs) separated by "|" to be parsed later on.

Note that the function is case sensitive, I made it this way because my main intention was to show a list of hotkeys from a combo-box and wanted to use all uppercase letters instead of their lowercase version.

Quick reference:
---------------
keylist := klist() --> this returns the basic ascii characters that dont require modifier keys such as Ctrl or Alt
keylist := klist("lower") --> a-z
keylist := klist("upper") --> A-Z
keylist := klist("alphanum") --> a-z and 0-9
keylist := klist("num") --> 0-9
keylist := klist("punct") --> this returns punctuation signs that dont require modifier keys
keylist := klist(0,1) --> returns mouse keys such as LMouse... if you want to add XButton1 or WheelLeft use the
include argument
keylist := klist(0,0,1) --> this returns the list of keyboard buttons such as Enter and Escape
keylist := klist(1,0,0, exc := "a|b|c|d|e|f|g") --> return ascii keys without a-g (exclude)
keylist := klist(0,1,0, exc := "", inc := "Enter|Backspace|Escape") --> mouse keys + others (Include)
keylist := klist(0,1,1) --> this returns all mouse and keyboard buttons
keylist := klist(0,1,1,exclude:="Escape|Backspace|Delete|Insert") --> same as above but removes those keys.
keylist := klist(1,0,1,exclude:="", var) --> use all the keyboard and ascii keys and include a list of keys
contained in the variable %var%.

Arguments:
--------------
[ascii] all/none/lower/upper/num/alphanum/punct/true/false/1/0
Appends a list of the common ascii characters to the return value.

-True / 1 / all- Appends all ascii characters that can be pressed without modifiers, ex. "[" but not "{"
-Lower- Appends only lowercase alphabetic characters
-Upper- Same as above but only Uppercase.
-Num- Appends only numbers
-Alphanum- Appends Alphabetic characters as well as numbers, uses lowercase.
-Punct- Sends only punctuation signs that can be pressed without modifiers, ex. ";" but not ":"
-False / 0 / none- do not Append ascii characters at all

[mouse] true/false/1/0
Appends a list of the COMMON mouse keys to the return value, if you want other keys like WheelLeft, WheelRight ,
XButton1 or XButton2 use the "Include" argument

[keyboard] true/false/1/0
Appends a list of keys from the keyboard other than the ascii characters stated above.

[exclude] byref variable
Excludes the specified keys from the return value.
Specify a variable that contains a list separated by "|". If you dont want to exclude too many keys simply use
the := operator to assign keys right there when calling the function, ex. klist(1,1,1,exclude := "A|B|C")

IMPORTANT: Do NOT append "|" at the beginning or at the end of the list because it will cause problems with the
StringReplace used to exclude the items from the list.

[include] byref variable
Appends the specified keys to the return value.
this works the same as the exclude argument above and it is used mainly to add keys not added in my main list
like the Media Buttons or Special SCxxx keys.

Examples:
--------------
Uncomment the following scripts and run the script to see useful examples of for this function.

;***** Script 1 *****
keylist := "None|" . keylist := klist(1,0,0,ex := "", in := "Enter|Backspace|Delete")
Gui, add, groupbox, x10 y+20 w410 h50, Select Hotkey
Gui, add, dropdownlist, w170 xp+10 yp+20 vhk_ddl, %keylist%
Gui, add, checkbox, x+10 yp+5 vmod_ctrl, Ctrl
Gui, add, checkbox, x+20 vmod_alt, Alt
Gui, add, checkbox, x+20 vmod_shift, Shift
Gui, add, checkbox, x+20 vmod_win, Win
Gui, add, text, w440 x0 y+20 0x10
Gui, add, button, w100 h25 x320 yp+10, Exit
Gui, Show, w430,Add New hotkey
Return

ButtonExit:
ExitApp
;***** End *****

***** Script 2 *****

keylist := klist(1,1,1,exclude:="LButton|WheelDown|WheelUp|Escape")
loop, parse, keylist, |
    hotkey, *%a_loopfield%, blockkeys ; <--- Note the *, that is for blocking modified keys like "Alt + A" and such
return

blockkeys:
return

Esc::ExitApp ; <----- Note that this one works because we excluded the Escape Key (Alone)
!Esc::Pause ; <----- Note that this hotkey WONT work because we are blocking the Alt key

***** End *****
*/
klist(ascii = "all", mouse = false, keyboard = false, Byref exclude = "", Byref include = "")
{
    StringCaseSense, On
     ascii_list  :="44,45,46,47,48,49,50,51,52,53,54,55,56,57,59,61,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,"
     . "80,81,82,83,84,85,86,87,88,89,90,91,92,93,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,"
     . "113,114,115,116,117,118,119,120,121,122"

    mouse_list := "LButton|RButton|MButton|WheelDown|WheelUp"
    kb_list := "Space|Tab|Enter|Escape|Backspace|Delete|Insert|Home|End|PgUp|PgDn|Up|Down|Left|Right|"
    . "ScrollLock|CapsLock|NumLock|Numpad0|Numpad1|Numpad2|Numpad3|Numpad4|Numpad5|Numpad6|Numpad7|Numpad8|"
    . "Numpad9|NumpadIns|NumpadEnd|NumpadDown|NumpadPgDn|NumpadLeft|NumpadClear|NumpadRight|NumpadHome|"
    . "NumpadUp|NumpadPgUp|NumpadDot|NumpadDel|NumpadDiv|NumpadMult|NumpadAdd|NumpadSub|NumpadEnter|F1|F2|F3|F4|"
    . "F5|F6|F7|F8|F9|F10|F11|F12|F13|F14|F15|F16|F17|F18|F19|F20|F21|F22|F23|F24|AppsKey|LWin|RWin|LControl|"
    . "RControl|LShift|RShift|LAlt|RAlt|Control|Alt|Shift|PrintScreen|CtrlBreak|Pause|Break|Help|Sleep"

    if ascii
    {
        Loop, parse, ascii_list, `,
                mixed := mixed . "|" . nchar := chr(a_loopfield)

        if (ascii = "all" || ascii = 1)
        {
            loop, parse, mixed, |
                if RegExMatch(a_loopfield, "[^A-Z]")
                    keylist := keylist . "|" . a_loopfield
        }
        else if (ascii = "none" || ascii = 0)
        {
            Sleep, 1
        }
        else if ascii = lower
        {
            loop, parse, mixed, |
                if RegExMatch(a_loopfield, "[a-z]")
                    keylist := keylist . "|" . a_loopfield
        }
        else if ascii = upper
        {
            loop, parse, mixed, |
                if RegExMatch(a_loopfield, "[A-Z]")
                    keylist := keylist . "|" . a_loopfield
        }
        else if ascii = num
        {
            loop, parse, mixed, |
                if RegExMatch(a_loopfield, "[0-9]")
                    keylist := keylist . "|" . a_loopfield
        }
        else if ascii = alphanum
        {
            loop, parse, mixed, |
                if RegExMatch(a_loopfield, "[a-z0-9]")
                    keylist := keylist . "|" . a_loopfield
        }
        else if ascii = punct
        {
            loop, parse, mixed, |
                if RegExMatch(a_loopfield, "[^a-zA-Z0-9]")
                    keylist := keylist . "|" . a_loopfield
        }
    }

    if mouse
        keylist := keylist . "|" . mouse_list

    if keyboard
        keylist := keylist . "|" . kb_list

    loop, parse, exclude, |
        {
            StringReplace, keylist, keylist, %a_loopfield%|,,1
            StringReplace, keylist, keylist, %a_loopfield%,,1 ; This is to match the last keyword because it
                                                              ; doesnt contain the trailing |
        }
    if include
        keylist := keylist . "|" . include

    StringTrimLeft, keylist, keylist, 1
    StringCaseSense, off
    return keylist
}
;-----[Hotkeys/Hotstrings]------
~*!Esc::ExitApp
F3::Pause
F4::                                  ; Hide System Tray
  if tb_toggle := !tb_toggle
  {
    VarSetCapacity( APPBARDATA, 36, 0 )
	NumPut( ( ABS_ALWAYSONTOP := 0x2 )|( ABS_AUTOHIDE := 0x1 ), APPBARDATA, 32, "UInt" )
    DllCall( "Shell32.dll\SHAppBarMessage", "UInt", ( ABM_SETSTATE := 0xA ), "UInt", &APPBARDATA )
    WinHide, ahk_class Shell_TrayWnd
  }
  else
  {
    VarSetCapacity( APPBARDATA, 36, 0 )
    NumPut( ( ABS_ALWAYSONTOP := 0x2 ), APPBARDATA, 32, "UInt" )
    DllCall( "Shell32.dll\SHAppBarMessage", "UInt", ( ABM_SETSTATE := 0xA ), "UInt", &APPBARDATA )
    WinShow, ahk_class Shell_TrayWnd
  }
return                                 ; End
^F5::Send %a_mmmm% %a_dd% , %a_yyyy%
#`::
if gui_toggle := !gui_toggle
    Gui, Show, w600 h300, Hotkey Maker
else
    Gui, Show, Hide
return
Pause::Reload

/*
 *==================================================================================
 *                          		END OF FILE
 *==================================================================================
 */

