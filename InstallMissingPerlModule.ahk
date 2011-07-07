#include FcnLib.ahk

CommandPromptCopy()
joe:=Clipboard
joe:=RemoveLineEndings(joe)
RegExMatch(joe, "Can't locate (.*?).pm", match)
package:=match1
package:=StringReplace(package, "/", "::", "A")
SendInput, cpanm %package%{ENTER}
debug(package)
