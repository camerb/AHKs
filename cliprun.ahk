#include FcnLib.ahk

Gosub, Razza
Gui, Add, dropdownlist, x12 y50 w90 h20 R6 Choose1 gApplica vRazza, %ListaRazze%
;Gosub, Applica
Gui, Add, dropdownlist, x122 y50 w90 h20 Choose1 vSottoRazza , %ListaSubRazze%
Gui, Show, x206 y105 h401 w482, Creatore di schede
return

Razza:
ListaRazze = ; Inizia Vuoto
Loop, %A_WorkingDir%\Razze\*.
	if ListaRazze =
		ListaRazze = %A_LoopFileName%
	else
		ListaRazze = %ListaRazze%|%A_LoopFileName%
Sort, FileList, R D| ; Ordina la lista per ordine inveRso e con | come separatore (D)
;MsgBox, %ListaRazze%
return

Applica:
Gui, Submit, NoHide
MsgBox, %Razza%
Loop
{
    FileReadLine, line, %A_WorkingDir%\Razze\%Razza%, %A_Index%
	{
		;MsgBox, %line%
		StringGetPos, pos, line, [
		if pos >= 0
		{
			pos =
			if ListaSubRazze =
				ListaSubRazze = %Line%
			else
				ListaSubRazze = %ListaSubRazze%|%Line%
			MsgBox, subrazze : %ListaSubRazze%
		}
		MsgBox, fine ciclo pos
	}
	MsgBox, fine ciclo leggi file
	
}
MsgBox, finito: %ListaSubRazze%
GuiControl, ,ComboBox2, %ListaSubRazze%
return






GuiClose:
ExitApp



 ~esc::ExitApp