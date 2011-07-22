GUI := new ConverterGUI()
#include <CGUI>
#include <Regex>
Class ConverterGUI extends CGUI
{
	__New()
	{
		global CFileDialog
		base.__New()
		this.Add("Edit", "EditPath", "x10", "C:\Projekte\C#\WindowsFormsApplication1\WindowsFormsApplication1\Form1.Designer.cs")
		this.Add("Button", "BtnBrowse", "x+10", "Browse")
		this.Add("Edit", "EditSavePath", "x10 y+10", "C:\Projekte\C#\WindowsFormsApplication1\WindowsFormsApplication1\Form1.ahk")
		this.Add("Button", "BtnSaveBrowse", "x+10", "Browse")
		this.Add("Button", "BtnConvert", "x10 y+10", "Convert")
		this.FileDialog := new CFileDialog()
		this.Show("")
	}
	BtnBrowse_Click()
	{
		this.FileDialog.Mode := "Open"
		if(this.FileDialog.Show())
			this.EditPath.Text := this.FileDialog.Filename
	}
	BtnSaveBrowse_Click()
	{
		this.FileDialog.Mode := "Save"
		if(this.FileDialog.Show())
			this.EditSavePath.Text := this.FileDialog.Filename
	}
	BtnConvert_Click()
	{
		this.Convert(this.EditPath.Text, this.EditSavePath.Text)
		run % this.EditSavePath.Text
	}
	Convert(InPath, OutPath)
	{
		global Regex
		FileRead, InputFile, % "*t " InPath
		start := InStr(InputFile, "partial class ") + StrLen("partial class ")
		Class := SubStr(InputFile, start, InStr(InputFile, "`n", 0, start) - start)
		Controls := Array() ;array storing control definitions
		Window := {} ;Object storing window properties
		pos := 0
		StartString := "private System.Windows.Forms."
		EndString := ";"
		Loop, Parse, InputFile, `n, %A_Space%%A_Tab%
		{
			line := A_LoopField
			if(InStr(line, "private System.Windows.Forms."))
			{
				type := Regex.MatchSimple(line, "type", "\.Forms\.(?P<type>.*?) (?P<name>.*?)\;")
				name := Regex.MatchSimple(line, "name", "\.Forms\.(?P<type>.*?) (?P<name>.*?)\;")
				if(type && name)
				{
					SupportedControls := { TextBox : "Edit", Label : "Text", Button : "Button", CheckBox : "CheckBox", PictureBox : "Picture", ListView : "ListView", ComboBox : "ComboBox", ListBox : "ListBox", TreeView : "TreeView", GroupBox : "GroupBox", RadioButton : "Radio"}
					type := SupportedControls[type]
					if(type)
					{
						Controls.Insert({Type : Type, Name : name, Events : {}})
						found := true
					}
				}
			}
		}
		Loop, Parse, InputFile, `n, %A_Space%%A_Tab%
		{
			line := A_LoopField
			if(InStr(line, "// ") && !InStr(line, "///") && strlen(line) > 4)
			{
				found := false
				for index, Control in Controls
				{
					fileappend, % line "`n// " Control.Name "`n" (line = "// " Control.Name) "`n" InStr(line, "// " Control.Name) "`n" strlen(line) ":" strlen("// " Control.Name), C:\Users\csander\Desktop\debug.txt
					if(line = "// " Control.Name) ;Start of new control section
					{
						CurrentControl := Control
						found := true
						break
					}
				}
				if(!found && strLen(line) > 5 && !InStr(line, "///"))
				{
					if(!found && InStr(line, "// " Class))
					{
						CurrentControl := "Window"
					}
				}
			}
			if(CurrentControl = "Window")
			{
				if(InStr(line, "=")) ;window property assignments
				{
					if(InStr(line, "this.ClientSize"))
					{
						Width := Regex.MatchSimple(line, "width", "\.Size\((?P<width>\d+),.*?(?P<height>\d+)")
						Height := Regex.MatchSimple(line, "height", "\.Size\((?P<width>\d+),.*?(?P<height>\d+)")
						if(width)
							Window.Width := width
						if(height)
							Window.height := height
					}
					if(InStr(line, "this.MaximizeBox"))
						Window.MaximizeBox := InStr(line, "true")
					if(InStr(line, "this.MinimizeBox"))
						Window.MinimizeBox := InStr(line, "true")
					if(InStr(line, "this.Text"))
						Window.Title := Regex.MatchSimple(line, "text", """(?P<text>.*)""")
				}				
			}
			else if(IsObject(CurrentControl)) ;Process control property assignments
			{
				Handled := false
				if(InStr(line, "=")) ;control property assignments
				{
					if(InStr(line, "this." CurrentControl.Name ".Size")) ;Some basic ones first
					{
						Width := Regex.MatchSimple(line, "width", "\.Size\((?P<width>\d+),.*?(?P<height>\d+)")
						Height := Regex.MatchSimple(line, "height", "\.Size\((?P<width>\d+),.*?(?P<height>\d+)")
						if(width)
							CurrentControl.Width := width
						if(height)
							CurrentControl.height := height
						handled := true
					}
					else if(InStr(line, "this." CurrentControl.Name ".Location"))
					{
						x := Regex.MatchSimple(line, "x", "\.Point\((?P<x>\d+),.*?(?P<y>\d+)")
						y := Regex.MatchSimple(line, "y", "\.Point\((?P<x>\d+),.*?(?P<y>\d+)")
						if(x)
							CurrentControl.x := x
						if(x)
							CurrentControl.y := y
						handled := true
					}
					else if(InStr(line, "this." CurrentControl.Name ".Text"))
					{
						CurrentControl.Text := Regex.MatchSimple(line, "text", """(?P<text>.*)""")
						handled := true
					}
					else if(InStr(line, "this." CurrentControl.Name ".Enabled"))
					{
						CurrentControl.Enabled := (InStr(line, "true") || InStr(line, "1;"))
						handled := true
					}
					else if(InStr(line, "this." CurrentControl.Name ".Visible"))
					{
						CurrentControl.Enabled := (InStr(line, "true") || InStr(line, "1;"))
						handled := true
					}
				}
				if(!handled && IsFunc(this[CurrentControl.Type])) ;Process special properties depending on type
					Handled := this[CurrentControl.Type](CurrentControl, line)
			}
		}
		
		;Now that all info is available, write the file
		OutputFile := "gui := new " Class "()`n#include <CGUI>`nClass " Class " Extends CGUI`n{`n`t__New()`n`t{`n`t`tBase.__New()`n"
		for index, Control in Controls
		{
			Options := (Control.HasKey("x") ? "x" Control.x " " : "" ) (Control.HasKey("y") ? "y" Control.y " " : "" ) (Control.HasKey("width") ? "w" Control.width " " : "" ) (Control.HasKey("height") ? "h" Control.height : "" )
			OutputFile .= "`t`tthis.Add(""" Control.Type """, """ Control.Name """, """ Options """, """ Control.Text """)`n"
			for Property, Value in Control
				if Property not in x,y,width,height,name,type,Text,HasEvents,Events
				{
					if Value is Number
						OutputFile .= "`t`tthis." Control.Name "." Property " := " Value "`n"
					else if(Value = "true" || Value = "false")
						OutputFile .= "`t`tthis." Control.Name "." Property " := " Value "`n"
					else
						OutputFile .= "`t`tthis." Control.Name "." Property " := """ Value """`n"
				}
			OutputFile .= "`t`t`n"
		}
		for Property, Value in Window
		{
			if Value is Number
				OutputFile .= "`t`tthis." Property " := " Value "`n"
			else if(Value = "true" || Value = "false")
				OutputFile .= "`t`tthis." Property " := " Value "`n"
			else
				OutputFile .= "`t`tthis." Property " := """ Value """`n"
		}
		OutputFile .= "`t`tthis.Show()`n"		
		OutputFile .= "`t}"
		for index, Control in Controls
		{
			for index2, Event in Control.Events
			{
				OutputFile .= "`n`t" Control.Name Event "`n`t{`n`t`t`n`t}"
				AnyEvents := true
			}
		}
		;~ if(!AnyEvents)
			;~ OutputFile .= "`t}`n"
		OutputFile .= "`n}`n"
		for index, Control in Controls
		{
			if(Control.Events.MaxIndex() >= 1)
				OutputFile .= Class "_" Control.Name ":`n"
		}
		if(AnyEvents)
			OutputFile .= "CGUI.HandleEvent()`nreturn"
		FileDelete, % OutPath
		FileAppend, % OutputFile, % OutPath
	}
	Button(CurrentControl, line)
	{
		if(InStr(line, "new System.EventHandler"))
		{
			EventHandled := true
			if(InStr(line, "_Click);"))
				CurrentControl.Events.Insert("_Click()")
			else
				EventHandled := false
			if(EventHandled)
				CurrentControl.HasEvents := true
		}
	}
	Edit(CurrentControl, line)
	{
		if(InStr(line, "new System.EventHandler"))
		{
			EventHandled := true
			if(InStr(line, "_TextChanged);"))
				CurrentControl.Events.Insert("_TextChanged()")
			else
				EventHandled := false
			if(EventHandled)
				CurrentControl.HasEvents := true
		}
		else if(InStr(line, "this." CurrentControl.Name ".MultiLine"))
			CurrentControl.Multi := (InStr(line, "true") || InStr(line, "1;"))
		else if(InStr(line, "this." CurrentControl.Name ".UseSystemPasswordChar"))
			CurrentControl.Password := (InStr(line, "true") || InStr(line, "1;"))
	}
	Checkbox(CurrentControl, line)
	{
		if(InStr(line, "new System.EventHandler"))
		{
			EventHandled := true
			if(InStr(line, "_CheckedChanged);"))
				CurrentControl.Events.Insert("_CheckedChanged()")
			else
				EventHandled := false
			if(EventHandled)
				CurrentControl.HasEvents := true
		}
		else if(InStr(line, "this." CurrentControl.Name ".Checked"))
			CurrentControl.Checked := (InStr(line, "true") || InStr(line, "1;"))
	}
	Radio(CurrentControl, line)
	{
		if(InStr(line, "new System.EventHandler"))
		{
			EventHandled := true
			if(InStr(line, "_CheckedChanged);"))
				CurrentControl.Events.Insert("_CheckedChanged()")
			else
				EventHandled := false
			if(EventHandled)
				CurrentControl.HasEvents := true
		}
		else if(InStr(line, "this." CurrentControl.Name ".Checked"))
			CurrentControl.Checked := (InStr(line, "true") || InStr(line, "1;"))
	}
	ComboBox(CurrentControl, line)
	{
		if(InStr(line, "new System.EventHandler"))
		{
			EventHandled := true
			if(InStr(line, "_SelectedIndexChanged);"))
				CurrentControl.Events.Insert("_SelectedIndexChanged()")
			else
				EventHandled := false
			if(EventHandled)
				CurrentControl.HasEvents := true
		}
		else if(InStr(line, "this." CurrentControl.Name ".DropDownStyle") && InStr(line, "DropDownList"))
			CurrentControl.type := "DropDownList"
	}
	DropDownList(CurrentControl, line)
	{
		if(InStr(line, "new System.EventHandler"))
		{
			EventHandled := true
			if(InStr(line, "_SelectedIndexChanged);"))
				CurrentControl.Events.Insert("_SelectedIndexChanged()")
			else
				EventHandled := false
			if(EventHandled)
				CurrentControl.HasEvents := true
		}
	}
	ListBox(CurrentControl, line)
	{
		if(InStr(line, "new System.EventHandler"))
		{
			EventHandled := true
			if(InStr(line, "_SelectedIndexChanged);"))
				CurrentControl.Events.Insert("_SelectedIndexChanged()")
			else
				EventHandled := false
			if(EventHandled)
				CurrentControl.HasEvents := true
		}
	}
	ListView(CurrentControl, line)
	{
		if(InStr(line, "new System.EventHandler"))
		{
			EventHandled := true
			if(InStr(line, "_ItemSelectionChanged);"))
				CurrentControl.Events.Insert("_SelectionChanged(Row)")
			else if(InStr(line, "_ItemCheckedChanged);"))
				CurrentControl.Events.Insert("_CheckedChanged(Row)")
			else if(InStr(line, "_MouseClick);"))
				CurrentControl.Events.Insert("_Click(RowNumber)")
			else if(InStr(line, "_MouseDoubleClick);"))
				CurrentControl.Events.Insert("_DoubleClick(RowNumber)")
			else if(InStr(line, "_ColumnClick);"))
				CurrentControl.Events.Insert("_ColumnClick(ColumnNumber)")
			else if(InStr(line, "_BeforeLabelEdit);"))
				CurrentControl.Events.Insert("_EditingStart(RowNumber)")
			else if(InStr(line, "_AfterLabelEdit);"))
				CurrentControl.Events.Insert("_EditingEnd(RowNumber)")
			else if(InStr(line, "_ItemActivate);"))
				CurrentControl.Events.Insert("_ItemActivate(RowNumber)")
			else if(InStr(line, "_KeyPress);"))
				CurrentControl.Events.Insert("_KeyPress(Key)")
			else if(InStr(line, "_MouseLeave);"))
				CurrentControl.Events.Insert("_MouseLeave()")
			else if(InStr(line, "_Enter);"))
				CurrentControl.Events.Insert("_FocusReceived()")
			else if(InStr(line, "_Leave);"))
				CurrentControl.Events.Insert("_FocusLost()")
			else
				EventHandled := false
			if(EventHandled)
				CurrentControl.HasEvents := true
		}
	}
}
ConverterGUI_BtnBrowse:
ConverterGUI_BtnSaveBrowse:
ConverterGUI_BtnConvert:
CGUI.HandleEvent()
return