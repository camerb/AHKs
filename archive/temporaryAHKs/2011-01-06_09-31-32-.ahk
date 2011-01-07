#include FcnLib.ahk

	#F1::
		{
		Gui, Add, Text,, Please select all actions that you would like to perform with this data:
		Gui, Add, Checkbox, vAddressMacro, Compare addresses
		Gui, Add, Checkbox, vEvvMacro, Note accounts in Evv
		Gui, Add, Checkbox, vRwnMacro, Print statements from Rwn
		Gui, Add, Button, Default, OK
		Gui, Show, xCenter, JennaSys
		RETURN
		Gui, Add, Text,, Please select the input file that you would like to use from the drop down list		Gui, Add, DropDownList, vJsysIPxls, JennaSys Input.xls|JennaSys Input.txt|Evv Macro Input.txt|Other
		Gui, Add, Button, Default, OK
		Gui, Show, xCenter, JennaSys
		Return

		ButtonOk:
			{
			Gui, Submit
			Gui, Destroy
			}
		Return
		}
	Return

