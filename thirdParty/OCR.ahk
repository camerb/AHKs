/**
 *   OCR library by camerb
 *   v0.94 - 2011-09-08
 *
 * This OCR lib provides an easy way to check a part of the screen for
 * machine-readable text. You should note that OCR isn't a perfect technology,
 * and will frequently make mistakes, but it can give you a general idea of
 * what text is in a given area. For example, a common mistake that this OCR
 * function makes is that it frequently interprets slashes, lowercase L,
 * lowercase I, and the number 1 interchangably. Results can also vary
 * greatly based upon where the outer bounds of the area to scan are placed.
 *
 * Future plans include a function that will check if a given string is
 * displayed within the given coordinates on the screen.
 *
 * Home thread: http://www.autohotkey.com/forum/viewtopic.php?t=74227
 * With inspiration from: http://www.autohotkey.com/forum/viewtopic.php?p=93526#93526
*/


;#Include thirdParty/GDIp.ahk
;#Include thirdParty/CMDret.ahk


; the options parameter is a string and can contain any combination of the following:
;   debug - for use to show errors that GOCR spits out (not helpful for daily use)
;   numeric (or numeral, or number) - the text being scanned should be limited to
;            numbers only (no letters or special characters)
GetOCR(topLeftX="", topLeftY="", widthToScan="", heightToScan="", options="")
{
   ;TODO validate to ensure that the coords are numbers

   prevBatchLines := A_BatchLines
   SetBatchlines, -1 ;cuts the average time down from 140ms to 115ms for small areas

   ;process options from the options param, if they are there
   if options
   {
      if InStr(options, "debug")
         isDebugMode:=true
      if InStr(options, "numeral")
         isNumericMode:=true
      if InStr(options, "numeric")
         isNumericMode:=true
      if InStr(options, "number")
         isNumericMode:=true
   }

   if (heightToScan == "")
   {
      ;TODO throw error if not in the right coordmode
      ;or perhaps we can just process the entire screen
      ;CoordMode, Mouse, Window
      WinGetActiveStats, no, winWidth, winHeight, no, no
      topLeftX := 0
      topLeftY := 0
      widthToScan  := winWidth
      heightToScan := winHeight
   }

   fileNameDestJ = in.jpg
   jpegQuality = 100

   ;take a screenshot of the specified area
   pToken:=Gdip_Startup()
   pBitmap:=Gdip_BitmapFromScreen(topLeftX "|" topLeftY "|" widthToScan "|" heightToScan)
   Gdip_SaveBitmapToFile(pBitmap, fileNameDestJ, 100)
   Gdip_Shutdown(pToken)

   ; Wait for jpg file to exist
   while NOT FileExist(fileNameDestJ)
      Sleep, 10

   ;ensure the exes are there
   djpegPath=djpeg.exe
   gocrPath=gocr.exe

   if NOT FileExist(djpegPath)
      return "ERROR: djpeg.exe not found in expected location"

   if NOT FileExist(gocrPath)
      return "ERROR: gocr.exe not found in expected location"

   ;convert the jpg file to pnm
   ;NOTE maybe converting to greyscale isn't the best idea
   ;  ... does it increase reliability or speed?
   convertCmd=djpeg.exe -pnm -grayscale %fileNameDestJ% in.pnm

   ;run the OCR
   if isNumericMode
      additionalParams .= "-C 0-9 "
   runCmd=gocr.exe %additionalParams% in.pnm

   ;run both commands using my mixed cmdret hack
   CmdRet(convertCmd)
   result := CmdRet(runCmd)

   ;suppress warnings from GOCR (we don't care, give us nothing)
   if InStr(result, "NOT NORMAL")
      gocrError:=true
   if InStr(result, "strong rotation angle detected")
      gocrError:=true
   if InStr(result, "# no boxes found - stopped") ;multiple warnings show up with this in the string
      gocrError:=true

   if gocrError
   {
      if NOT isDebugMode
         result=
   }

   if isNumericMode
   {
      result := RegExReplace(result, "[ _]+", " ")
   }

   ; Cleanup (preserve the files if in debug mode)
   if NOT isDebugMode
   {
      FileDelete, in.pnm
      FileDelete, %fileNameDestJ%
   }
   SetBatchlines, %prevBatchLines%

   return result
}

CMDret(CMD)
{
   if RegExMatch(A_AHKversion, "^\Q1.0\E")
   {
      StrOut:=CMDret_RunReturn(cmd)
   }
   else
   {
      VarSetCapacity(StrOut, 20000)
      RetVal := DllCall("cmdret.dll\RunReturn", "astr", CMD, "ptr", &StrOut)
      strget:="strget"
      StrOut:=%StrGet%(&StrOut, 20000, CP0)
   }
   Return, %StrOut%
}

