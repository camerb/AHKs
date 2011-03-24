RegExFindReplaceClipboard2()
{
;Save the clipboard contents
ClipSaved := ClipboardAll

;ask for the needle (regex)
InputBox, NeedleRegEx, Input RegEx, Please input the RegEx (Needle) to use in processing the text.

;ask for the replacement
InputBox, Replacement, Input Replacement, Please input the replacement text.

;perform the regex transformation
ClipSaved := RegExReplaceClipSaved, NeedleRegEx, Replacement)

;send to clipboard and clear the variable it was stored in (in case it was large)
Clipboard := ClipSaved
ClipSaved =
}