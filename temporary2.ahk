#include FcnLib.ahk
#include thirdParty/lib_json.ahk

;figuring out objects

joe := Object()
joe.joejoe := "here"
j=joejoe
;msgbox % joe.j
msgbox % joe.joejoe

;serialization
;dynamic setting of set var
;array-style object
;run using AHK_L

;JSON_load(filename) {
;JSON_save(obj, filename) {
