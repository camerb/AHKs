#include FcnLib.ahk


;GoSub, LaunchTroublesomeGui
Gui, 2: Add, ComboBox, vCityNew, joe|bob|sam
Gui, 2: Add, ComboBox, vClientNew, joe|bob|sam
Gui, 2: Add, Button, Default, Change To This Queue
Gui, 2: Show
return

2ButtonChangeToThisQueue:
Gui, 2: Submit
city:=cityNew
client:=clientNew
Gui, 2: Destroy
;GoSub, ButtonReloadQueue
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;GoSub, LaunchTroublesomeGui
;return

;LaunchTroublesomeGui:
;cityNew=hi
;Gui, 2: Add, ComboBox, vCityNew, joe|bob|sam
;Gui, 2: Add, Button, Default, Change To This Queue
;Gui, 2: Show
;return

;2ButtonChangeToThisQueue:
;Gui, 2: Submit
;msgbox, you chose %citynew%
;;city:=cityNew
;Gui, 2: Destroy
;GoSub, LaunchTroublesomeGui
;return
