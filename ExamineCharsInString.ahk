#include FcnLib.ahk

asdf := prompt("Give me the crazy string")
;  AddToTrace("exists")
examineStrs(joe, asdf)

examineStrs(str1, str2)
{
   debug(strlen(str1), strlen(str2))
   AddToTrace(strlen(str1), strlen(str2))

   chars := strlen(str2)
   loop %chars%
   {
      char1:=substr(str1, A_Index, 1)
      char2:=substr(str2, A_Index, 1)
      equal:= substr(str1, A_Index, 1) == substr(str2, A_Index, 1)
      AddToTrace(char1, char2, equal, asc(char1), asc(char2) )

      debug(char1, char2, equal, asc(char1), asc(char2) )
   }
}
