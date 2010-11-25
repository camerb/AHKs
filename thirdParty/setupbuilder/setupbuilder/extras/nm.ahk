SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Gui, Margin, 0,0 
Gui, Add, Picture, x0 y0 w1024 h768, bg.bmp 
gui, font, s36 cBlack, Verdana
gui, add, text,x20 y20 backgroundtrans,Sajanpur
gui, font, s36 cWhite, Verdana
gui, add, text,x23 y23 backgroundtrans,Sajanpur
Gui, Show, AutoSize,  23e
Winmaximize,23e
Return 

GuiClose: 
GuiEscape: 
 ExitApp 
Return