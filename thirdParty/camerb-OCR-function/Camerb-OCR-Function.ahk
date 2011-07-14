#Persistent
#SingleInstance force
;http://www.autohotkey.com/forum/viewtopic.php?p=93526#93526

SetBatchlines, -1

#Include GDIplusWrapper.ahk
#Include FcnLib.ahk
#Include thirdParty/CMDret.ahk

;Msgbox, 52, OCR Info,
;(
  ;This script will show the current text under mouse

  ;It uses:
  ;- GDIplusWrapper.ahk (by PhiLho)
  ;`t Converts screen portion to jpg
  ;- djpeg.exe
  ;`t Converts jpg to pnm
  ;- gocr.exe
  ;`t OCRs the pnm file
  ;- cmdret.dll/cmdstub.exe
  ;`t Gets the result from gocr.exe
  ;`t (since gocr.exe is a 16-bit program, cmdret.dll needs the cmdstub.exe)

  ;When the script is running, you can press the Escape key anytime to exit

  ;Do you want to run the script?
;)
;IfMsgBox, No, Goto, ExitMe

fileNameDestJ = ResultImage.jpg
CoordMode, Mouse, Screen
InfoWinTitle = OCR Info
CustomColor = 000000

;Gui, +AlwaysOnTop +LastFound +ToolWindow
;Gui, Color, %CustomColor%
;Gui, -Caption
;Gui, Add, Edit, x2 y24 w100 h20 vRes,
;Gui, Show, w104 h46, %InfoWinTitle%
WinSet, Region, 0-0 104-0 104-46 0-46 0-0 2-2 102-2 102-22 2-22 2-2, %InfoWinTitle%

SetTimer, GetTextUnderMouse, 100

Return

GetTextUnderMouse:
  SetTimer, GetTextUnderMouse, Off
  GetOcr()
  SetTimer, GetTextUnderMouse, On
Return

GetOcr()
{
  global #GDIplus_mimeType_JPG
  global #EncoderQuality

  ;AddToTrace("`n")
fileNameDestJ = ResultImage.jpg
InfoWinTitle = OCR Info
CustomColor = 000000
  MouseGetPos, thisX, thisY

  If (GDIplus_Start() != 0)
  	Goto GDIplusError

  If (GDIplus_CaptureScreenRectangle(bitmap, thisX-50, thisY-10, 100, 20) != 0)
  	Goto GDIplusError

#GDIplus_mimeType_JPG = image/jpeg
  If (GDIplus_GetEncoderCLSID(jpgEncoder, #GDIplus_mimeType_JPG) != 0)
  	Goto GDIplusError
;addtotrace("green line")

  GDIplus_InitEncoderParameters(jpegEncoderParams, 1)
  jpegQuality = 100

  If (GDIplus_AddEncoderParameter(jpegEncoderParams, #EncoderQuality, jpegQuality) != 0)
  	Goto GDIplusError

  If (GDIplus_SaveImage(bitmap, fileNameDestJ, jpgEncoder, jpegEncoderParams) != 0)
  	Goto GDIplusError
  ; Wait for jpg
  Loop,
  {
    IfExist, %fileNameDestJ%
      Break
  }

  CMDs =
  (LTrim Join
    djpeg.exe -pnm -grayscale %fileNameDestJ% in.pnm
    ,cmdstub.exe gocr.exe -i in.pnm
  )

  Loop, parse, CMDs, `,
  {
  	CMD = %A_LoopField%
  	NULL =
  	CMDin = ""
  	CMDout =
  	CMDerr =
  	Ret := RunWaitEx(CMD, NULL, CMDin, CMDout, CMDerr)
;addtotrace("orange line", CMDout, CMDerr)
  }
  ;debug(CMDs)

  joe:=CmdRet_RunReturn("gocr.exe -i in.pnm")
  addtotrace(joe)

  ;AddToTrace(result, "blue line")
  StringReplace, result, cmdout, `r`n, , A

;addtotrace("orange line", fileexist("in.pnm"), fileexist(filenamedestj))

  ; Cleanup
  FileDelete, in.pnm
  FileDelete, %fileNameDestJ%
  return %result%
}

RunWaitEx(CMD, CMDdir, CMDin, ByRef CMDout, ByRef CMDerr)
{
  VarSetCapacity(CMDOut, 100000)
  VarSetCapacity(CMDerr, 100000)
  RetVal := DllCall("cmdret.dll\RunWEx", "str", CMD, "str", CMDdir, "str", CMDin, "str", CMDout, "str", CMDerr)
  Return, %RetVal%
}

GDIplusError:
      addtotrace("red line")
	If (#GDIplus_lastError != "")
		MsgBox 16, GDIplus Test, Error in %#GDIplus_lastError% (at %step%)
GDIplusEnd:
	GDIplus_FreeImage(bitmap)
	GDIplus_Stop()
Return

Esc::
GuiEscape:
ExitMe:
  Gosub, GDIplusEnd
  FileDelete, in.pnm
  FileDelete, %fileNameDestJ%
ExitApp
