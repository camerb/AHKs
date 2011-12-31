boardwidth := 420
boardheight := 400
allLetters = A,B,C,D,E,F,G,H,J,K,L,M,N,O,P,Q,R,S,T,U,V,X,Y,Z
Sort, allLetters, Random D,
VarSetCapacity(ptWin, 16, 0)
NumPut(boardWidth, ptWin, 8)
NumPut(boardHeight, ptWin, 12)
gui,color, 0xFFFFFF
gui,show, h%BoardHeight% w%BoardWidth% x50 y50, HoneyCombs
hdcWin := DllCall("GetDC", "UInt", hwnd:=WinExist("A"))
brBlack := DllCall("CreateSolidBrush", "Int", 0x000000)
brPurple := DllCall("CreateSolidBrush", "Int", 0xFF00FF)
brYellow := DllCall("CreateSolidBrush", "Int", 0x00FFFF)
Yellow := 0x00FFFF
Red := 0x0000FF
hFont:=DllCall("CreateFont", "int", 60, "int",30, "int", 0, "int", 0, "int", 600,"uint",0,"uint",0,"uint",0,"uint",1,"uint",0,"uint",0,"uint",0,"uint",0,"str", "Tahoma Regular")
DllCall("SelectObject", "uint", hdcWin, "uint", hFont)
DllCall("SetBkColor", "Int", hdcWin, "Int", Yellow)
DllCall("SetTextColor", "Int", hdcWin, "Int", Red)
gosub, draw_hexagons
return

draw_hexagons:
xpos := 60
ypos := 60
Loop, Parse, allLetters, csv
	{
		cletter = %A_Loopfield%
		LrgHex%A_Index% := A_Loopfield
		rgHex%A_Index% := CreateNewHexagon(xpos,ypos)
		DllCall("FillRgn", "UInt", hdcWin, "UInt", rgHex%A_Index%, "UInt", brYellow)
		DllCall("FrameRgn", "Uint", hdcWin, "UInt",rgHex%A_Index%, "UInt", brBlack, "Int", 2, "Int", 2)
		DllCall("TextOut", "Int", hdcWin, "UInt", xpos - 23, "UInt", ypos-25, "UInt", &cLetter, "UInt", 1)
		ypos += 80
		If (A_Index = 4)
			xpos += 74, ypos := 100
		else if (a_index = 8)
			xpos +=74, ypos := 60
		else if (a_index = 12)
			xpos +=74, ypos := 100
		else if (a_index = 16)
			xpos +=74, ypos := 60
		else if (a_index = 20)
			break
	}
return

;for testing only
d::
Random, rnum, 1, 20
MsgBox % "Region : " . rnum . " is letter " . LrgHex%rnum%
return


;for testing only
c::
MouseGetPos, mx, my
Loop, 20
		{
			if !(DllCall("PtInRegion", "UInt", rgHex%A_Index%, "Int", mx, "Int", my))
				Continue
			DllCall("FillRgn", "UInt", hdcWin, "UInt", rgHex%A_Index%, "UInt", brPurple)
			DllCall("FrameRgn", "Uint", hdcWin, "UInt",rgHex%A_Index%, "UInt", brBlack, "Int", 2, "Int", 2)
		}
return

esc::
GuiClose:
Loop, 20
	DllCall("DeleteObject", "UInt", rgHex%A_Index%)
DllCall("DeleteObject", "UInt", brBlack)
DllCall("DeleteObject", "UInt", brPurple)
DllCall("ReleaseDC", uint, hdcWin)
ExitApp

CreateNewHexagon(xpos, ypos)
{
		Hex := "-26,-42,26,-42,50,0,26,42,-26,42,-50,0,-26,-42"
		VarSetCapacity(ptHexagon, 88)
		loop, parse, Hex, `,
			NumPut(a_loopfield+(a_index & 1 ? xpos : ypos), ptHexagon, a_index*4-4)
		hname := DllCall("CreatePolygonRgn", "uint", &ptHexagon, "int", 12, "int", 1)
		return hname
}
return