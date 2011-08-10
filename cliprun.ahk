#include FcnLib.ahk

#NoEnv   ;recommended for performance and future compatibility.
#singleinstance force
setbatchlines, -1  ;made the scan about 5-15% faster, comment out if you want use to use your computer
                   ;while the scan is running and are using an image bigger than 200x200 (recommend, not necessary)
CoordMode, Pixel, Relative
/*

From older version that didn't use a GUI, feel free to add these in if you don't want to use a GUI

CoordMode, ToolTip, screen
CoordMode, Mouse, screen
CoordMode, Pixel, screen

Iwidth:=348
Iheight=10
*/

black=0x000000     ;these lines are defining the colors scanning,
red=0x0000FF
yellow=0x00FFFF
green=0x00FF00
magenta=0xFF00FF
brown=0x000099
blue=0xFF0000
;additional color, or shades, can be put here

do_this=
(   
After closing this message --
Place mouse cursor in desired top-left of where image should be drawn
and then hit F5
)
/*
msgbox % do_this
   keywait, F5, D

; getpos only once, so that all colors have a common "reference"
mousegetpos, referenceX, referenceY
   keywait, F5,
; can put includes if you want to compile
; -------------------------------
*/
; This part gets the information necessary for the scan

InputBox, websitename,, Please enter the name of the website that you're going to be downloading from., , , , , , , ,http://www.autohotkey.com/docs/images/DE.gif
   ;This Input box allows you to choose your website name as part of the script, instead of editting the script every time.
   ;Take out http://www.autohotkey.com/docs/images/DE.gif at the very end when you're ready to scan your own image, as it's just an example.

InputBox, imagename,,Please enter the name of the file that you're going to be scanning. `nIt's usually after the last slash, , , , , , , ,DE.gif
   ;This Input box allows you to choose your image name as part of the script, instead of editting the script every time.
   ;Take out DE.gif at the very end when you're ready to scan your own image, as it's just an example.
   
InputBox, redraw_speed,, Please enter the SetMouseDelay that will be used to redraw the image.`nA lower number is a faster draw.`n(Bigger images may need a higher delay), , , , , , , ,0
InputBox, redraw_delay,, Please enter the SetDefaultMouseSpeed that will be used to redraw the image.`nA lower number is a faster draw.`n(Bigger images may need a slower speed)`n`nUse nothing for the default speed of 2., , , , , , , ,0

