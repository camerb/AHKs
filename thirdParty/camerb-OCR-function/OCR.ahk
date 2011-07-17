/**
 *   OCR library by camerb
 *   v0.91 - 2011-07-15
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


;#Include ScreenCapture.ahk
;#Include thirdParty/sc.ahk
;#Include GDIplusWrapper.ahk
#Include thirdParty/GDIp.ahk
#Include CMDret.ahk
#Include FcnLib.ahk


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

   ;right  := topLeftX + widthToScan
   ;bottom := topLeftY + heightToScan
   ;coords=%topLeftX%, %topLeftY%, %right%, %bottom%
   ;CaptureScreen(coords, false, fileNameDestJ, 100)
   ;sc_CaptureScreen()
;addtotrace("green line")
   pToken:=Gdip_Startup()
   pBitmap:=Gdip_BitmapFromScreen(topLeftX "|" topLeftY "|" widthToScan "|" heightToScan)
   Gdip_SaveBitmapToFile(pBitmap, fileNameDestJ, 100)
   Gdip_Shutdown(pToken)

   while NOT FileExist(fileNameDestJ)
      Sleep, 10
;addtotrace("yellow line")

   ;coords, false, "C:\My Dropbox\AHKs\thirdParty\camerb-OCR-function\ResultImage.jpg", 100)
;addtotrace(jpgEncoder)
   ;;create the jpg file
   ;If ( GDIplus_Start() != 0)
;addtotrace("green line")
   ;if (GDIplus_CaptureScreenRectangle(bitmap, topLeftX, topLeftY, widthToScan, heightToScan) != 0)
;addtotrace("yellow line")
   ;if (GDIplus_GetEncoderCLSID(jpgEncoder, #GDIplus_mimeType_JPG) != 0)
;addtotrace("orange line")
   ;if (GDIplus_InitEncoderParameters(jpegEncoderParams, 1) != 0)
;addtotrace("red line")
   ;if (GDIplus_AddEncoderParameter(jpegEncoderParams, #EncoderQuality, jpegQuality) != 0)
;addtotrace("blue line")
   ;if (GDIplus_SaveImage(bitmap, fileNameDestJ, jpgEncoder, jpegEncoderParams) != 0)
;addtotrace("purple line")

   ;If ( (GDIplus_Start() != 0)
         ;OR (GDIplus_CaptureScreenRectangle(bitmap, topLeftX, topLeftY, widthToScan, heightToScan) != 0)
         ;OR (GDIplus_GetEncoderCLSID(jpgEncoder, #GDIplus_mimeType_JPG) != 0)
         ;OR (GDIplus_InitEncoderParameters(jpegEncoderParams, 1) != 0)
         ;OR (GDIplus_AddEncoderParameter(jpegEncoderParams, #EncoderQuality, jpegQuality) != 0)
         ;OR (GDIplus_SaveImage(bitmap, fileNameDestJ, jpgEncoder, jpegEncoderParams) != 0) )
   ;{
      ;SetBatchlines, %prevBatchLines%
      ;;if isDebugMode
         ;return GDIplus Test, Error in %#GDIplus_lastError% (at %step%)
      ;;else
         ;;return ""
   ;}

   ; Wait for jpg file to exist
   Loop
   {
      IfExist, %fileNameDestJ%
         Break
   }
addtotrace("orange line")

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

;CaptureScreen2(nl, nt, nw, nh)
;{
  ;nl:=100
  ;nt:=100
  ;nw:=200
  ;nh:=200
  ;pToken:=Gdip_Startup()
  ;pBitmap:=Gdip_BitmapFromScreen(nL "|" nT "|" nW "|" nH)
  ;Gdip_SaveBitmapToFile(pBitmap, "ResultImage.jpg")
  ;Gdip_Shutdown(pToken)

  ;while NOT FileExist("ResultImage.jpg")
     ;Sleep, 10
;}
