; Gdip standard library v1.30 by tic (Tariq Porter) 02/01/10
;
;#####################################################################################
;#####################################################################################
; STATUS ENUMERATION
; Return values for functions specified to have status enumerated return type
;#####################################################################################
; Ok = 0
; GenericError = 1
; InvalidParameter = 2
; OutOfMemory = 3
; ObjectBusy = 4
; InsufficientBuffer = 5
; NotImplemented = 6
; Win32Error = 7
; WrongState = 8
; Aborted = 9
; FileNotFound = 10
; ValueOverflow = 11
; AccessDenied = 12
; UnknownImageFormat = 13
; FontFamilyNotFound = 14
; FontStyleNotFound = 15
; NotTrueTypeFont = 16
; UnsupportedGdiplusVersion = 17
; GdiplusNotInitialized = 18
; PropertyNotFound = 19
; PropertyNotSupported = 20
; ProfileNotFound = 21
;#####################################################################################
;#####################################################################################
; GDI and structure functions
; ########################
; UpdateLayeredWindow
; CreateRectF
; CreateSizeF
; CreateDIBSection

;#####################################################################################
;#####################################################################################
;
; GDI and structure functions
;
;#####################################################################################
;#####################################################################################

; Function:     UpdateLayeredWindow
; Description:  Updates a layered window with the handle to the DC of a gdi bitmap
;   
; hwnd        	= Handle of the window to update
; hdc           = Handle to the DC of the GDI bitmap to update the window with
; Layeredx      = x position to place the window
; Layeredy      = x position to place the window
; Layeredw      = Width of the window
; Layeredh      = Height of the window
; Alpha         = Default = 255 : The transparency (0-255) to set the window transparency
;
; Return:      	If the function succeeds, the return value is nonzero.
;
UpdateLayeredWindow(hwnd, hdc, x="", y="", w="", h="", Alpha=255)
{
   If ((x != "") && (y != ""))
   VarSetCapacity(pt, 8), NumPut(x, pt, 0), NumPut(y, pt, 4)
   
   If ((w = "") ||(h = ""))
   WinGetPos,,, w, h, ahk_id %hwnd%
   
   Return, DllCall("UpdateLayeredWindow"
   , "UInt", hwnd
   , "UInt", 0
   , "UInt", ((x = "") && (y = "")) ? 0 : &pt
   , "Int64*", w|h<<32
   , "UInt", hdc
   , "Int64*", 0
   , "UInt", 0
   , "UInt*", Alpha<<16|1<<24
   , "UInt", 2)
}
;#####################################################################################
BitBlt(dDC, dx, dy, dw, dh, sDC, sx, sy, Raster="")
{
	Return, DllCall("gdi32\BitBlt"
	, "UInt", dDC							; handle to destination DC
	, "Int", dx								; x-coord of destination upper-left corner
	, "Int", dy								; y-coord of destination upper-left corner
	, "Int", dw								; width of destination rectangle
	, "Int", dh								; height of destination rectangle
	, "UInt", sDC							; handle to source DC
	, "Int", sx								; x-coordinate of source upper-left corner
	, "Int", sy								; y-coordinate of source upper-left corner
	, "UInt", Raster ? Raster : 0x00CC0020)	; raster operation code
}
;#####################################################################################
StretchBlt(dDC, dx, dy, dw, dh, sDC, sx, sy, sw, sh, Raster="")
{
	Return, DllCall("gdi32\StretchBlt"
	, "UInt", dDC							; handle to destination DC
	, "Int", dx								; x-coord of destination upper-left corner
	, "Int", dy								; y-coord of destination upper-left corner
	, "Int", dw								; width of destination rectangle
	, "Int", dh								; height of destination rectangle
	, "UInt", sDC							; handle to source DC
	, "Int", sx								; x-coordinate of source upper-left corner
	, "Int", sy								; y-coordinate of source upper-left corner
	, "Int", sw								; width of source rectangle
	, "Int", sh								; height of source rectangle
	, "UInt", Raster ? Raster : 0x00CC0020)	; raster operation code
}
;#####################################################################################
SetImage(hwnd, hBitmap)
{
	SendMessage, 0x172, 0x0, hBitmap,, ahk_id %hwnd%
	E := ErrorLevel
	DeleteObject(E)
	return E
}
;#####################################################################################
Gdip_BitmapFromScreen(Screen=0, Raster="")
{
	If (Screen = 0)
	{
		Sysget, x, 76
		Sysget, y, 77	
		Sysget, w, 78
		Sysget, h, 79
	}
	Else If (Screen&1 != "")
	{
		Sysget, M, Monitor, %Screen%
		x := MLeft, y := MTop, w := MRight-MLeft, h := MBottom-MTop
	}
	Else
	{
		StringSplit, S, Screen, |
		x := S1, y := S2, w := S3, h := S4
	}
	
	If (x = "") || (y = "") || (w = "") || (h = "")
	Return, -1
	
	chdc := CreateCompatibleDC(), hbm := CreateDIBSection(w, h, chdc), obm := SelectObject(chdc, hbm), hhdc := GetDC()
	BitBlt(chdc, 0, 0, w, h, hhdc, x, y, Raster)
	ReleaseDC(hhdc)
	
	pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
	SelectObject(hhdc, obm), DeleteObject(hbm), DeleteDC(hhdc), DeleteDC(chdc)
	Return, pBitmap
}

;#####################################################################################

Gdip_BitmapFromHWND(hwnd=0)
{
	WinGetPos,,, Width, Height, ahk_id %hwnd%
	hbm := CreateDIBSection(Width, Height), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
	PrintWindow(hwnd, hdc)
	pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
	SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
	Return, pBitmap
}
;#####################################################################################

; Function:    	CreateRectF
; Description: 	Creates a RectF object, containing a the coordinates and dimensions of a rectangle
;
; RectF       	= Name to call the RectF object
; x            = x-coordinate of the upper left corner of the rectangle
; y            = y-coordinate of the upper left corner of the rectangle
; w            = Width of the rectangle
; h            = Height of the rectangle
;
; Return:      No return value
;
CreateRectF(ByRef RectF, x, y, w, h)
{
   VarSetCapacity(RectF, 16)
   NumPut(x, RectF, 0, "Float"), NumPut(y, RectF, 4, "Float"), NumPut(w, RectF, 8, "Float"), NumPut(h, RectF, 12, "Float")
}
;#####################################################################################

