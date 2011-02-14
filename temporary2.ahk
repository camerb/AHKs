#include FcnLib.ahk
#include thirdParty/Functions.ahk

;trying to make my own json parser function

;DeleteTraceFile()

;param=%1%

;completed features
;assert("asdf", "jkl`nuiop", "asdf", "no matches")

;if (param == "completedFeaturesOnly")
   ;ExitApp

;unit tests for features that aren't finished yet

AssertValidString("""""")
AssertValidString("""a""")
AssertValidString("""asdf""")
AssertValidString("""\u523F""")
AssertValidString("""\n""")

;haystack=""
;regex=\"\"
;if NOT RegExMatch(haystack, regex)
   ;AddToTrace("this should match: ", haystack)

;AddToTrace(StringRegEx())

json := myjson(json, "hello", "world")
addtotrace(json)
ret  := myjson(json, "hello")
assert=world

if not (ret == assert)
   addtotrace("failed test:", "json", description, assert, ret)

ExitApp

json := myjson(json, "num", "1234")
addtotrace(json)
ret  := myjson(json, "num")
assert=1234

if not (ret == assert)
   addtotrace("failed test:", "json", description, assert, ret)
   ;die("failed test:", "json", description, assert, ret)

;#####################################
ExitApp

AssertValidString(haystack)
{
   if NOT RegExMatch(haystack, StringRegEx())
      AddToTrace("this should match: ", haystack)
}

;jsonVar is the source of the json
;pathToKey is the distinct path from the root to the target key
;value is the value to add to that key (or to change that key's value to)
;  if value is omitted, the target key's value will be returned (a "get" rather than a "set")
myJson(ByRef jsonVar, pathToKey, value="")
{
   stringRegEx:=StringRegEx()
   numberRegEx:=NumberRegEx()
   theUglyStr=%jsonVar%
   Loop, Parse, pathToKey, .
   {
      desiredDepth=%A_Index%
      searchForThisKey:=A_LoopField
      ;TODO maybe we could validate that this key is a valid json string
      ;if NOT RegExMatch(quote . searchForThisKey . quote, "^" . StringRegEx() . "$")
         ;addtotrace(searchforthiskey, "is not a valid string")
      Loop % strlen(theUglyStr)
      {
         i=%A_Index%
         ;AddToTrace(searchForThisKey, theUglyStr, i)
         subpart := StringTrimLeft(theUglyStr, i)
         subchar := StringLeft(subpart, 1)

         if (subchar == "{")
            currentDepth++
         else if (subchar == "}")
            currentDepth--

         ;ugh... i think we need to get rid of the outer loop for now

         re=^%StringRegEx% :%A_Space%
         if RegExMatch(subpart, re)
            AddToTrace("saw it: ", subpart)
         ;AddToTrace(subpart)


      }
      childKey=%searchForThisKey%
   }
   if value
   {
      position=0
      quote="
      ;TODO validate that childkey is valid json string
      ;childKey="%childKey%"
      if RegExMatch(quote . childKey . quote, StringRegEx())
         childKey="%childKey%"
         ;AddToTrace("yo")

      ;TODO validate that value is a number
      ;TODO validate that value is a string
      if RegExMatch(quote . value . quote, StringRegEx())
         value="%value%"
      else if RegExMatch(value, NumberRegEx())
         value=%value%
      else
         AddToTrace("value didn't match a string or number", value)

      asdf={ %childKey% : %value% }
      return StringLeft(jsonVar, position) . asdf . StringTrimRight(jsonVar, position)
   }
}

die(msg, t1="", t2="", t3="", t4="", t5="", t6="", t7="", t8="", t9="")
{
   AddToTrace(msg, t1="", t2="", t3="", t4="", t5="", t6="", t7="", t8="", t9="")
   ExitApp
}

StringRegEx()
{
;documented in the "string" image at json.org
quote=\"
bslash=\\
slash=\/
hex=[0-9A-F]
anyNonControlChar=[^"\\]
re=%quote%(%anyNonControlChar%|%bslash%(["\/bfnrt]|u%hex%{4}))*%quote%
return re
}

NumberRegEx()
{
;documented in the "number" image at json.org
whole=(0{0,1}|[1-9]\d*)
decimal=(.\d+)
exponent=([eE][+-]{0,1}\d+)
re=-{0,1}%whole%%decimal%{0,1}%exponent%{0,1}
return re
}

;I don't think this will be used
ValueRegEx()
{
str:=StringRegEx()
num:=NumberRegEx()
obj:=ObjectRegEx()
ary:=ArrayRegEx()
re=(%str%|%num%|%obj%|%ary%|true|false|null)
return re
}

;I don't think this will be used
ArrayRegEx()
{
val:=ValueRegEx()
re=\[%val%(,%val%)*\]
return re
}

;I don't think this will be used
ObjectRegEx()
{
str:=StringRegEx()
val:=ValueRegEx()
keyValuePair=%str%\:%val%
re=\{%keyValuePair%(,%keyValuePair%)*\}
return re
}
