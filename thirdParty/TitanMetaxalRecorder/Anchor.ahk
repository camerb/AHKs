/*
	Function: Anchor
	
	Defines how controls should be automatically positioned
	relatively to the new dimensions of a GUI when resized.
	
	Parameters:
		cl - a control HWND, associated variable name or ClassNN to operate on
		a - one or more of the anchors: 'x', 'y', 'w' (width) and 'h' (height),
				optionally followed by a relative factor, e.g. x h0.5
		r - true to redraw controls i.e. for GroupBox and Button types
	
	About: Examples
		- xy: bounds a control to the bottom-left edge of the window
		- w0.5: any change in the width of the window will resize
						the width of the control on a 2:1 (1:0.5) pixel ratio
		- h: same as the above but on a 1:1 ratio for height
	
	About: License
		- Version 4.1 by Titan <http://www.autohotkey.net/~Titan/#anchor>
		- GNU General Public License 3.0 or higher <http://www.gnu.org/licenses/gpl-3.0.txt>

*/

Anchor(cl, a = "", r = false) {
	static d, g, sd = 12, sg := 13, sc = 0, k = 0xffff, iz = 0, bx, by
	If !iz
		iz := 1, VarSetCapacity(g, sg * 99, 0), VarSetCapacity(d, sd * 200, 0)
	Gui, %A_Gui%:+LastFound
	If cl is xdigit
		c = %cl%
	Else {
		GuiControlGet, c, Hwnd, %cl%
		If ErrorLevel
			ControlGet, c, Hwnd, , %cl%
	}
	If !(A_Gui or c) and a
		Return
	cg := (A_Gui - 1) * sg
	Loop, %sc%
		If NumGet(d, z := (A_Index - 1) * sd) = c {
			p := NumGet(d, z + 4, "UInt64"), l := 1
				, x := p >> 48, y := p >> 32 & k, w := p >> 16 & k, h := p & k
				, gw := (gh := NumGet(g, cg + 1)) >> 16, gh &= k
			If a =
				Break
			Loop, Parse, a, xywh
				If A_Index > 1
				{
					v := SubStr(a, l, 1)
					If v in y,h
						n := A_GuiHeight - gh
					Else n := A_GuiWidth - gw
					b = %A_LoopField%
					%v% += n * (b + 0 ? b : 1), l += StrLen(A_LoopField) + 1
				}
				DllCall("SetWindowPos", "UInt", c, "Int", 0
					, "Int", x, "Int", y, "Int", w, "Int", h, "Int", 4)
				If r
					VarSetCapacity(rc, 16, 0), NumPut(x, rc, 0, "Int"), NumPut(y, rc, 4, "Int")
						, NumPut(w + x, rc, 8, "Int"), NumPut(h + y, rc, 12, "Int")
						, DllCall("InvalidateRect", "UInt", WinExist(), "UInt", &rc, "UInt", true)
				Return
		}
	ControlGetPos, x, y, w, h, , ahk_id %c%
	If !p {
		If NumGet(g, cg, "UChar") != A_Gui {
			WinGetPos, , , , gh
			gh -= A_GuiHeight
			VarSetCapacity(bdr, 63, 0)
				, DllCall("GetWindowInfo", "UInt", WinExist(), "UInt", &bdr)
				, NumPut(A_Gui, g, cg, "UChar")
				, NumPut(A_GuiWidth << 16 | A_GuiHeight, g, cg + 1, "UInt")
				,  NumPut((bx := NumGet(bdr, 48)) << 32
				| (by := gh - NumGet(bdr, 52)), g, cg + 5, "UInt64")
		}
		Else b := NumGet(g, cg + 5, "UInt64"), bx := b >> 32, by := b & 0xffffffff
	}
	s := x - bx << 48 | y - by << 32 | w << 16 | h
	If p
		NumPut(s, d, z + 4, "UInt64")
	Else NumPut(c, d, sc * 12), NumPut(s, d, sc * 12 + 4, "UInt64"), sc++
}
