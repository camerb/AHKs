#include FcnLib.ahk

ThreadedMsgbox("heya asdf")

;this is a candidate for merging with debug()
;but first options "threaded" "timeToWait=untilPressOkButton" and "hideDebugInfo" need to be implemented
;but right now I think it is different enough
ThreadedMsgbox(message)
{
   message="%message%"
   RunAhk("ThreadedMsgbox.ahk", message)
}
