#include FcnLib.ahk

; heart form for your girl friend...
; formR1:="0,-20,8,-28,20,-28,28,-20,28,-8,16,12,0,28,-16,12,-28,-8,-28,-20,-20,-28,-8,-28,0,-20"
; formR2:="0,-10,4,-14,10,-14,14,-10,14,-4,8,6,0,14,-8,6,-14,-4,-14,-10,-10,-14,-4,-14,0,-10"
; formR3:="0,-5,2,-7,5,-7,7,-5,7,-2,4,3,0,7,-4,3,-7,-2,-7,-5,-5,-7,-2,-7,0,-5"

#SingleInstance Force
#Persistent
#NoEnv
Process, Priority, , High
SetBatchLines, -1
OnExit, ExitSub

;if !( hModule := DllCall("GetModuleHandle", "str", "gdi32") )
;  hModule := DllCall("LoadLibrary", "Str", "gdi32")

hModule := DllCall("GetModuleHandle", "str", "gdi32")
PtInRegion := DllCall("GetProcAddress" ,"uint", hModule, str,"PtInRegion")
CombineRgn := DllCall("GetProcAddress" ,"uint", hModule,str,"CombineRgn")
Polyline := DllCall("GetProcAddress" ,"uint", hModule, str,"Polyline")
CreatePolygonRgn := DllCall("GetProcAddress" ,"uint", hModule,str,"CreatePolygonRgn")
DeleteObject := DllCall("GetProcAddress" ,"uint", hModule, str,"DeleteObject")

Left:="Left"        ; turn left
Right:="Right"      ; turn right
Up:="Up"            ; move forward
Down:="Down"        ; move backward
Space:="Space"      ; use weapon

VarSetCapacity(ptWin, 16, 0)
NumPut(W:=512, ptWin, 8) , NumPut(H:=384, ptWin, 12)
Gui, Show, w%W% h%H%, Ahkroid
  hdcWin := DllCall("GetDC", "uint", hwnd:=WinExist("A"))
  hdcMem := DllCall("CreateCompatibleDC", "uint", hdcWin)
  hbm := DllCall("CreateCompatibleBitmap", "uint", hdcWin, "int", W, "int", H)
DllCall("SelectObject", "uint", hdcMem, "uint", hbm)



hFont1:=DllCall("CreateFont", "int", 0, "int", 0, "int", 0, "int", 0, "int", 700
  ,"uint",0,"uint",0,"uint",0,"uint",0,"uint",0,"uint",0,"uint",0,"uint",0,"str", "MS sans serif")
hFont2:=DllCall("CreateFont", "int", -24, "int", 0, "int", 0, "int", 0, "int", 700
  ,"uint",0,"uint",0,"uint",0,"uint",0,"uint",0,"uint",0,"uint",0,"uint",0,"str", "MS sans serif")
DllCall("SetTextColor",  "uint", hdcMem, "uint", 0xFFFFFF)
DllCall("SetBkColor",  "uint", hdcMem, "uint", 0x000000)



hbW:=DllCall("CreateSolidBrush", "uint", 0x000000)
hbG:=DllCall("CreateSolidBrush", "uint", 0x008000)
hb:=DllCall("CreateSolidBrush", "uint", 0xC0C0C0)

hPen:=DllCall("CreatePen", "uint", 0, "uint", 1, "uint", 0xFFFFFF)
DllCall("SelectObject", "uint", hdcMem, "uint", hPen)

X:=W/2 , Y:=H/2 , Vx:=Vy:=Va:=cd:=0 , score:=20000 , shield:="||||||||||" , nRoid:=10
  formS:="3,0,10,5,0,-15,-10,5,-3,0,0,5,3,0"
VarSetCapacity(ptShip, 56)

  formB:="-1,0,0,-1,1,0,0,1,-1,0"
VarSetCapacity(ptBall, 40)


  formR1:="-12,-28,0,-20,16,-28,28,-16,16,-8,28,8,12,28,-8,20,-16,28,-28,16,-20,0,-28,-16,-12,-28"
  formR2:="-6,-14,0,-10,8,-14,14,-8,8,-4,14,4,6,14,-4,10,-8,14,-14,8,-10,0,-14,-8,-6,-14"
  formR3:="-3,-7,-0,-5,4,-7,7,-4,4,-2,7,2,3,7,-2,5,-4,7,-7,4,-5,0,-7,-4  ,-3,-7"

; -2,-7,3,-7,7,-2,7,0.5,2,7,-2,7,-1,1,-4,7,-7,2,-4,0,-7,-2
; -4,-7,-0,-4,3.5,-7,7,-4,5,-0.5,7,3,1,7,-4,7,-7,4,-7,-4
; -3.5,-7,1.5,-7,7,-3.5,7,-2,0.5,0,7,3.5,3.5,7,1,5,-4,7,-7,2,-7,-3.5,-1.5,-3.5

