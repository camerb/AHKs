#include FcnLib.ahk
#include firefly-FcnLib.ahk

#notrayicon

ViewableIniFolder( GetPath("FireflyCheckinIniFolder") , "C:\Dropbox\fastData\fireflyCheckins\botCheckins.ini")
ViewableIniFolder( GetPath("FireflyIniFolder") , "C:\Dropbox\fastData\fireflyBotCommunication\fireflyBot.ini")
;notify("finished making viewable ini")
;SleepSeconds(10)
ExitApp
