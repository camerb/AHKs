SetTitleMatchMode, RegEx

;Script thatItems that continually run, such as closing annoying popup windows that come up all the time
#include Persistent.ahk

;Hotkeys
#include AppSpecificHotkeys.ahk
#include GlobalHotkeys.ahk
#include RefreshHotkeys.ahk

;Functions
#include FcnLib.ahk

;########## all the includes that I need to be sure to make:

;need to separate the global hotkeys into related files (hotstrings, standard keys, special keys at top of keyboard)

;functions (separated)
;TODO need to enable tagging on ahk functions (ahk documentation-use c#???)
;    this will allow us to 'tag' functions as: TODO, FIXME, TESTME, WRITEME, RENAMEME
;    this will also allow a 'title', 'description' and 'parameters'
;    be sure to add the tags to be highlighted in gvim (regex file)
;    other ideas? ...
