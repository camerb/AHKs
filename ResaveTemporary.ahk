;Change hotkey mapping (resave file)

#include FcnLib.ahk

InputBox, mode, Archive`, Remap or make Permanent, Would you like to archive a temporary hotkey`, move it to a different hotkey or make it a permanent hotkey?
;mode:=prompt("")

beg=temporary
end=.ahk

if (mode="archive" || mode="a")
{
   ;Archive Temporary File
   ShowPreviewOfAllTempAhks()

   InputBox, sourcenumber, Source File, Which temporary ahk would you like to archive? (i.e. temporary#.ahk)
   ;TODO give a different folder path if they want to revisit this AHK later
   ;FIXME blank is acceptable if ErrorLevel return ;if user hit cancel

   InputBox, descr, Description, Give a couple words of description of this AHK:`n`nType REVISIT- if you plan on coming back to this AHK at some point.

   if (!isValid(sourcenumber))
   {
      debug("Invalid file")
      return
   }

   destnumber:=CurrentTime("hyphenated")
   source=%beg%%sourcenumber%
   dest=%A_WorkingDir%\archive\temporaryAHKs\%destnumber%-%descr%
   source := EnsureEndsWith(source, ".ahk")
   dest := EnsureEndsWith(dest, ".ahk")
}
else if (mode="remap" || mode="r")
{
   ;Remap temporary hotkey to a new key (1-9)

   InputBox, sourcenumber, Source File, Which temporary ahk would you like to copy? (i.e. temporary#.ahk)
   ;FIXME blank is acceptable if ErrorLevel return ;if user hit cancel

   InputBox, destnumber, Destination File, What should the new file be numbered as? (i.e. temporary#.ahk)
   ;FIXME if ErrorLevel return ;if user hit cancel

   if (!isValid(sourcenumber) || !isValid(destnumber) || sourcenumber=destnumber)
   {
      debug("Invalid file")
      return
   }

   source=%beg%%sourcenumber%
   dest=%beg%%destnumber%
   source := EnsureEndsWith(source, ".ahk")
   dest := EnsureEndsWith(dest, ".ahk")
}
else if (mode="permanent" || mode="p")
{
   ;Save temporary hotkey as a permanent hotkey

   InputBox, sourcenumber, Source File, Which temporary ahk would you like to copy? (i.e. temporary#.ahk)
   ;FIXME blank is acceptable if ErrorLevel return ;if user hit cancel

   InputBox, destnumber, Destination File, What should the new file be named?
   ;FIXME if ErrorLevel return ;if user hit cancel

   source=%beg%%sourcenumber%
   dest=%destnumber%
   source := EnsureEndsWith(source, ".ahk")
   dest := EnsureEndsWith(dest, ".ahk")
}

FileCopy, %source%, %dest%, true
FileCopy, template.ahk, %source%, true
ExitApp

;helper for validating temp file names
isValid(num)
{
   len:=strlen(num)
   if len not between 0 and 1
      return false
   if (len = 1)
   {
      if num not between 1 and 9
         return false
   }
   return true
}

ShowPreviewOfAllTempAhks()
{
   Loop 9
   {
      file=temporary%A_Index%.ahk
      header=#### %file% ####`n
      allText .= header
      linesIncluded=0
      Loop 15
      {
         includeLine:=true
         thisLine := FileReadLine(file, A_Index)
         if RegExMatch(thisLine, "^;*\#include")
            includeLine:=false
         if (linesIncluded >= 5)
            includeLine:=false
         if (thisLine == "")
            includeLine:=false

         if includeLine
         {
            linesIncluded++
            allText .= thisLine . "`n"
            includeLine:=false
         }
      }
      allText .= "`n`n"
   }

   Gui, Add, Edit, r65 c10 Disabled, %allText%
   Gui, Show, x10 y10
   ;Gui, Show, W100 H300 X10 Y10
}
