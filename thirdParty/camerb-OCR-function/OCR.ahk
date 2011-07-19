/**
 *   OCR library by camerb
 *   v0.91 - 2011-07-18
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

   ;stupid globals that we have to get from the GDIp wrapper class
   ;(why aren't these in a "get" function?)
   global #GDIplus_mimeType_JPG
   global #EncoderQuality

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
   CmdRet_RunReturn(convertCmd)

   ;run the OCR
   CMDout := CmdRet_RunReturn("gocr.exe -i in.pnm")

   StringReplace, result, cmdout, `r`n, %A_Space%, A

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
