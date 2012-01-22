#include FcnLib.ahk

#SingleInstance Force

Gui, Font, s12, Arial
Gui, Add, Tab, x5 y2 w650 h300, SECURING|REMOVING ITEMS|PLANTS|SIDING|STEPS|ROOF|MOLD|DEMO|COVERS & CAPS|ETC.  ; Tab2 vs. Tab requires v1.0.47.05.
Gui, Add, Checkbox, vMyCheckbox, Sample checkbox
Gui, Tab, SECURING
Gui, Add, Radio, vsecr, sec rad
Gui, Tab, REMOVING ITEMS
Gui, Add, Radio, vrmvr, rmv rad
Gui, Add, Radio,, Sample radio2
Gui, Tab, PLANTS
Gui, Add, Edit, vMyEdit r5  ; r5 means 5 rows tall.
Gui, Tab, SIDING
Gui, Tab, STEPS
Gui, Tab, ROOF
Gui, Tab, MOLD
Gui, Font, s12, Arial

Gui, Add, TreeView, w200 x30 center y105 -VScroll  -HScroll vMyProjects gproject
   MG := TV_Add( "Mold (General)", 0)
  

Gui, Add, ListView, xs+230 r4 y100 -HScroll -Multi grid NoSort AltSubmit gmoldlistclick vMyDetails, Categories

GuiControl,Focus,MyDetails
GuiControlGet,MyDetails,Focus

Gui, Show, Autosize Center, MOLD
guicontrol,, +resize  

return


project:
ItemID := TV_GetSelection()

if ItemID = % MG
   GoSub, MG

return
	  
	  	MG:
	LV_ModifyCol( 1, "center")
   LV_Add( "", "Spray Fungicide")
   LV_Add( "", "Cut Out Drywall", "","" )
   LV_Add( "", "Remove Wallpaper", "","" )
   LV_Add( "", "Replace Floorboard", "","" )
   
   LV_ModifyCol( 3, "AutoHdr" )
return


MoldListClick:
if A_GuiEvent = DoubleClick
{
    LV_GetText(RowText, A_EventInfo)  ; Get the text from the row's first field.
    gui, minimize
if rowtext = spray fungicide
{LastUnit := "Feet"
SetFormat, float, 0.2

Gui, 2:+AlwaysOnTop
Gui, 2:Font, s10, Arial
gui, 2:Add, text, y10, Large or Small Area?
Gui, 2:Add, Radio, x12 w250 h30 ys+20 vsprayd, Large Area (Dimensions in Feet)
Gui, 2:Add, Radio, x12 w250 h30 ys+43, Small Area (Dimensions in Inches)
Gui, 2:Add, Text, xs y85 section Center, —————————————————————
gui, 2:Add, text,w250 ys+20 xs, What is the Length?
gui, 2:Add, edit, vsfl
gui, 2:Add, text, xs ys+70, What is the Height?
gui, 2:Add, edit, vsfh
GuiControl 2:, % (LastUnit = "Feet") ? "ft" : "in", 1
Gui, 2:Add, Text, xs section Center, —————————————————————
gui, 2:Add, text, x12 w150, Applying Kilz Too?
Gui, 2:Add, Radio, x12 ys+50 w200 h30 vkilz, Yes
Gui, 2:Add, Radio, x12 ys+75 w200 h30, No
Gui, 2:Add, Text, xs ys+105 section Center, —————————————————————
gui, 2:Add, text, x12 w150, Area Above 6ft? (Requires Ladder?)
Gui, 2:Add, Radio, x12 ys+65 w200 h30 vspraylad, Yes
Gui, 2:Add, Radio, x12 ys+90 w200 h30, No
Gui, 2:Add, Button, default xm, Submit
Gui, 2:Show, , Mold - Spray Fungicide
return

2ButtonSubmit:
2GuiClose:
OnSetUnit:
Gui, 2:Submit  ; Save the input from the user to each control's associated variable.
gui, 2: destroy
msgbox Scrub molded area clean with hydrogen peroxide and apply non-bleach mold fungicide via pump sprayer%a_space%
if (kilz = 1) {
msgbox as well as apply a single coat of kilz™ 
}
msgbox to the subjected sections in order to prevent any further spreading.%a_space%
if (kilz = 2) {
}
if (sprayd = 1) {
msgbox (%sfl%'X%sfh%')
}
if (sprayd = 2) {
msgbox (%sfl%"X%sfh%")
}
if (spraylad = 1) {
msgbox as well as apply a single coat of kilz™ 
}
msgbox %a_space%Note: the majority of the subjected area is above 6ft, requiring a ladder to repair. 
if (spraylad = 2) {
}
msgbox %a_space%Disclaimer: Bid is to abate visible surfaces of the mold, once applied, mold may still be present on opposite side of drywall as well as other surfaces beyond the drywall itself e.g. studs and insulation. Additional bids concerning this area may turn up in the near future as a result.
return
}
else if rowtext = 2
{msgbox row2 success!
}
}
return

3GuiClose:
gui, 2:destroy
ExitApp

Gui, Tab, DEMO
Gui, Tab, COVERS & CAPS
Gui, Tab, ETC.
Gui, Tab  ; i.e. subsequently-added controls will not belong to the tab control.
Gui, Add, Button, default xm, OK  ; xm puts it at the bottom left corner.
Gui, Show, Center AutoSize, BID CATEGORIES
return

ButtonOK:
GuiClose:
GuiEscape:
Gui, Submit  ; Save each control's contents to its associated variable.
ExitApp

 ~esc::ExitApp