#include FcnLib.ahk
#include thirdParty/COM.ahk

COM_Init()
COM_Error(false)

mouseover=
(
function whichElement()
{
   tindex=event.srcElement.sourceIndex;
   tname=document.all(tindex).tagName;
   innerhtml=document.all(tindex).innerHTML;
   //window.status=event.srcElement..tagName;
   oAttrColl = event.srcElement.attributes;
   myLen=oAttrColl.length;
   xx="Dom=document.all(" + tindex + ")\n";
   xx=xx + "document.all(" + tindex + ").tagName=" + event.srcElement.tagName + "\n *** Attributes if any **** \n";
   if (event.srcElement.value != undefined)
   xx=xx + "document.all(" + tindex + ").value=" + event.srcElement.value + "\n";
   for (i = 0; i < oAttrColl.length; i++)
   {
      oAttr = oAttrColl.item(i);
      bSpecified = oAttr.specified;
      sName = oAttr.nodeName;
      vValue = oAttr.nodeValue;
      if (bSpecified)
      {
         xx=xx + sName + "=" + vValue + "\n";
      }
   }

}
document.body.onmouseover = whichElement;
)

Gui, Add, Button, x6 y0 w90 h20 gResume, Resume
Gui, Add, Edit, x6 y20 w590 h485 vDom,

Gui, Show, h500 w600, DOM Extractor Ctrl + / to freeze
SetTimer,dom,800
Return

GuiClose:


COM_Term()
ExitApp
Resume:
SetTimer,dom,800
Return
dom:
WinGetTitle,thispage,ahk_class IEFrame
StringReplace,thispage,thispage,% " - Microsoft Internet Explorer",,All ; ie6 postfix
StringReplace,thispage,thispage,% " - Windows Internet Explorer",,All  ; ie7 postfix
if thispage
{
   ControlGetText,URL,Edit1,% thispage . "ahk_class IEFrame"
COM_Init()
Loop, %   COM_Invoke(psw := COM_Invoke(psh:=COM_CreateObject("Shell.Application"), "Windows"), "Count")
   {
      LocationName:=COM_Invoke(pwb:=COM_Invoke(psw, "Item", A_Index-1), "LocationName")
      IfInString,LocationName,%thispage%
         Break
      COM_Release(pwb)
   }
item122:=COM_Invoke(all:=COM_Invoke(document:=COM_Invoke(pwb,"Document"),"All"),"Item",122)
pdoc:=COM_Invoke(pwb,"Document")
pwin:=COM_Invoke(pdoc,"parentWindow")
COM_Invoke(pwin, "execScript",mouseover)
tname:=COM_Invoke(pwin,"tname")
tindex:=COM_Invoke(pwin,"tindex")
myLen:=COM_Invoke(pwin,"myLen")
xx:=COM_Invoke(pwin,"xx")
framecount:=COM_Invoke(pwin,"framecount")
innerhtml:=COM_Invoke(pwin,"innerhtml")
comstring=
(
COM_Init()
COM_Error(0)
pageSearched:="%thispage%"
Loop, `%   COM_Invoke(psw := COM_Invoke(psh:=COM_CreateObject("Shell.Application"), "Windows"), "Count")
   {
      LocationName:=COM_Invoke(pwb:=COM_Invoke(psw, "Item", A_Index-1), "LocationName")
      IfInString,LocationName,`%pageSearched`%
         Break
      COM_Release(pwb)
   }
item%tindex%`:=COM_Invoke(all`:=COM_Invoke(document`:=COM_Invoke(pwb,"Document"),"All"),"Item",%tindex%)
MsgBox `% value:=COM_Invoke(item%tindex%,"value")
MsgBox `% innerHTML:=COM_Invoke(item%tindex%,"innerHTML")
COM_Release(item%tindex%),COM_Release(all),COM_Release(document),COM_Release(pwb)
COM_Term()
)
GuiControl,Text,Dom,% thispage . " `n" . URL . " `nDom accessable objects for document`.all collection `nElement type (" . tname . ")`nIndex (" . tindex . ")`n" . xx . "`nExample of how to ref in com`n****`n" . comstring . "`n******`nVisible text= " . innerhtml
COM_Release(pdoc),COM_Release(pwin),COM_Release(pwb)
comstring=
}
return
^/::
SetTimer,dom,Off
Return

