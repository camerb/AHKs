#include FcnLib.ahk

ContextTeste:
Gui, 1:+Owner2
Gui, 2:Add, ListBox, x112 y0 w80 r10 , Ingles|Portugues|Matematica|E.M.R.C|Frances|Geometria|E. Fisica|Filosofia|Fis. Qui. A|Bio. Geo.
Gui, 2:Add, Button, x12 y30 w80 h30 gcalcmedia, Adicionar teste!
Gui, 2:Add, DateTime, x2 y0 w100 h20 , 
;------------------------------Datas---------------------------------
Gui, 2:Add, Text, x202 y0 w70 h20 +Border +Center, Data
Gui, 2:Add, Text, x202 y20 w70 h20 vteste1 +Border +Center,
Gui, 2:Add, Text, x202 y39 w70 h20 vteste2 +Border +Center,
Gui, 2:Add, Text, x202 y58 w70 h20 vteste3 +Border +Center,
Gui, 2:Add, Text, x202 y77 w70 h20 vteste4 +Border +Center,
Gui, 2:Add, Text, x202 y96 w70 h20 vteste5 +Border +Center,
Gui, 2:Add, Text, x202 y115 w70 h20 vteste6 +Border +Center,
;------------------------------Notas---------------------------------
Gui, 2:Add, Text, x271 y0 w70 h20 +Border +Center, Nota
Gui, 2:Add, Text, x271 y20 w70 h20 vnota1 +Border +Center,
Gui, 2:Add, Text, x271 y39 w70 h20 vnota2 +Border +Center,
Gui, 2:Add, Text, x271 y58 w70 h20 vnota3 +Border +Center,
Gui, 2:Add, Text, x271 y77 w70 h20 vnota4 +Border +Center,
Gui, 2:Add, Text, x271 y96 w70 h20 vnota5 +Border +Center,
Gui, 2:Add, Text, x271 y115 w70 h20 vnota6 +Border +Center,
;------------------------------Medias--------------------------------
Gui, 2:Add, Text, x341 y0 w70 h20 +Border +Center, Media
Gui, 2:Add, Text, x341 y115 w70 h20 vmedia +Border +Center, all.v/n

2tit = Datas de Testes, Marcar testes, Notas...
Gui, 2:+ToolWindow
Gui, 2:Show, h144 w418 , %2tit%
return

calcmedia:
;~IniRead, test1, %A_ScriptDir%\testes.ini, TESTE1
;~IniRead, not1, %A_ScriptDir%\testes.ini, NOTA1
;~ if ( test1 = "" )

GuiControl, 2:, teste1, %test1%
GuiControl, 2:, nota1, %not1%
IniRead, test2, %A_ScriptDir%\testes.ini, TESTE2
IniRead, not2, %A_ScriptDir%\testes.ini, NOTA2
GuiControl, 2:, teste2, %test2%
GuiControl, 2:, nota2, %not2%
IniRead, test3, %A_ScriptDir%\testes.ini, TESTE3
IniRead, not3, %A_ScriptDir%\testes.ini, NOTA3
GuiControl, 2:, teste3, %test3%
GuiControl, 2:, nota3, %not3%

media:
tcount = 3
Gui, 2:Submit, NoHide
;~ GuiControlGet,nota11, 2:, nota1
;~ GuiControlGet,nota22, 2:, nota2
;~ GuiControlGet,nota33, 2:, nota3
 

med := ( (nota11 + nota22 + nota33) / tcount )

MsgBox, %med% quando devia ser 17.33333333

return
2GuiClose:
Gui, Destroy



 ~esc::ExitApp