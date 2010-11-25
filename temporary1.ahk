#include FunctionLibrary.ahk

t("WinTitle=>joejoe")
t("joejoe")
t("WinTitle=>joejoe ExcludeTitle=>frigg")

t(var)
{
   debug(var)
   var := GetWinTitle(var)
   debug(var)
}

;MyWinWait("Command Prompt")

;debug("yo")

MyWinWait(window)
{
   CustomTitleMatchMode(options)


   WinWait, %titleofwin%,

   CustomTitleMatchMode("Default")
}

;GetWinTitle(window)
;{
   ;returned := RegExReplace(window, "^.*WinTitle=>\(")
   ;if (returned!=window)
      ;returned := RegExReplace(returned, "\).*$")
   ;return %returned%
;}

GetWinTitle(window)
{
   allPossible=(Win|Exclude)(Title|Text)
   begReplace=^.*WinTitle=>
   endReplace= %allPossible%.*$
   returned := RegExReplace(window, begReplace)
   if (returned!=window)
      returned := RegExReplace(returned, endReplace)
   return %returned%
}

GetExcludeTitle(window, name="WinTitle", mainItem=true)
{
   begReplace=^.*ExcludeTitle=>
   endReplace= \w.*$


   returned := RegExReplace(window, begReplace)
   ;TODO bah! this logic sucks so much, i just need to truth table it out
   if (returned != window)
   {
      if (mainItem) ;meaning that if there were no items, we should return the full string
         returned := RegExReplace(returned, endReplace)
      else
         returned := ""
   }
   return %returned%
}


;Run, "C:\Program Files\Opera\opera.exe" http://www.nascar.com/

;Description of all window methods from the docs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;IfWinActive / IfWinNotActive
;Checks if the specified window exists and is currently active (foremost).
;IfWinExist / IfWinNotExist
;WinActivate	Activates the specified window (makes it foremost).
;WinActivateBottom	Same as WinActivate except that it activates the bottommost (least recently active) matching window rather than the topmost.
;WinClose	Closes the specified window.
;WinGetActiveStats	Combines the functions of WinGetActiveTitle and WinGetPos into one command.
;WinGetActiveTitle	Retrieves the title of the active window.
;WinGetClass	Retrieves the specified window's class name.
;WinGet 	Retrieves the specified window's unique ID, process ID, process name, or a list of its controls. It can also retrieve a list of all windows matching the specified criteria.
;WinGetPos	Retrieves the position and size of the specified window.
;WinGetText	Retrieves the text from the specified window.
;WinGetTitle	Retrieves the title of the specified window.
;WinHide	Hides the specified window.
;WinKill	Forces the specified window to close.
;WinMaximize	Enlarges the specified window to its maximum size.
;WinMenuSelectItem	Invokes a menu item from the menu bar of the specified window.
;WinMinimize	Collapses the specified window into a button on the task bar.
;WinMinimizeAll	Minimizes all windows.
;WinMinimizeAllUndo	Reverses the effect of a previous WinMinimizeAll.
;WinMove	Changes the position and/or size of the specified window.
;WinRestore	Unminimizes or unmaximizes the specified window if it is minimized or maximized.
;WinSet  	Makes a variety of changes to the specified window, such as "always on top" and transparency.
;WinSetTitle	Changes the title of the specified window.
;WinShow	Unhides the specified window.
;WinWait	Waits until the specified window exists.
;WinWaitActive	Waits until the specified window is active.
;WinWaitClose	Waits until the specified window does not exist.
;WinWaitNotActive


