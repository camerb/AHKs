CamerBXScript(){
GLOBAL
FileRead, 2Units, AllUnitList.txt
StringSplit, bunit, 2Units, |
2refreshloop := bunit0-1
Loop %2refreshloop%
{
   2currentunit := bunit%a_index%
   If !2currentunit
      continue
   StringGetPos, Position, 2currentunit, _
   StringLeft, player, 2currentunit, Position
   If (player = CamerBXenemy)
      Continue
   2currentclass := %2currentunit%_class
   Gosub, CamerBXClass%2currentclass%
}
return

CamerBXClass1:
if (TurnCount = 1)
{
   WaitForNumOfFighters:=20
   CamerBXStartAttack:=false
}
If (CamerBXResources > 3)
{
   If (CamerBXClass2unitCount < 2)
      AA_Build(101020, 2currentunit, 2) ;make two workers
   Else If (CamerBXClass4unitCount < 1)
      AA_Build(004000, 2currentunit, 4, "R") ;build a scanner
   Else If (CamerBXClass5unitCount < 1)
      AA_Build(000400, 2currentunit, 5, "L") ;build a tower
   Else If (CamerBXClass6unitCount < 2)
      AA_Build(120010, 2currentunit, 6) ;build a builder
   Else If (CamerBXClass2unitCount < 4)
      AA_Build(101020, 2currentunit, 2)
   ;Else
      ;AA_Build(102100, 2currentunit, 3) ;build an attacker
   Else
      AA_Build(120010, 2currentunit, 6) ;build a builder
}
return

CamerBXClass2:
If AA_Gather(2currentunit) = 2
{
   2distanceold = 999
   Loop 15
   {
      If (mineral%a_index%value > 0) ;if a mineral has value > 0
              {
              2target = mineral%a_index%
              2xgatherdistance := abs(%2target%x - %2currentunit%_posx)
              2ygatherdistance := abs(%2Target%y - %2currentunit%_posy)
              2distancenew := 2xgatherdistance+2ygatherdistance
              If (2distancenew < 2distanceold)
                      {
                      2distanceold := 2distancenew
                      2nearestmineral := 2target
                      ;msgbox, new nearest mineral found! %1target%
                      }
              }
   }
   2xgatherdistance := %2nearestmineral%x - %2currentunit%_posx
   2ygatherdistance := %2nearestmineral%y - %2currentunit%_posy
   2Dir:=CamerBXGetTravelDirection(2xgatherdistance, 2ygatherdistance)
   CamerBXmove(2currentunit, 2dir)
   return
}
If AA_Gather(2currentunit) = 4
   AA_Scan(2currentunit)
return


CamerBXClass3:
FileRead, 2Units, AllUnitList.txt
StringSplit, bunit, 2Units, |
refreshloop3 := bunit0-1
2distanceold = 999
Loop %refreshloop3%
{
   2checkunit := bunit%a_index%
   StringGetPos, Position, 2checkunit, _
   StringLeft, player, 2checkunit, Position
   If (player = "CamerBX")
      Continue
   2xdistance := abs(%2checkunit%_posx - %2currentunit%_posx)
   2ydistance := abs(%2checkunit%_posy - %2currentunit%_posy)
   2distancenew := 2xdistance+2ydistance
   ;msgbox, total distance to %checkunit% = %1distancenew%
   If (2distancenew < 2distanceold)
   {
      2distanceold := 2distancenew
      2nearestenemy := 2checkunit
      ;msgbox, new nearest enemy found! %checkunit%
   }

   ;Find out the id of the commander
   testval=%camerbenemy%_1_1
   if (2checkunit = testval)
      CamerBXEnemyCommander=%testval%
   testval=%camerbenemy%_1_2
   if (2checkunit = testval)
      CamerBXEnemyCommander=%testval%
}
if ((NOT CamerBXStartAttack) AND CamerBXClass3unitCount < WaitForNumOfFighters) ; defend until we have 3 fighters
{
   If AA_Attack(2currentunit, 2nearestenemy) = 2
   {
      ;TODO detect what side I'm on so I'm going 1/4 of the way, rather than halfway
      2xdistance := 1 - %2currentunit%_posx
      2ydistance := 241 - %2currentunit%_posy
      2Dir:=CamerBXGetTravelDirection(2xdistance, 2yDistance)
      CamerBXmove(2currentunit, 2dir)
   }
   Else If AA_Attack(2currentunit, 2nearestenemy) = 4
   {
      ;debug("he's in range, but hasn't been scanned")
      AA_Scan(2currentunit)
   }
   else
      AA_Attack(2currentunit, 2nearestenemy)
}
else
{
   CamerBXStartAttack:=true
   If AA_Attack(2currentunit, 2nearestenemy) = 2
   {
      2xdistance := %CamerBXEnemyCommander%_posx - %2currentunit%_posx
      2ydistance := %CamerBXEnemyCommander%_posy - %2currentunit%_posy
      2Dir:=CamerBXGetTravelDirection(2xdistance, 2yDistance)
      CamerBXmove(2currentunit, 2dir)
   }
   Else If AA_Attack(2currentunit, 2nearestenemy) = 4
   {
      ;debug("he's in range, but hasn't been scanned")
      AA_Scan(2currentunit)
   }
}
return

CamerBXClass4:
AA_Scan(2currentunit)
return

CamerBXClass5:
FileRead, 2Units, AllUnitList.txt
StringSplit, bunit, 2Units, |
refreshloop3 := bunit0-1
2distanceold = 999
Loop %refreshloop3%
{
   2checkunit := bunit%a_index%
   StringGetPos, Position, 2checkunit, _
   StringLeft, player, 2checkunit, Position
   If (player = "CamerBX")
      Continue
   2xdistance := abs(%2checkunit%_posx - %2currentunit%_posx)
   2ydistance := abs(%2checkunit%_posy - %2currentunit%_posy)
   2distancenew := 2xdistance+2ydistance
   If (2distancenew < 2distanceold)
   {
      2distanceold := 2distancenew
      2nearestenemy := 2checkunit
   }
}
AA_Attack(2currentunit, 2nearestenemy)
return

CamerBXClass6:
if (%2currentunit%_posx > 101)
   CamerBXmove(2currentunit, "L")
Else If (CamerBXClass2unitCount < 10)
   AA_Build(101020, 2currentunit, 2)
else
   AA_Build(102100, 2currentunit, 3) ;build an attacker
return

;Closes CamerBXScript() ???
}

CamerBXmove(2currentunit, 2Dir)
{
   if AA_Move(2currentunit, 2Dir) = 5
   {
      Random, rand, 1, 4
      2Dir := ( rand=1 ? "U" : ( rand=2 ? "D" : ( rand=3 ? "L" : "R" )))
   }
   AA_Move(2currentunit, 2Dir)
}

CamerBXGetTravelDirection(xDistance, yDistance)
{
   2xvalue := (xDistance < 0) ? "L":"R"
   2yvalue := (yDistance < 0) ? "U":"D"
   returned := 2xvalue . 2yvalue
   return returned
}

;CamerBXDistanceFormula(x1, y1, x2, y2)
;{
   ;2xdistance := abs(%2checkunit%_posx - %2currentunit%_posx)
   ;2ydistance := abs(%2checkunit%_posy - %2currentunit%_posy)
   ;2distancenew := sqrt(2xdistance*2xdistance+2ydistance*2xdistance)
;}

;debug(text1="yo", text2="", text3="")
;{
   ;text=%text1%%A_Space%%text2%%A_Space%%text3%
   ;msgbox, , , %text%, 2
;}