; Function:    CreateSizeF
; Description:   Creates a SizeF object, containing an 2 values
;
; SizeF         = Name to call the SizeF object
; w            = w-value for the SizeF object
; h            = h-value for the SizeF object
;
; Return:      No Return value
;
CreateSizeF(ByRef SizeF, w, h)
{
   VarSetCapacity(SizeF, 8)
   NumPut(w, SizeF, 0, "Float"), NumPut(h, SizeF, 4, "Float")     
}
;#####################################################################################

CreatePointF(ByRef PointF, x, y)
{
   VarSetCapacity(PointF, 8)
   NumPut(x, PointF, 0, "Float"), NumPut(y, PointF, 4, "Float")     
}
;#####################################################################################

CreateDIBSection(w, h, hdc="", bpp=32, ByRef ppvBits=0)
{
	hdc2 := hdc ? hdc : GetDC()

	VarSetCapacity(bi, 40, 0)
	NumPut(w, bi, 4), NumPut(h, bi, 8), NumPut(40, bi, 0), NumPut(1, bi, 12, "UShort"), NumPut(0, bi, 16), NumPut(bpp, bi, 14, "UShort")
	hbm := DllCall("CreateDIBSection", "UInt" , hdc2, "UInt" , &bi, "UInt" , 0, "UInt*", ppvBits, "UInt" , 0, "UInt" , 0)
	
	If !hdc
	ReleaseDC(hdc2)
	Return, hbm
}

;#####################################################################################

PrintWindow(hwnd, hdc, Flags=0)
{
	Return, DllCall("PrintWindow", "UInt", hwnd, "UInt", hdc, "UInt", Flags)
}

DestroyIcon(hIcon)
{
   Return, DllCall("DestroyIcon", "UInt", hIcon)
}

CreateCompatibleDC(hdc=0)
{
   Return, DllCall("CreateCompatibleDC", "UInt", hdc)
}      

SelectObject(hdc, hgdiobj)
{
   Return, DllCall("SelectObject", "UInt", hdc, "UInt", hgdiobj)
}

DeleteObject(hObject)
{
   Return, DllCall("DeleteObject", "UInt", hObject)
}

GetDC(hwnd=0)
{
	Return, DllCall("GetDC", "UInt", hwnd)
}

ReleaseDC(hdc, hwnd=0)
{
   Return, DllCall("ReleaseDC", "UInt", hwnd, "UInt", hdc)
}

DeleteDC(hdc)
{
   Return, DllCall("DeleteDC", "UInt", hdc)
}
;#####################################################################################

Gdip_LibraryVersion()
{
	return 1.30
}

;#####################################################################################

; Function:    	Gdip_BitmapFromBRA
; Description: 	Gets a pointer to a gdi+ bitmap from a BRA file
;
; BRAFromMemIn	= The variable for a BRA file read to memory
; File			= The name of the file, or its number that you would like (This depends on Alternate parameter)
; Alternate		= Changes whether the File parameter is the file name or its number
;
; Return:      	If the function succeeds, the return value is a pointer to a gdi+ bitmap
;				-1:		The BRA variable is empty
;				-2:		The BRA has an incorrect header
;				-3:		THe BRA has information missing
;				-4:		Could not find file inside the BRA
;
Gdip_BitmapFromBRA(ByRef BRAFromMemIn, File, Alternate=0)
{
	if !BRAFromMemIn
		return -1
	Loop, Parse, BRAFromMemIn, `n
	{
		if (A_Index = 1)
		{
			StringSplit, Header, A_LoopField, |
			if (Header0 != 4 || Header2 != "BRA!")
				return -2
		}
		else if (A_Index = 2)
		{
			StringSplit, Info, A_LoopField, |
			if (Info0 != 3)
				return -3
		}
		else
			break
	}
	if !Alternate
		StringReplace, File, File, \, \\, All
	RegExMatch(BRAFromMemIn, "mi`n)^" (Alternate ? File "\|.+?\|(\d+)\|(\d+)" : "\d+\|" File "\|(\d+)\|(\d+)") "$", FileInfo)
	if !FileInfo
		return -4

	hData := DllCall("GlobalAlloc", "UInt", 2, "UInt", FileInfo2)
	pData := DllCall("GlobalLock", "UInt", hData)
	DllCall("RtlMoveMemory", "UInt", pData, "UInt", &BRAFromMemIn+Info2+FileInfo1, "UInt", FileInfo2)
	DllCall("GlobalUnlock", "UInt", hData)
	DllCall("ole32\CreateStreamOnHGlobal", "UInt", hData, "Int", 1, "UInt*", pStream)
	DllCall("gdiplus\GdipCreateBitmapFromStream", "UInt", pStream, "UInt*", pBitmap)
	DllCall(NumGet(NumGet(1*pStream)+8), "UInt", pStream)
	return pBitmap
}

;#####################################################################################
;
; GDI+ functions
;
;#####################################################################################
;#####################################################################################
;#####################################################################################
; Draw shape/line
;#####################################################################################

Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h)
{
   Return, DllCall("gdiplus\GdipDrawRectangle", "UInt", pGraphics, "UInt", pPen
   , "Float", x, "Float", y, "Float", w, "Float", h)
}

Gdip_DrawRoundedRectangle(pGraphics, pPen, x, y, w, h, r)
{
	Gdip_SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
	E := Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h)
	Gdip_ResetClip(pGraphics)
	Gdip_SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
	Gdip_SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
	Gdip_DrawEllipse(pGraphics, pPen, x, y, 2*r, 2*r)
	Gdip_DrawEllipse(pGraphics, pPen, x+w-(2*r), y, 2*r, 2*r)
	Gdip_DrawEllipse(pGraphics, pPen, x, y+h-(2*r), 2*r, 2*r)
	Gdip_DrawEllipse(pGraphics, pPen, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
	Gdip_ResetClip(pGraphics)
	Return, E
}

Gdip_DrawEllipse(pGraphics, pPen, x, y, w, h)
{
   Return, DllCall("gdiplus\GdipDrawEllipse", "UInt", pGraphics, "UInt", pPen
   , "Float", x, "Float", y, "Float", w, "Float", h)
}

Gdip_DrawBezier(pGraphics, pPen, x1, y1, x2, y2, x3, y3, x4, y4)
{
   Return, DllCall("gdiplus\GdipDrawBezier", "UInt", pgraphics, "UInt", pPen
   , "Float", x1, "Float", y1, "Float", x2, "Float", y2
   , "Float", x3, "Float", y3, "Float", x4, "Float", y4)
}

