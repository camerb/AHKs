CamerB4funScript(){
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
   If (player = CamerB4funenemy)
      Continue
   2currentclass := %2currentunit%_class
   Gosub, CamerB4funClass%2currentclass%
}
return

CamerB4funClass1:
if (TurnCount = 1)
{
   WaitForNumOfFighters:=20
   CamerB4funStartAttack:=false
}
If (CamerB4funResources > 5)
{
   If (CamerB4funClass2unitCount < 2)
      AA_Build(101020, 2currentunit, 2) ;make two workers
   Else If (CamerB4funClass4unitCount < 1)
      AA_Build(004000, 2currentunit, 4, "R") ;build a scanner
   Else If (CamerB4funClass5unitCount < 1)
      AA_Build(000400, 2currentunit, 5, "L") ;build a tower
   Else If (CamerB4funClass6unitCount < 3)
      AA_Build(120010, 2currentunit, 6) ;build a builder
   Else If (CamerB4funClass2unitCount < 4)
      AA_Build(101020, 2currentunit, 2)
   Else
      AA_Build(102100, 2currentunit, 3) ;build an attacker
   ;Else
      ;AA_Build(120010, 2currentunit, 6) ;build a builder
}
else
   AA_Build(101020, 2currentunit, 2) ;make two workers
return

CamerB4funClass2:
;Find out the id of the commander
if (2checkunit = "camerb_1_1")
   CamerB4funCommander=camerb_1_1
if (2checkunit = "camerb_1_2")
   CamerB4funCommander=camerb_1_2

If AA_Gather(2currentunit) = 2
{
   2distanceold = 999
   Loop 15
   {
      If (mineral%a_index%value > 0) ;if a mineral has value > 0
               {
              2target = mineral%a_index%
              2xgatherdistance := abs(%2target%x - %CamerB4funCommander%_posx)
              2ygatherdistance := abs(%2Target%y - %CamerB4funCommander%_posy)
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
   2Dir:=CamerB4funGetTravelDirection(2xgatherdistance, 2ygatherdistance)
   CamerB4funmove(2currentunit, 2dir)
   return
}
If AA_Gather(2currentunit) = 4
   AA_Scan(2currentunit)
return


CamerB4funClass3:
FileRead, 2Units, AllUnitList.txt
StringSplit, bunit, 2Units, |
refreshloop3 := bunit0-1
2distanceold = 999
Loop %refreshloop3%
{
   2checkunit := bunit%a_index%
   StringGetPos, Position, 2checkunit, _
   StringLeft, player, 2checkunit, Position
   If (player = "CamerB4fun")
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
      CamerB4funEnemyCommander=%testval%
   testval=%camerbenemy%_1_2
   if (2checkunit = testval)
      CamerB4funEnemyCommander=%testval%
}
if ((NOT CamerB4funStartAttack) AND CamerB4funClass3unitCount < WaitForNumOfFighters) ; defend until we have 3 fighters
{
   If AA_Attack(2currentunit, 2nearestenemy) = 2
   {
      if (%2currentunit%_posx < 301)
         CamerB4funmove(2currentunit, "L")
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
   CamerB4funStartAttack:=true
   If AA_Attack(2currentunit, 2nearestenemy) = 2
   {
      2xdistance := %CamerB4funEnemyCommander%_posx - %2currentunit%_posx
      2ydistance := %CamerB4funEnemyCommander%_posy - %2currentunit%_posy
      2Dir:=CamerB4funGetTravelDirection(2xdistance, 2yDistance)
      CamerB4funmove(2currentunit, 2dir)
   }
   Else If AA_Attack(2currentunit, 2nearestenemy) = 4
   {
      ;debug("he's in range, but hasn't been scanned")
      AA_Scan(2currentunit)
   }
}
return

CamerB4funClass4:
AA_Scan(2currentunit)
return

CamerB4funClass5:
FileRead, 2Units, AllUnitList.txt
StringSplit, bunit, 2Units, |
refreshloop3 := bunit0-1
2distanceold = 999
Loop %refreshloop3%
{
   2checkunit := bunit%a_index%
   StringGetPos, Position, 2checkunit, _
   StringLeft, player, 2checkunit, Position
   If (player = "CamerB4fun")
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

CamerB4funClass6:
if (%2currentunit%_posx > 101)
   CamerB4funmove(2currentunit, "L")
Else If (CamerB4funClass2unitCount < 6)
   AA_Build(101020, 2currentunit, 2)
else
   AA_Build(102100, 2currentunit, 3) ;build an attacker
return

;Closes CamerB4funScript() ???
}

CamerB4funmove(2currentunit, 2Dir)
{
   if AA_Move(2currentunit, 2Dir) = 5
   {
      Random, rand, 1, 4
      2Dir := ( rand=1 ? "U" : ( rand=2 ? "D" : ( rand=3 ? "L" : "R" )))
   }
   AA_Move(2currentunit, 2Dir)
}

CamerB4funGetTravelDirection(xDistance, yDistance)
{
   2xvalue := (xDistance < 0) ? "L":"R"
   2yvalue := (yDistance < 0) ? "U":"D"
   returned := 2xvalue . 2yvalue
   return returned
}

CamerB4funDistanceFormula(x1, y1, x2, y2)
{
   2xdistance := abs(%2checkunit%_posx - %2currentunit%_posx)
   2ydistance := abs(%2checkunit%_posy - %2currentunit%_posy)
   2distancenew := sqrt(2xdistance*2xdistance+2ydistance*2xdistance)
}

debug(text1="yo", text2="", text3="")
{
   text=%text1%%A_Space%%text2%%A_Space%%text3%
   msgbox, , , %text%, 2
}
