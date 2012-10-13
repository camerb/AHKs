#include FcnLib.ahk

;transfer all minecraft items into chest that is currently opened

WinMove, Minecraft ahk_class SunAwtFrame, , 529, 253, 862, 514

WinWait, Minecraft,
IfWinNotActive, Minecraft, , WinActivate, Minecraft,
WinWaitActive, Minecraft,
MouseClick, left,  288,  342
Sleep, 100
MouseClick, left,  289,  286
Sleep, 100
MouseClick, left,  280,  378
Sleep, 100
MouseClick, left,  287,  244
Sleep, 100
MouseClick, left,  279,  415
Sleep, 100
MouseClick, left,  280,  196
Sleep, 100
MouseClick, left,  282,  455
Sleep, 100
MouseClick, left,  281,  171
Sleep, 100
MouseClick, left,  316,  340
Sleep, 100
MouseClick, left,  320,  279
Sleep, 100
MouseClick, left,  317,  370
Sleep, 100
MouseClick, left,  315,  238
Sleep, 100
MouseClick, left,  325,  412
Sleep, 100
MouseClick, left,  321,  214
Sleep, 100
MouseClick, left,  330,  466
Sleep, 100
MouseClick, left,  327,  174
Sleep, 100
MouseClick, left,  357,  341
Sleep, 100
MouseClick, left,  356,  272
Sleep, 100
MouseClick, left,  362,  378
Sleep, 100
MouseClick, left,  361,  247
Sleep, 100
MouseClick, left,  360,  410
Sleep, 100
MouseClick, left,  353,  207
Sleep, 100
MouseClick, left,  352,  452
Sleep, 100
MouseClick, left,  353,  178
Sleep, 100
MouseClick, left,  402,  340
Sleep, 100
MouseClick, left,  394,  283
Sleep, 100
MouseClick, left,  394,  389
Sleep, 100
MouseClick, left,  392,  239
Sleep, 100
MouseClick, left,  393,  418
Sleep, 100
MouseClick, left,  394,  216
Sleep, 100
MouseClick, left,  392,  466
Sleep, 100
MouseClick, left,  397,  173
Sleep, 100
MouseClick, left,  437,  337
Sleep, 100
MouseClick, left,  433,  281
Sleep, 100
MouseClick, left,  433,  375
Sleep, 100
MouseClick, left,  428,  242
Sleep, 100
MouseClick, left,  433,  414
Sleep, 100
MouseClick, left,  425,  203
Sleep, 100
MouseClick, left,  433,  450
Sleep, 100
MouseClick, left,  431,  178
Sleep, 100
MouseClick, left,  467,  340
Sleep, 100
MouseClick, left,  461,  277
Sleep, 100
MouseClick, left,  463,  373
Sleep, 100
MouseClick, left,  465,  241
Sleep, 100
MouseClick, left,  471,  412
Sleep, 100
MouseClick, left,  466,  208
Sleep, 100
MouseClick, left,  469,  447
Sleep, 100
MouseClick, left,  464,  173
Sleep, 100
MouseClick, left,  505,  340
Sleep, 100
MouseClick, left,  500,  270
Sleep, 100
MouseClick, left,  504,  383
Sleep, 100
MouseClick, left,  504,  240
Sleep, 100
MouseClick, left,  506,  415
Sleep, 100
MouseClick, left,  497,  208
Sleep, 100
MouseClick, left,  504,  462
Sleep, 100
MouseClick, left,  504,  166
Sleep, 100
MouseClick, left,  537,  347
Sleep, 100
MouseClick, left,  532,  271
Sleep, 100
MouseClick, left,  542,  370
Sleep, 100
MouseClick, left,  545,  241
Sleep, 100
MouseClick, left,  543,  417
Sleep, 100
MouseClick, left,  543,  207
Sleep, 100
MouseClick, left,  541,  457
Sleep, 100
MouseClick, left,  538,  165
Sleep, 100
MouseClick, left,  567,  343
Sleep, 100
MouseClick, left,  565,  280
Sleep, 100
MouseClick, left,  568,  384
Sleep, 100
MouseClick, left,  577,  233
Sleep, 100
MouseClick, left,  576,  415
Sleep, 100
MouseClick, left,  577,  202
Sleep, 100
MouseClick, left,  580,  457
Sleep, 100
MouseClick, left,  570,  173
Sleep, 100

/*
>>>>>>>>>>( Window Title & Class )<<<<<<<<<<<
Minecraft
ahk_class SunAwtFrame

>>>>>>>>>>>>( Mouse Position )<<<<<<<<<<<<<
On Screen:	1849, 738  (less often used)
In Active Window:	1320, 485

>>>>>>>>>( Now Under Mouse Cursor )<<<<<<<<

Color:	0xE3DFE0  (Blue=E3 Green=DF Red=E0)

>>>>>>>>>>( Active Window Position )<<<<<<<<<<
left: 529     top: 253     width: 862     height: 514

>>>>>>>>>>>( Status Bar Text )<<<<<<<<<<

>>>>>>>>>>>( Visible Window Text )<<<<<<<<<<<
Minecraft Minecraft 1.2.5

>>>>>>>>>>>( Hidden Window Text )<<<<<<<<<<<

>>>>( TitleMatchMode=slow Visible Text )<<<<

>>>>( TitleMatchMode=slow Hidden Text )<<<<
*/