Gdip_DrawArc(pGraphics, pPen, x, y, w, h, StartAngle, SweepAngle)
{
   Return, DllCall("gdiplus\GdipDrawArc", "UInt", pGraphics, "UInt", pPen
   , "Float", x, "Float", y, "Float", w, "Float", h, "Float", StartAngle, "Float", SweepAngle)
}

Gdip_DrawPie(pGraphics, pPen, x, y, w, h, StartAngle, SweepAngle)
{
   Return, DllCall("gdiplus\GdipDrawPie", "UInt", pGraphics, "UInt", pPen, "Float", x, "Float", y, "Float", w, "Float", h, "Float", StartAngle, "Float", SweepAngle)
}

Gdip_DrawLine(pGraphics, pPen, x1, y1, x2, y2)
{
   Return, DllCall("gdiplus\GdipDrawLine", "UInt", pGraphics, "UInt", pPen
   , "Float", x1, "Float", y1, "Float", x2, "Float", y2)
}

; Points passed as x1,y1|x2,y2|x3,y3.....
Gdip_DrawLines(pGraphics, pPen, Points)
{
   StringSplit, Points, Points, |
   VarSetCapacity(PointF, 8*Points0)   
   Loop, %Points0%
   {
      StringSplit, Coord, Points%A_Index%, `,
      NumPut(Coord1, PointF, 8*(A_Index-1), "Float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "Float")
   }
   Return, DllCall("gdiplus\GdipDrawLines", "UInt", pGraphics, "UInt", pPen, "UInt", &PointF, "Int", Points0)
}

;#####################################################################################
; Fill shape
;#####################################################################################

Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h)
{
   Return, DllCall("gdiplus\GdipFillRectangle", "UInt", pGraphics, "Int", pBrush
   , "Float", x, "Float", y, "Float", w, "Float", h)
}

Gdip_FillRoundedRectangle(pGraphics, pBrush, x, y, w, h, r)
{
	Region := Gdip_GetClipRegion(pGraphics)
	Gdip_SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
	E := Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h)
	Gdip_SetClipRegion(pGraphics, Region, 0)
	Gdip_SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
	Gdip_SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
	Gdip_FillEllipse(pGraphics, pBrush, x, y, 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y, 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x, y+h-(2*r), 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
	Gdip_SetClipRegion(pGraphics, Region, 0)
	Gdip_DeleteRegion(Region)
	Return, E
}

; Points passed as x1,y1|x2,y2|x3,y3.....
Gdip_FillPolygon(pGraphics, pBrush, Points, FillMode=0)
{
   StringSplit, Points, Points, |
   VarSetCapacity(PointF, 8*Points0)   
   Loop, %Points0%
   {
      StringSplit, Coord, Points%A_Index%, `,
      NumPut(Coord1, PointF, 8*(A_Index-1), "Float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "Float")
   }   
   Return, DllCall("gdiplus\GdipFillPolygon", "UInt", pGraphics, "UInt", pBrush, "UInt", &PointF, "Int", Points0, "Int", FillMode)
}

Gdip_FillPie(pGraphics, pBrush, x, y, w, h, StartAngle, SweepAngle)
{
   Return, DllCall("gdiplus\GdipFillPie", "UInt", pGraphics, "UInt", pBrush
   , "Float", x, "Float", y, "Float", w, "Float", h, "Float", StartAngle, "Float", SweepAngle)
}

Gdip_FillEllipse(pGraphics, pBrush, x, y, w, h)
{
   Return, DllCall("gdiplus\GdipFillEllipse", "UInt", pGraphics, "UInt", pBrush
   , "Float", x, "Float", y, "Float", w, "Float", h, "Float")
}

Gdip_FillRegion(pGraphics, pBrush, Region)
{
   Return, DllCall("gdiplus\GdipFillRegion", "UInt", pGraphics, "UInt", pBrush, "UInt", Region)
}

Gdip_FillPath(pGraphics, pBrush, Path)
{
   Return, DllCall("gdiplus\GdipFillPath", "UInt", pGraphics, "UInt", pBrush, "UInt", Path)
}

;#####################################################################################
; Graphics functions
;#####################################################################################

; Points passed as x1,y1|x2,y2|x3,y3 (3 points: top left, top right, bottom left)
Gdip_DrawImagePointsRect(pGraphics, pBitmap, Points, sx="", sy="", sw="", sh="", Matrix=1)
{
	StringSplit, Points, Points, |
	VarSetCapacity(PointF, 8*Points0)   
	Loop, %Points0%
	{
		StringSplit, Coord, Points%A_Index%, `,
		NumPut(Coord1, PointF, 8*(A_Index-1), "Float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "Float")
	}
	
	If (Matrix&1 = "")
	ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
	Else if (Matrix != 1)
	ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")
	
	E := DllCall("gdiplus\GdipDrawImagePointsRect", "UInt", pGraphics, "UInt", pBitmap
	, "UInt", &PointF, "Int", Points0, "Float", sx, "Float", sy, "Float", sw, "Float", sh
	, "Int", 2, "UInt", ImageAttr, "UInt", 0, "UInt", 0)
	If ImageAttr
	Gdip_DisposeImageAttributes(ImageAttr)
	Return, E
}

Gdip_DrawImage(pGraphics, pBitmap, dx, dy, dw="", dh="", sx="", sy="", sw="", sh="", Matrix=1)
{
	If (Matrix&1 = "")
		ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
	Else if (Matrix != 1)
		ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")

	If (sx = "") && (sy = "") && (sw = "") && (sh = "")
	sx := 0, sy := 0, sw := dw, sh := dh
	
	E := DllCall("gdiplus\GdipDrawImageRectRect", "UInt", pGraphics, "UInt", pBitmap
	, "Float", dx, "Float", dy, "Float", dw, "Float", dh
	, "Float", sx, "Float", sy, "Float", sw, "Float", sh
	, "Int", 2, "UInt", ImageAttr, "UInt", 0, "UInt", 0)
	If ImageAttr
	Gdip_DisposeImageAttributes(ImageAttr)
	Return, E
}

;MatrixBright = 1.5|0|0|0|0|0|1.5|0|0|0|0|0|1.5|0|0|0|0|0|1|0|0.05|0.05|0.05|0|1
;MatrixGreyScale = 0.299|0.299|0.299|0|0|0.587|0.587|0.587|0|0|0.114|0.114|0.114|0|0|0|0|0|1|0|0|0|0|0|1
;MatrixNegative = -1|0|0|0|0|0|-1|0|0|0|0|0|-1|0|0|0|0|0|1|0|0|0|0|0|1
Gdip_SetImageAttributesColorMatrix(Matrix)
{
	VarSetCapacity(ColourMatrix, 100, 0)
	Matrix := RegExReplace(RegExReplace(Matrix, "^[^0-9-\.]+([0-9\.])", "$1", "", 1), "[^0-9-\.]+", "|")
	StringSplit, Matrix, Matrix, |
	Loop, 25
	{
		Matrix := (Matrix%A_Index% != "") ? Matrix%A_Index% : Mod(A_Index-1, 6) ? 0 : 1
		NumPut(Matrix, ColourMatrix, (A_Index-1)*4, "Float")
	}
	DllCall("gdiplus\GdipCreateImageAttributes", "UInt*", ImageAttr)
	DllCall("gdiplus\GdipSetImageAttributesColorMatrix", "UInt", ImageAttr, "Int", 1, "Int", 1, "UInt", &ColourMatrix, "Int", 0, "Int", 0)
	VarSetCapacity(ColourMatrix, 0)
	Return, ImageAttr
}

Gdip_GraphicsFromImage(pBitmap)
{
    DllCall("gdiplus\GdipGetImageGraphicsContext", "UInt", pBitmap, "UInt*", pGraphics)
    Return, pGraphics
}

Gdip_GraphicsFromHDC(hdc)
{
    DllCall("gdiplus\GdipCreateFromHDC", "UInt", hdc, "UInt*", pGraphics)
    Return, pGraphics
}

Gdip_GraphicsClear(pGraphics, ARGB=0x00ffffff)
{
    Return, DllCall("gdiplus\GdipGraphicsClear", "UInt", pGraphics, "Int", ARGB)
}

;#####################################################################################
; Bitmap functions
;#####################################################################################

Gdip_BlurBitmap(pBitmap, Blur)
{
	If ((Blur > 100) || (Blur < 1))
	Return, -1	
	
	sWidth := Gdip_GetImageWidth(pBitmap), sHeight := Gdip_GetImageHeight(pBitmap)
	dWidth := sWidth//Blur, dHeight := sHeight//Blur

	pBitmap1 := Gdip_CreateBitmap(dWidth, dHeight)
	G1 := Gdip_GraphicsFromImage(pBitmap1)
	Gdip_SetInterpolationMode(G1, 7)
	Gdip_DrawImage(G1, pBitmap, 0, 0, dWidth, dHeight, 0, 0, sWidth, sHeight)

	Gdip_DeleteGraphics(G1)
	Gdip_DisposeImage(pBitmap)

	pBitmap2 := Gdip_CreateBitmap(sWidth, sHeight)
	G2 := Gdip_GraphicsFromImage(pBitmap2)
	Gdip_SetInterpolationMode(G2, 7)
	Gdip_DrawImage(G2, pBitmap1, 0, 0, sWidth, sHeight, 0, 0, dWidth, dHeight)

	Gdip_DeleteGraphics(G2)
	Gdip_DisposeImage(pBitmap1)
	Return, pBitmap2
}
;#####################################################################################

; Function:     Gdip_SaveBitmapToFile
; Description:  Saves a gdi+ bitmap to a file in any supported format onto disk
;   
; pBitmap      	= Pointer to the gdi+ bitmap object
; sOutput      	= The name of the file that the bitmap will eb saved to. Supported extensions are: .BMP,.DIB,.RLE,.JPG,.JPEG,.JPE,.JFIF,.GIF,.TIF,.TIFF,.PNG
; Quality      	= If saving as jpg (.JPG,.JPEG,.JPE,.JFIF) then quality can be 1-100 with default at maximum quality
;
; Return:      	If the function succeeds, the return value is zero, otherwise:
;				-1:		Extension supplied is not a supported file format
;				-2:		Could not get a list of encoders on system
;				-3:		Could not find matching encoder for specified file format
;				-4:		Could not get WideChar name of output file
;				-5:		Could not save file to disk
;

Gdip_SaveBitmapToFile(pBitmap, sOutput, Quality=100)
{
	SplitPath, sOutput,,, Extension
	Extension := "." Extension
	If Extension not in .BMP,.DIB,.RLE,.JPG,.JPEG,.JPE,.JFIF,.GIF,.TIF,.TIFF,.PNG
	Return, -1
   
	DllCall("gdiplus\GdipGetImageEncodersSize", "UInt*", nCount, "UInt*", nSize)
	VarSetCapacity(ci, nSize)
	DllCall("gdiplus\GdipGetImageEncoders", "UInt", nCount, "UInt", nSize, "UInt", &ci)
	If !(nCount && nSize)
	Return, -2
   
	Loop, %nCount%
	{
		nSize := DllCall("WideCharToMultiByte", "UInt", 0, "UInt", 0, "UInt", NumGet(ci, 76*(A_Index-1)+44), "Int", -1, "UInt", 0, "Int",  0, "UInt", 0, "UInt", 0)
		VarSetCapacity(sString, nSize)
		DllCall("WideCharToMultiByte", "UInt", 0, "UInt", 0, "UInt", NumGet(ci, 76*(A_Index-1)+44), "Int", -1, "Str", sString, "Int", nSize, "UInt", 0, "UInt", 0)
		
		If !InStr(sString, Extension)
		Continue
		pCodec := &ci+76*(A_Index-1)
		Break
    }
	If !pCodec
	Return, -3

	If (Quality != 100)
	{
		If Extension in .JPG,.JPEG,.JPE,.JFIF
		{
			DllCall("gdiplus\GdipGetEncoderParameterListSize", "UInt", pBitmap, "UInt", pCodec, "UInt*", nSize)
			VarSetCapacity(EncoderParameters, nSize, 0)
			DllCall("gdiplus\GdipGetEncoderParameterList", "UInt", pBitmap, "UInt", pCodec, "UInt", nSize, "UInt", &EncoderParameters)
			Loop, % NumGet(EncoderParameters)		;%
			{
				If	(NumGet(EncoderParameters, (28*(A_Index-1))+20) = 1) && (NumGet(EncoderParameters, (28*(A_Index-1))+24) = 6)
				{
					p := (28*(A_Index-1))+&EncoderParameters
					NumPut(Quality, NumGet(NumPut(4, NumPut(1, p+0)+20)))
					Break
				}
			}		
		}
	}
   
	nSize := DllCall("MultiByteToWideChar", "UInt", 0, "UInt", 0, "UInt", &sOutput, "Int", -1, "UInt", 0, "Int", 0)
	VarSetCapacity(wOutput, nSize*2)
	DllCall("MultiByteToWideChar", "UInt", 0, "UInt", 0, "UInt", &sOutput, "Int", -1, "UInt", &wOutput, "Int", nSize)
	VarSetCapacity(wOutput, -1)
	If !VarSetCapacity(wOutput)
	Return, -4

	E := DllCall("gdiplus\GdipSaveImageToFile", "UInt", pBitmap, "UInt", &wOutput, "UInt", pCodec, "UInt", p ? p : 0)
	Return, E ? -5 : 0
}

Gdip_GetPixel(pBitmap, x, y)
{
	DllCall("gdiplus\GdipBitmapGetPixel", "UInt", pBitmap, "Int", x, "Int", y, "UInt*", ARGB)
	Return, ARGB
}

Gdip_SetPixel(pBitmap, x, y, ARGB)
{
   Return, DllCall("gdiplus\GdipBitmapSetPixel", "UInt", pBitmap, "Int", x, "Int", y, "Int", ARGB)
}

Gdip_GetImageWidth(pBitmap)
{
   DllCall("gdiplus\GdipGetImageWidth", "UInt", pBitmap, "UInt*", Width)
   Return, Width
}

Gdip_GetImageHeight(pBitmap)
{
   DllCall("gdiplus\GdipGetImageHeight", "UInt", pBitmap, "UInt*", Height)
   Return, Height
}

Gdip_GetDpiX(pGraphics)
{
	DllCall("gdiplus\GdipGetDpiX", "UInt", pGraphics, "Float*", DPIx)
	Return, DPIx
}

Gdip_GetDpiY(pGraphics)
{
	DllCall("gdiplus\GdipGetDpiY", "UInt", pGraphics, "Float*", DPIy)
	Return, DPIy
}

Gdip_CreateBitmapFromFile(sFile)
{
   VarSetCapacity(wFile, 1023)
   DllCall("kernel32\MultiByteToWideChar", "UInt", 0, "UInt", 0, "UInt", &sFile, "Int", -1, "UInt", &wFile, "Int", 512)
   DllCall("gdiplus\GdipCreateBitmapFromFile", "UInt", &wFile, "UInt*", pBitmap)
   Return, pBitmap
}

Gdip_CreateBitmapFromHBITMAP(hBitmap, Palette=0)
{
	DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "UInt", hBitmap, "UInt", Palette, "UInt*", pBitmap)
	Return, pBitmap
}

Gdip_CreateHBITMAPFromBitmap(pBitmap, Background=0xffffffff)
{
	DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "UInt", pBitmap, "UInt*", hbm, "Int", Background)
	Return, hbm
}

Gdip_CreateBitmapFromHICON(hIcon)
{
	DllCall("gdiplus\GdipCreateBitmapFromHICON", "UInt", hIcon, "UInt*", pBitmap)
	Return, pBitmap
}

Gdip_CreateHICONFromBitmap(pBitmap)
{
	DllCall("gdiplus\GdipCreateHICONFromBitmap", "UInt", pBitmap, "UInt*", hIcon)
	Return, hIcon
}

Gdip_CreateBitmap(Width, Height, Format=0x26200A)
{
    DllCall("gdiplus\GdipCreateBitmapFromScan0", "Int", Width, "Int", Height, "Int", 0, "Int", Format, "UInt", 0, "UInt*", pBitmap)
    Return pBitmap
}

Gdip_CloneBitmapArea(pBitmap, x, y, w, h, Format=0x26200A)
{
	DllCall("gdiplus\GdipCloneBitmapArea", "Float", x, "Float", y, "Float", w, "Float", h
	, "Int", Format, "UInt", pBitmap, "UInt*", pBitmapDest)
	Return, pBitmapDest
}

;#####################################################################################
; Create resources
;#####################################################################################

Gdip_CreatePen(ARGB, w)
{
   DllCall("gdiplus\GdipCreatePen1", "Int", ARGB, "Float", w, "Int", 2, "UInt*", pPen)
   Return, pPen
}

Gdip_BrushCreateSolid(ARGB=0xff000000)
{
   DllCall("gdiplus\GdipCreateSolidFill", "Int", ARGB, "UInt*", pBrush)
   Return, pBrush
}

; HatchStyleHorizontal = 0
; HatchStyleVertical = 1
; HatchStyleForwardDiagonal = 2
; HatchStyleBackwardDiagonal = 3
; HatchStyleCross = 4
; HatchStyleDiagonalCross = 5
; HatchStyle05Percent = 6
; HatchStyle10Percent = 7
; HatchStyle20Percent = 8
; HatchStyle25Percent = 9
; HatchStyle30Percent = 10
; HatchStyle40Percent = 11
; HatchStyle50Percent = 12
; HatchStyle60Percent = 13
; HatchStyle70Percent = 14
; HatchStyle75Percent = 15
; HatchStyle80Percent = 16
; HatchStyle90Percent = 17
; HatchStyleLightDownwardDiagonal = 18
; HatchStyleLightUpwardDiagonal = 19
; HatchStyleDarkDownwardDiagonal = 20
; HatchStyleDarkUpwardDiagonal = 21
; HatchStyleWideDownwardDiagonal = 22
; HatchStyleWideUpwardDiagonal = 23
; HatchStyleLightVertical = 24
; HatchStyleLightHorizontal = 25
; HatchStyleNarrowVertical = 26
; HatchStyleNarrowHorizontal = 27
; HatchStyleDarkVertical = 28
; HatchStyleDarkHorizontal = 29
; HatchStyleDashedDownwardDiagonal = 30
; HatchStyleDashedUpwardDiagonal = 31
; HatchStyleDashedHorizontal = 32
; HatchStyleDashedVertical = 33
; HatchStyleSmallConfetti = 34
; HatchStyleLargeConfetti = 35
; HatchStyleZigZag = 36
; HatchStyleWave = 37
; HatchStyleDiagonalBrick = 38
; HatchStyleHorizontalBrick = 39
; HatchStyleWeave = 40
; HatchStylePlaid = 41
; HatchStyleDivot = 42
; HatchStyleDottedGrid = 43
; HatchStyleDottedDiamond = 44
; HatchStyleShingle = 45
; HatchStyleTrellis = 46
; HatchStyleSphere = 47
; HatchStyleSmallGrid = 48
; HatchStyleSmallCheckerBoard = 49
; HatchStyleLargeCheckerBoard = 50
; HatchStyleOutlinedDiamond = 51
; HatchStyleSolidDiamond = 52
; HatchStyleTotal = 53
Gdip_BrushCreateHatch(ARGBfront, ARGBback, HatchStyle=0)
{
   DllCall("gdiplus\GdipCreateHatchBrush", "Int", HatchStyle, "Int", ARGBfront, "Int", ARGBback, "UInt*", pBrush)
   Return, pBrush
}

; WrapModeTile = 0
; WrapModeTileFlipX = 1
; WrapModeTileFlipY = 2
; WrapModeTileFlipXY = 3
; WrapModeClamp = 4
Gdip_CreateLineBrush(x1, y1, x2, y2, ARGB1, ARGB2, WrapMode=1)
{
	CreatePointF(PointF1, x1, y1), CreatePointF(PointF2, x2, y2)
	DllCall("gdiplus\GdipCreateLineBrush", "UInt", &PointF1, "UInt", &PointF2, "Int", ARGB1, "Int", ARGB2, "Int", WrapMode, "UInt*", LGpBrush)
	Return, LGpBrush
}

; LinearGradientModeHorizontal = 0
; LinearGradientModeVertical = 1
; LinearGradientModeForwardDiagonal = 2
; LinearGradientModeBackwardDiagonal = 3
Gdip_CreateLineBrushFromRect(x, y, w, h, ARGB1, ARGB2, LinearGradientMode=1, WrapMode=1)
{
	CreateRectF(RectF, x, y, w, h)
	DllCall("gdiplus\GdipCreateLineBrushFromRect", "UInt", &RectF, "Int", ARGB1, "Int", ARGB2, "Int", LinearGradientMode, "Int", WrapMode, "UInt*", LGpBrush)
	Return, LGpBrush
}

Gdip_CloneBrush(pBrush)
{
	static pNewBrush
	VarSetCapacity(pNewBrush, 288, 0)
	DllCall("RtlMoveMemory", "UInt", &pNewBrush, "UInt", pBrush, "UInt", 288)
	VarSetCapacity(pNewBrush, -1)
	return &pNewBrush
}

;#####################################################################################
; Delete resources
;#####################################################################################

Gdip_DeletePen(pPen)
{
   Return, DllCall("gdiplus\GdipDeletePen", "UInt", pPen)
}

Gdip_DeleteBrush(pBrush)
{
   Return, DllCall("gdiplus\GdipDeleteBrush", "UInt", pBrush)
}

Gdip_DisposeImage(pBitmap)
{
   Return, DllCall("gdiplus\GdipDisposeImage", "UInt", pBitmap)
}

Gdip_DeleteGraphics(pGraphics)
{
   Return, DllCall("gdiplus\GdipDeleteGraphics", "UInt", pGraphics)
}

Gdip_DisposeImageAttributes(ImageAttr)
{
	Return, DllCall("gdiplus\GdipDisposeImageAttributes", "UInt", ImageAttr)
}

Gdip_DeleteFont(hFont)
{
   Return, DllCall("gdiplus\GdipDeleteFont", "UInt", hFont)
}

Gdip_DeleteStringFormat(hFormat)
{
   Return, DllCall("gdiplus\GdipDeleteStringFormat", "UInt", hFormat)
}

Gdip_DeleteFontFamily(hFamily)
{
   Return, DllCall("gdiplus\GdipDeleteFontFamily", "UInt", hFamily)
}

Gdip_DeleteMatrix(Matrix)
{
   Return, DllCall("gdiplus\GdipDeleteMatrix", "UInt", Matrix)
}

;#####################################################################################
; Text functions
;#####################################################################################

Gdip_TextToGraphics(pGraphics, Text, Options, Font="Arial", Width="", Height="", Measure=0)
{
	IWidth := Width, IHeight:= Height
	
	RegExMatch(Options, "i)X([\-\d\.]+)(p*)", xpos)
	RegExMatch(Options, "i)Y([\-\d\.]+)(p*)", ypos)
	RegExMatch(Options, "i)W([\-\d\.]+)(p*)", Width)
	RegExMatch(Options, "i)H([\-\d\.]+)(p*)", Height)
	RegExMatch(Options, "i)C(?!(entre|enter))([a-f\d]+)", Colour)
	RegExMatch(Options, "i)Top|Up|Bottom|Down|vCentre|vCenter", vPos)
	RegExMatch(Options, "i)R(\d)", Rendering)
	RegExMatch(Options, "i)S(\d+)(p*)", Size)

	if !Gdip_DeleteBrush(Gdip_CloneBrush(Colour2))
		PassBrush := 1, pBrush := Colour2
	
	If !(IWidth && IHeight) && (xpos2 || ypos2 || Width2 || Height2 || Size2)
	Return, -1

	Style := 0, Styles := "Regular|Bold|Italic|BoldItalic|Underline|Strikeout"
	Loop, Parse, Styles, |
	{
		If RegExMatch(Options, "\b" A_loopField)
		Style |= (A_LoopField != "StrikeOut") ? (A_Index-1) : 8
	}
  
	Align := 0, Alignments := "Near|Left|Centre|Center|Far|Right"
	Loop, Parse, Alignments, |
	{
		If RegExMatch(Options, "\b" A_loopField)
		Align |= A_Index//2.1      ; 0|0|1|1|2|2
	}

	xpos := (xpos1 != "") ? xpos2 ? IWidth*(xpos1/100) : xpos1 : 0
	ypos := (ypos1 != "") ? ypos2 ? IHeight*(ypos1/100) : ypos1 : 0
	Width := Width1 ? Width2 ? IWidth*(Width1/100) : Width1 : IWidth
	Height := Height1 ? Height2 ? IHeight*(Height1/100) : Height1 : IHeight
	if !PassBrush
		Colour := "0x" (Colour2 ? Colour2 : "ff000000")
	Rendering := ((Rendering1 >= 0) && (Rendering1 <= 4)) ? Rendering1 : 4
	Size := (Size1 > 0) ? Size2 ? IHeight*(Size1/100) : Size1 : 12

	hFamily := Gdip_FontFamilyCreate(Font)
	hFont := Gdip_FontCreate(hFamily, Size, Style)
	hFormat := Gdip_StringFormatCreate(0x4000)
	pBrush := PassBrush ? pBrush : Gdip_BrushCreateSolid(Colour)
	If !(hFamily && hFont && hFormat && pBrush && pGraphics)
	Return, !pGraphics ? -2 : !hFamily ? -3 : !hFont ? -4 : !hFormat ? -5 : !pBrush ? -6 : 0
   
	CreateRectF(RC, xpos, ypos, Width, Height)
	Gdip_SetStringFormatAlign(hFormat, Align)
	Gdip_SetTextRenderingHint(pGraphics, Rendering)
	ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, RC)

	If vPos
	{
		StringSplit, ReturnRC, ReturnRC, |
		
		If (vPos = "vCentre") || (vPos = "vCenter")
		ypos := (Height-ReturnRC4)//2
		Else If (vPos = "Top") || (vPos = "Up")
		ypos := 0
		Else If (vPos = "Bottom") || (vPos = "Down")
		ypos := Height-ReturnRC4
		
		CreateRectF(RC, xpos, ypos, Width, ReturnRC4)
		ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, RC)
	}

	if !Measure
		E := Gdip_DrawString(pGraphics, Text, hFont, hFormat, pBrush, RC)

	if !PassBrush
		Gdip_DeleteBrush(pBrush)
	Gdip_DeleteStringFormat(hFormat)   
	Gdip_DeleteFont(hFont)
	Gdip_DeleteFontFamily(hFamily)
	Return, E ? E : ReturnRC
}

Gdip_DrawString(pGraphics, sString, hFont, hFormat, pBrush, ByRef RectF)
{
   nSize := DllCall("MultiByteToWideChar", "UInt", 0, "UInt", 0, "UInt", &sString, "Int", -1, "UInt", 0, "Int", 0)
   VarSetCapacity(wString, nSize*2)
   DllCall("MultiByteToWideChar", "UInt", 0, "UInt", 0, "UInt", &sString, "Int", -1, "UInt", &wString, "Int", nSize)
   Return, DllCall("gdiplus\GdipDrawString", "UInt", pGraphics, "UInt", &wString, "Int", -1, "UInt", hFont, "UInt", &RectF, "UInt", hFormat, "UInt", pBrush)
}

Gdip_MeasureString(pGraphics, sString, hFont, hFormat, ByRef RectF)
{
   nSize := DllCall("MultiByteToWideChar", "UInt", 0, "UInt", 0, "UInt", &sString, "Int", -1, "UInt", 0, "Int", 0)
   VarSetCapacity(wString, nSize*2)   
   DllCall("MultiByteToWideChar", "UInt", 0, "UInt", 0, "UInt", &sString, "Int", -1, "UInt", &wString, "Int", nSize)
   VarSetCapacity(RC, 16)   
   DllCall("gdiplus\GdipMeasureString", "UInt", pGraphics, "UInt", &wString, "Int", -1, "UInt", hFont, "UInt", &RectF, "UInt", hFormat, "UInt", &RC, "UInt*", Chars, "UInt*", Lines)
   Return, &RC ? NumGet(RC, 0, "Float") "|" NumGet(RC, 4, "Float") "|" NumGet(RC, 8, "Float") "|" NumGet(RC, 12, "Float") "|" Chars "|" Lines : 0
}

; Near = 0
; Center = 1
; Far = 2
Gdip_SetStringFormatAlign(hFormat, Align)
{
   Return, DllCall("gdiplus\GdipSetStringFormatAlign", "UInt", hFormat, "Int", Align)
}

Gdip_StringFormatCreate(Format=0, Lang=0)
{
   DllCall("gdiplus\GdipCreateStringFormat", "Int", Format, "Int", Lang, "UInt*", hFormat)
   Return, hFormat
}

; Regular = 0
; Bold = 1
; Italic = 2
; BoldItalic = 3
; Underline = 4
; Strikeout = 8
Gdip_FontCreate(hFamily, Size, Style=0)
{
   DllCall("gdiplus\GdipCreateFont", "UInt", hFamily, "Float", Size, "Int", Style, "Int", 0, "UInt*", hFont)
   Return, hFont
}

Gdip_FontFamilyCreate(Font)
{
   nSize := DllCall("MultiByteToWideChar", "UInt", 0, "UInt", 0, "UInt", &Font, "Int", -1, "UInt", 0, "Int", 0)
   VarSetCapacity(wFont, nSize*2)
   DllCall("MultiByteToWideChar", "UInt", 0, "UInt", 0, "UInt", &Font, "Int", -1, "UInt", &wFont, "Int", nSize)

   DllCall("gdiplus\GdipCreateFontFamilyFromName", "UInt", &wFont, "UInt", 0, "UInt*", hFamily)
   Return, hFamily
}

;#####################################################################################
; Matrix functions
;#####################################################################################

Gdip_CreateAffineMatrix(m11, m12, m21, m22, x, y)
{
   DllCall("gdiplus\GdipCreateMatrix2", "Float", m11, "Float", m12, "Float", m21, "Float", m22, "Float", x, "Float", y, "UInt*", Matrix)
   Return, Matrix
}

Gdip_CreateMatrix()
{
   DllCall("gdiplus\GdipCreateMatrix", "UInt*", Matrix)
   Return, Matrix
}

;#####################################################################################
; GraphicsPath functions
;#####################################################################################

; Alternate = 0
; Winding = 1
Gdip_CreatePath(BrushMode=0)
{
	DllCall("gdiplus\GdipCreatePath", "Int", BrushMode, "UInt*", Path)
	Return, Path
}

Gdip_AddPathEllipse(Path, x, y, w, h)
{
   Return, DllCall("gdiplus\GdipAddPathEllipse", "UInt", Path, "Float", x, "Float", y, "Float", w, "Float", h)
}

Gdip_AddPathPolygon(Path, Points)
{
	StringSplit, Points, Points, |
	VarSetCapacity(PointF, 8*Points0)   
	Loop, %Points0%
	{
		StringSplit, Coord, Points%A_Index%, `,
		NumPut(Coord1, PointF, 8*(A_Index-1), "Float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "Float")
	}   

   Return, DllCall("gdiplus\GdipAddPathPolygon", "UInt", Path, "UInt", &PointF, "Int", Points0)
}

Gdip_DeletePath(Path)
{
	Return, DllCall("gdiplus\GdipDeletePath", "UInt", Path)
}

;#####################################################################################
; Quality functions
;#####################################################################################

; SystemDefault = 0
; SingleBitPerPixelGridFit = 1
; SingleBitPerPixel = 2
; AntiAliasGridFit = 3
; AntiAlias = 4
Gdip_SetTextRenderingHint(pGraphics, RenderingHint)
{
   Return, DllCall("gdiplus\GdipSetTextRenderingHint", "UInt", pGraphics, "Int", RenderingHint)
}

; Default = 0
; LowQuality = 1
; HighQuality = 2
; Bilinear = 3
; Bicubic = 4
; NearestNeighbor = 5
; HighQualityBilinear = 6
; HighQualityBicubic = 7
Gdip_SetInterpolationMode(pGraphics, InterpolationMode)
{
   Return, DllCall("gdiplus\GdipSetInterpolationMode", "UInt", pGraphics, "Int", InterpolationMode)
}

; Default = 0
; HighSpeed = 1
; HighQuality = 2
; None = 3
; AntiAlias = 4
Gdip_SetSmoothingMode(pGraphics, SmoothingMode)
{
   Return, DllCall("gdiplus\GdipSetSmoothingMode", "UInt", pGraphics, "Int", SmoothingMode)
}

; CompositingModeSourceOver = 0 (blended)
; CompositingModeSourceCopy = 1 (overwrite)
Gdip_SetCompositingMode(pGraphics, CompositingMode=0)
{
   Return, DllCall("gdiplus\GdipSetCompositingMode", "UInt", pGraphics, "Int", CompositingMode)
}

;#####################################################################################
; Extra functions
;#####################################################################################

Gdip_Startup()
{
   If !DllCall("GetModuleHandle", "Str", "gdiplus")
   DllCall("LoadLibrary", "Str", "gdiplus")
   VarSetCapacity(si, 16, 0), si := Chr(1)
   DllCall("gdiplus\GdiplusStartup", "UInt*", pToken, "UInt", &si, "UInt", 0)
   Return, pToken
}

Gdip_Shutdown(pToken)
{
   DllCall("gdiplus\GdiplusShutdown", "UInt", pToken)
   If hModule := DllCall("GetModuleHandle", "Str", "gdiplus")
   DllCall("FreeLibrary", "UInt", hModule)
   Return, 0
}

; Prepend = 0; The new operation is applied before the old operation.
; Append = 1; The new operation is applied after the old operation.
Gdip_RotateWorldTransform(pGraphics, Angle, MatrixOrder=0)
{
	Return, DllCall("gdiplus\GdipRotateWorldTransform", "UInt", pGraphics, "Float", Angle, "Int", MatrixOrder)
}

Gdip_ScaleWorldTransform(pGraphics, x, y, MatrixOrder=0)
{
	Return, DllCall("gdiplus\GdipScaleWorldTransform", "UInt", pGraphics, "Float", x, "Float", y, "Int", MatrixOrder)
}

Gdip_TranslateWorldTransform(pGraphics, x, y, MatrixOrder=0)
{
	Return, DllCall("gdiplus\GdipTranslateWorldTransform", "UInt", pGraphics, "Float", x, "Float", y, "Int", MatrixOrder)
}

Gdip_ResetWorldTransform(pGraphics)
{
	Return, DllCall("gdiplus\GdipResetWorldTransform", "UInt", pGraphics)
}

Gdip_GetRotatedTranslation(Width, Height, Angle, ByRef xTranslation, ByRef yTranslation)
{
	pi := 4*ATan(1), TAngle := Angle*(pi/180)	

	Bound := (Angle >= 0) ? Mod(Angle, 360) : 360-Mod(-Angle, -360)
	If ((Bound >= 0) && (Bound <= 90))
	xTranslation := Height*Sin(TAngle), yTranslation := 0
	Else If ((Bound > 90) && (Bound <= 180))
	xTranslation := (Height*Sin(TAngle))-(Width*Cos(TAngle)), yTranslation := -Height*Cos(TAngle)
	Else If ((Bound > 180) && (Bound <= 270))
	xTranslation := -(Width*Cos(TAngle)), yTranslation := -(Height*Cos(TAngle))-(Width*Sin(TAngle))
	Else If ((Bound > 270) && (Bound <= 360))
	xTranslation := 0, yTranslation := -Width*Sin(TAngle)
}

Gdip_GetRotatedDimensions(Width, Height, Angle, ByRef RWidth, ByRef RHeight)
{
	pi := 4*ATan(1), TAngle := Angle*(pi/180)
	If !(Width && Height)
	Return, -1
	RWidth := Ceil(Abs(Width*Cos(TAngle))+Abs(Height*Sin(TAngle)))
	RHeight := Ceil(Abs(Width*Sin(TAngle))+Abs(Height*Cos(Tangle)))
}

; Replace = 0
; Intersect = 1
; Union = 2
; Xor = 3
; Exclude = 4
; Complement = 5
Gdip_SetClipRect(pGraphics, x, y, w, h, CombineMode=0)
{
   Return, DllCall("gdiplus\GdipSetClipRect", "UInt", pGraphics, "Float", x, "Float", y, "Float", w, "Float", h, "Int", CombineMode)
}

Gdip_SetClipPath(pGraphics, Path, CombineMode=0)
{
   Return, DllCall("gdiplus\GdipSetClipPath", "UInt", pGraphics, "UInt", Path, "Int", CombineMode)
}

Gdip_ResetClip(pGraphics)
{
   Return, DllCall("gdiplus\GdipResetClip", "UInt", pGraphics)
}

Gdip_GetClipRegion(pGraphics)
{
	Region := Gdip_CreateRegion()
	DllCall("gdiplus\GdipGetClip", "UInt" pGraphics, "UInt*", Region)
	Return, Region
}

Gdip_SetClipRegion(pGraphics, Region, CombineMode=0)
{
	Return, DllCall("gdiplus\GdipSetClipRegion", "UInt", pGraphics, "UInt", Region, "Int", CombineMode)
}

Gdip_CreateRegion()
{
	DllCall("gdiplus\GdipCreateRegion", "UInt*", Region)
	Return, Region
}

Gdip_DeleteRegion(Region)
{
	Return, DllCall("gdiplus\GdipDeleteRegion", "UInt", Region)
}
