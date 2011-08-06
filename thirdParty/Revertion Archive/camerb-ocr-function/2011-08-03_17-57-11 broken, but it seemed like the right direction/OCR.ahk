/**
 *   OCR library by camerb
 *   v0.92 - 2011-08-03
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


#Include GDIp.ahk
#Include CMDret.ahk


GetOCR(topLeftX, topLeftY, widthToScan, heightToScan, isDebugMode=false)
{
   prevBatchLines := A_BatchLines
   SetBatchlines, -1 ;cuts the average time down from 140ms to 115ms for small areas

   fileNameDestJ = ResultImage.jpg
   jpegQuality = 100

   pToken:=Gdip_Startup()
   pBitmap:=Gdip_BitmapFromScreen(topLeftX "|" topLeftY "|" widthToScan "|" heightToScan)
   Gdip_SaveBitmapToFile(pBitmap, fileNameDestJ, 100)
   Gdip_Shutdown(pToken)

   ; Wait for jpg file to exist
   while NOT FileExist(fileNameDestJ)
      Sleep, 10

   ;convert the jpg file to pnm
   convertCmd=djpeg.exe -pnm -grayscale %fileNameDestJ% in.pnm

   ;run the OCR
   runCmd=gocr.exe -i in.pnm

   ;run both commands using the preferred method with cmdret
   ;CmdRet_RunReturn(convertCmd)
   ;CMDout := CmdRet_RunReturn(runCmd)

   ;run both commands using the hacky ghetto cmdret method
   ;GhettoCmdRet_RunReturn(convertCmd)
   ;CMDout := GhettoCmdRet_RunReturn(runCmd)

   ;run both commands using my mixed cmdret hack
   CmdRet(convertCmd)
   CMDout := CmdRet(runCmd)
   ;CMDout := CmdRet("ping google.com")
   ;addtotrace(CMDout)
   ;return cmdout
   ;sleep 10000

   ;convert and run the OCR - hacky method for AHK_L unicode compat
   ;CMDs =
   ;(LTrim Join
      ;djpeg.exe -pnm -grayscale %fileNameDestJ% in.pnm
      ;,cmdstub.exe gocr.exe -i in.pnm
   ;)

   ;Loop, parse, CMDs, `,
   ;{
      ;CMD = %A_LoopField%
      ;NULL =
      ;CMDin = ""
      ;CMDout =
      ;CMDerr =
      ;Ret := RunWaitEx(CMD, NULL, CMDin, CMDout, CMDerr)
   ;}

   ;StringReplace, result, cmdout, `r`n, %A_Space%, A

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

   ; Cleanup
   FileDelete, in.pnm
   FileDelete, %fileNameDestJ%
   SetBatchlines, %prevBatchLines%

   return %result%
}

;RunWaitEx(CMD, CMDdir, CMDin, ByRef CMDout, ByRef CMDerr)
;{
   ;VarSetCapacity(CMDOut, 100000)
   ;VarSetCapacity(CMDerr, 100000)
   ;RetVal := DllCall("cmdret.dll\RunWEx", "AStr", CMD, "AStr", CMDdir, "AStr", CMDin, "AStr", CMDout, "AStr", CMDerr)
   ;Return, %RetVal%
;}

;GhettoCmdRet_RunReturn(command)
;{
   ;file := "joe.txt"
   ;command .= " > " . file
   ;Run %comspec% /c "%command%"
   ;FileRead, returned, %file%
   ;return returned
;}

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

