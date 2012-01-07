#include FcnLib.ahk
#include ThirdParty/json.ahk

options=
(Ltrim
{
    "ahk" :
    {
        "version"   : "1.0.45",
        "path"      : "d:/program files/autohotkey"
    },
    "SWW" : 1
}
)

debug(json(options,"ahk.version"), json(options,"ahk.path"))
json(options,"ahk.version","2.99.999")

debug(json(options,"ahk.version"), json(options,"ahk.path"))



options=
(Ltrim
{
    "hk" :
    [
    {
        "name" : "isaias",
        "grade" : 90
    },
    {
        "name" : "miguel",
        "grade" : 50
    }
    ]
}
)

debug( json(options,"hk[1].name") )

;this doesn't work!!! there's no way to set the second element
json(options,"hk[1].name","joe")

debug( json(options,"hk[1].name") )
debug( options )