InputBox, progress,,Enter 1 if you want to see the progess of the scan`, or 0 if you don't want to.

IfNotExist, %image%   ; checks if the GUI is open
{
  UrlDownloadToFile, %websitename%, %imagename%    ;downloads image into the scripts directory
  msgbox,,, image d/l complete
}



gui, color, White    ;set background color

gui, add, picture,  vp1 hwndimage, %imagename%    ;adds in picture

gui, show, x750 y220, TEST   ;positions GUI with the name of the window

WinWait, TEST,, 10

ControlgetPos, OutputVarX,OutputVarY,ww,hh,, TEST

MouseMove OutputVarX, OutputVarY


;MsgBox, the image is at x%OutputVarX% y%OutputVarY% w%ww% h%hh%      ; shows top left of image coordinates. also shows width and height of image

/*
Not needed, just to show what's happening in the setup of the scan.

goto skip
MouseGetPos, OutputVarX1, OutputVarY1

msgbox, , ,  Upper left corner of image is at %OutputVarX% %OutputVarY%
goto skip

mousemove, %OutputVarX%, %OutputVarY%, 0

mousemove, OutputVarX-100, %OutputVarY%, 0

sleep, 5000

msgbox, , ,  Move Mouse back to starting position,3
mousemove, OutputVarX1, OutputVarY1, 50

skip:
*/

;msgbox  Since 'Loop' starts at 1 we'll subtract 1 from upper left corner coords `n press OK to continue `n(You can press Win-Q to pause script), 1

OutputVarX--
OutputVarY--

;demo_column:=0     can choose how far to start in the picture, e.g. keep a scan going, stop it halfway, then start from half way

;============ clear accumulators
black_list= `; BGR color %black% is black `n`nSetMouseDelay, %redraw_speed% `nSetDefaultMouseSpeed, %redraw_delay%`n`n   ; these comments are added just once
red_list= `; BGR color %red% is red `n`nSetMouseDelay, %redraw_speed% `nSetDefaultMouseSpeed, %redraw_delay%`n`n
yellow_list= `; BGR color %yellow% is yellow `n`nSetMouseDelay, %redraw_speed% `nSetDefaultMouseSpeed, %redraw_delay%`n`n
green_list= `; BGR color %green% is green `n`nSetMouseDelay, %redraw_speed% `nSetDefaultMouseSpeed, %redraw_delay%`n`n
magenta_list= `; BGR color %magenta% is magenta `n`nSetMouseDelay, %redraw_speed% `nSetDefaultMouseSpeed, %redraw_delay%`n`n
brown_list= `; BGR color %brown% is brown `n`nSetMouseDelay, %redraw_speed% `nSetDefaultMouseSpeed, %redraw_delay%`n`n
blue_list= `; BGR color %blue% is  blue `n`nSetMouseDelay, %redraw_speed% `nSetDefaultMouseSpeed, %redraw_delay%`n`n
black_list1= `; BGR color %black% is black `n`nSetMouseDelay, %redraw_speed% `nSetDefaultMouseSpeed, %redraw_delay%`n`n   
red_list1= `; BGR color %red% is red `n`nSetMouseDelay, %redraw_speed% `nSetDefaultMouseSpeed, %redraw_delay%`n`n
yellow_list1= `; BGR color %yellow% is yellow `n`nSetMouseDelay, %redraw_speed% `nSetDefaultMouseSpeed, %redraw_delay%`n`n
green_list1= `; BGR color %green% is green `n`nSetMouseDelay, %redraw_speed% `nSetDefaultMouseSpeed, %redraw_delay%`n`n
magenta_list1= `; BGR color %magenta% is magenta `n`nSetMouseDelay, %redraw_speed% `nSetDefaultMouseSpeed, %redraw_delay%`n`n
brown_list1= `; BGR color %brown% is brown `n`nSetMouseDelay, %redraw_speed% `nSetDefaultMouseSpeed, %redraw_delay%`n`n
blue_list1= `; BGR color %blue% is  blue `n`nSetMouseDelay, %redraw_speed% `nSetDefaultMouseSpeed, %redraw_delay%`n`n
;=============== only 'pixel_list is currently used
pixel_list:=" X  Y  Color `n"

loop, %ww%
{
   xx:=a_index
   ;xx:=xx+demo_column ; not needed
   loop, %hh%
   {
      yy:=a_index+1
      xxx:=OutputVarX+xx ; mouse & pixel locations, window relative
      yyy:=OutputVarY+yy

      pixelgetcolor, color, xxx,yyy
   
   if (a_index = 1)
   {
   if color != 0xFFFFFF
   {
   if(color = red)
   {
      red_list1 := red_list1 . "MouseClickDrag, " . xxx . ", " . yyy . ", "
   }
   if(color = black)
   {
      black_list1 := black_list1 . "MouseClickDrag, " . xxx . ", " . yyy . ", "
   }
   if(color = yellow)
   {
      yellow_list1 := yellow_list1 . "MouseClickDrag, " . xxx . ", " . yyy . ", "
   }
   if(color = green)
   {
      green_list1 := green_list1 . "MouseClickDrag, " . xxx . ", " . yyy . ", "
   }
   if(color = brown)
   {
      brown_list1 := brown_list1 . "MouseClickDrag, " . xxx . ", " . yyy . ", "
   }   
   if(color = magenta)
   {
      magenta_list1 := magenta_list1 . "MouseClickDrag, " . xxx . ", " . yyy . ", "
   }
   if(color = blue)
   {
      blue_list1 := blue_list1 . "MouseClickDrag, " . xxx . ", " . yyy . ", "
   }   
      PreviousColor := color
	  MsgBox % PreviousColor
   }
   }
   }
}



 ~esc::ExitApp