formR11:="-2,-7,3,-7,7,-2,7,1,2,7,-2,7,-1,2,-4,7,-7,2,-4,0,-7,-2,-2,-7,-2,-7"
formR21:="-4,-7,0,-4,4,-7,7,-4,5,-1,7,3,1,7,-4,7,-7,4,-7,-4,-4,-7,-4,-7,-4,-7"
formR31:="-4,-7,2,-7,7,-4,7,-2,2,0,7,4,4,7,1,5,-4,7,-7,2,-7,-4,-2,-4,-4,-7"
formR41:="-3,-7,-0,-5,4,-7,7,-4,4,-2,7,2,3,7,-2,5,-4,7,-7,4,-5,0,-7,-4,-3,-7"

VarSetCapacity(ptRoid, 104)
loop %nRoid%
  listRoid .= "|1," rand(0, W, X) "," rand(0, H, Y) "," rand(0.0, 6)-3 "," rand(0.0, 6)-3

SetTimer, Update, 25
return

; --------------------------------

Update:
Critical

DllCall("SelectObject", "uint", hdcMem, "uint", hbW)
DllCall("FillRect", "uint", hdcMem, "uint", &ptWin, "uint", 0)

DllCall("SelectObject", "uint", hdcMem, "uint", hFont1)
DllCall("TextOut", "uint", hdcMem, "uint", 16, "uint", 8, "uint", &score, "uint", StrLen(score))
DllCall("TextOut", "uint", hdcMem, "uint", 16, "uint", 24, "uint", &shield, "uint", StrLen(shield))

DllCall("SelectObject", "uint", hdcMem, "uint", hFont2)

;test:="GAME OVER PUSH START"
test:=a_tickcount - fps
fps:=a_tickcount

DllCall("TextOut", "uint", hdcMem, "uint", 0, "uint", H/2-20, "uint", &test, "uint", StrLen(test)) ;W/2-100

; ----

;Va1:=""
;Va2 := GetKeyState(Left) ? Va2*0.5-(3.14/180)*1 : GetKeyState(Right) ? Va2*0.5+(3.14/180)*1 : 0
;Va+=Va2

Va += GetKeyState(Left) ? -0.1 : GetKeyState(Right) ? 0.1 : 0

if Va2
 {
county++
  tooltip %Va%*%Va2%*%county%
}
else
county:=0

formS0:=""
loop, parse, formS, `,
  a_index & 1 ? i1:=a_loopfield : formS0 .= i1*cos(Va)-a_loopfield*sin(Va) "," i1*sin(Va)+a_loopfield*cos(Va) ","

Vs := GetKeyState(Up) ? 0.3 : GetKeyState(Down) ? -0.15 : 0
Vx:=Vx*0.96+sin(Va)*Vs , Vy:=Vy*0.96-cos(Va)*Vs
X:= X<0 ? W : X>W ? 0 : X+Vx , Y:= Y<0 ? H : Y>H ? 0 : Y+Vy

DllCall("DeleteObject", "UInt", hShip)
loop, parse, formS0, `,
    NumPut(a_loopfield+(a_index & 1 ? X : Y), ptShip, a_index*4-4)

burn:=!burn
if (Vs>0 && burn)
  DllCall("Polyline", "uint", hdcMem, "uint", &ptShip+32, "int", 3)

DllCall("SelectObject", "uint", hdcMem, "uint", hbG)
DllCall("Polygon", "uint", hdcMem, "uint", &ptShip, "int", 5)
hShip := DllCall("CreatePolygonRgn", "uint", &ptShip, "int", 5, "int", 1)

; ----

cd-= cd>0 ? 1 : 0
if ( GetKeyState(Space) && cd=0 ) {
;cd:= score>10000 ? 6 : score>5000 ? 4 : 2
cd:=5
  if(score<=5000 || score>10000)
    listBall .= "|" a_tickcount "," X+sin(Va)*10 "," Y-cos(Va)*10 "," Va
  if (score>5000) {
    listBall .= "|" a_tickcount "," X+sin(Va+1.57)*5 "," Y-cos(Va+1.57)*5 "," Va+(score>10000 ? 0.1 : 0)
    listBall .= "|" a_tickcount "," X+sin(Va-1.57)*5 "," Y-cos(Va-1.57)*5 "," Va-(score>10000 ? 0.1 : 0)
  }
}

