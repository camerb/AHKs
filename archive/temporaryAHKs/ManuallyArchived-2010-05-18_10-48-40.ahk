#include FcnLib.ahk

;Stuff to test FileEqual

;joe:=true
;debugbool(joe)

;joe:=false
;debugbool(joe)

;filename1=template.ahk
;filename2=temporary9.ahk

   ;FileRead, file1, %filename1%
   ;FileRead, file2, %filename2%

;debugbool(file1==file2)
;file1=afsdg
;debugbool(file1==file2)

;debug(file2)

joe:=IsFileEqual("template.ahk", "temporary9.ahk")
debugbool(joe)
joe:=IsFileEqual("temporary1.ahk", "temporary9.ahk")
debugbool(joe)