loop, parse, listBall, |
{
  if a_index=1
    continue
  loop, parse, a_loopfield, `,
    i%a_index%:=a_loopfield
  if (i1+900 < a_tickcount) {
    StringReplace, listBall, listBall, % "|" i1 "," i2 "," i3 "," i4 ,
    continue
  }
    iX:=i2+sin(i4)*8 , iY:=i3-cos(i4)*8
    iX:= iX<0 ? W : iX>W ? 0 : iX , iY:= iY<0 ? H : iY>H ? 0 : iY
    StringReplace, listBall, listBall, % "|" i1 "," i2 "," i3 "," i4 , % "|" i1 "," iX "," iY "," i4
    loop, parse, formB, `,
      NumPut(a_loopfield+(a_index & 1 ? iX : iY), ptBall, a_index*4-4)
    DllCall("Polyline", "uint", hdcMem, "uint", &ptBall, "int", 5)
}

; ----

loop, parse, listRoid, |
{
  id:=a_index-1
  if a_index=1
    continue
  loop, parse, a_loopfield, `,
    i%a_index%:=a_loopfield
  iX:= i2+i4<0 ? W : i2+i4>W ? 0 : i2+i4 , iY:= i3+i5<0 ? H : i3+i5>H ? 0 : i3+i5
  StringReplace, listRoid, listRoid, % "|" i1 "," i2 "," i3 "," i4 "," i5 , % "|" i1 "," iX "," iY "," i4 "," i5
  loop, parse, formR%i1%, `,
    NumPut(a_loopfield+(a_index & 1 ? iX : iY), ptRoid, a_index*4-4)
  DllCall(Polyline, "uint", hdcMem, "uint", &ptRoid, "int", 13)
;DllCall("SelectObject", "uint", hdcMem, "uint", hb)
;DllCall("Polygon", "uint", hdcMem, "uint", &ptRoid, "int", 12)
  hRoid := DllCall(CreatePolygonRgn, "uint", &ptRoid, "int", 12, "int", 1)

  loop, parse, listBall, |
  {
    if a_index=1
      continue
    loop, parse, a_loopfield, `,
      t%a_index%:=a_loopfield
    if ( DllCall(PtInRegion, "uint", hRoid, "uint", t2, "uint", t3) <> 0 )
    {
      StringReplace, listBall, listBall, % "|" t1 "," t2 "," t3 "," t4 ,
      StringReplace, listRoid, listRoid, % "|" i1 "," iX "," iY "," i4 "," i5 ,
      score+=i1*5
      if (i1<3) {
        i1++
        loop 2
          listRoid .= "|" i1 "," iX "," iY "," rand(0.0, 6)-3 "," rand(0.0, 6)-3
      continue
      }
    }
  }

  if ( DllCall(CombineRgn, "uint", hRoid, "uint", hRoid, "uint", hShip, "int", 1) <> 1 ) {
  Vx:=i4 , Vy:=i5
  shield := SubStr(shield, 1, -1)
    if (shield="") {
      msgbox %score% points
      Reload
    }
  StringReplace, listRoid, listRoid, % "|" i1 "," iX "," iY "," i4 "," i5 ,
    if (i1<3) {
      i1++
      loop 2
        listRoid .= "|" i1 "," iX "," iY "," rand(0.0, 6)-3 "," rand(0.0, 6)-3
    }
  }

DllCall(DeleteObject, "uint", hRoid)
}

; -----

if (id<nRoid-1) {
nRoid++ , shield.="|"
loop %nRoid%
  listRoid .= "|1," rand(0, W, X) "," rand(0, H, Y) "," rand(0.0, 6)-3 "," rand(0.0, 6)-3
}

DllCall("BitBlt", "uint", hdcWin, "int", 0, "int", 0, "int", W, "int", H, "uint", hdcMem, "int", 0, "int", 0, "uint", 0xCC0020)
return

; --------------------------------

Rand(min=0, max=1, mask="") {
loop {
  Random, result, min, max
  if ( mask="" || result<mask-100 || result>mask+100 )
    return result
  }
}

ExitSub:
guiclose:
DllCall("DeleteObject", "UInt", hFont1)
DllCall("DeleteObject", "UInt", hFont2)
DllCall("DeleteObject", "UInt", hPen)
DllCall("DeleteObject", "UInt", hbW)
DllCall("DeleteObject", "UInt", hbG)
DllCall("DeleteObject", "UInt", hb)
DllCall("DeleteObject", "UInt", hShip)
DllCall("DeleteObject", "UInt", hRoid)
DllCall("DeleteObject", "UInt", hbm)
DllCall("DeleteDC", "UInt", hdcMem)
DllCall("ReleaseDC", "UInt", hwnd, "UInt", hdcWin)
;DllCall("FreeLibrary", "UInt", hModule)
exitapp

