Script(){
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
	If (player = Lagosenemy)
		Continue
	1currentclass := %2currentunit%_class
	Gosub, Class%1currentclass%
	}
return

Class1:
If (LagosResources > 3)
	{
	If (LagosClass2unitCount > 3)
		AA_Build(101101, 2currentunit, 3) ;if more than 5 workers, build an attacker
	Else ; 1move, 2build, 3scan, 4attack, 5gather, 6hp
		AA_Build(102010, 2currentunit, 2) ; otherwise, build a worker
	}
return

Class2:
If AA_Gather(2currentunit) = 2
	{
	;msgbox, no minerals in range, determining nearest mineral
	2distanceold = 999
	Loop 15
		{
		If (mineral%a_index%value > 0) ;if a mineral has value > 0
			{
			2target = mineral%a_index%
			2xgatherdistance := abs(%2target%x - %2currentunit%_posx)
			2ygatherdistance := abs(%2Target%y - %2currentunit%_posy)
			2distancenew := 2xgatherdistance+2ygatherdistance
			;msgbox, total distance to mineral = %1distancenew%
			If (2distancenew < 2distanceold)
				{
				2distanceold := 2distancenew
				2nearestmineral := 2target
				;msgbox, new nearest mineral found! %1target%
				}
			}
		}
	;msgbox, begin move towards %1NEARESTMINERAL%
	2xgatherdistance := %2nearestmineral%x - %2currentunit%_posx
	2ygatherdistance := %2nearestmineral%y - %2currentunit%_posy
	;msgbox, 1xgatherdistance = %1xgatherdistance% and 1ygatherdistance = %1ygatherdistance%
	If (2xgatherdistance = 0)
		2xvalue =
	If (2xgatherdistance < 0)
		2xvalue = L
	If (2xgatherdistance > 0)
		2xvalue = R
	If (2ygatherdistance = 0)
		2yvalue =
	If (2ygatherdistance > 0)
		2yvalue = D
	If (2ygatherdistance < 0)
		2yvalue = U
	2Dir := 2xvalue . 2yvalue
	;msgbox, direction to travel determined to be %1dir%
	If AA_Move(2currentunit, 2Dir) = 5
			AA_Move(2currentunit, "R")
	return
	}
If AA_Gather(2currentunit) = 4
	AA_Scan(2currentunit)
return


Class3:
FileRead, 2Units, AllUnitList.txt
StringSplit, bunit, 2Units, |
refreshloop3 := bunit0-1
2distanceold = 999
Loop %refreshloop3%
	{
	2checkunit := bunit%a_index%
	StringGetPos, Position, 2checkunit, _
	StringLeft, player, 2checkunit, Position
	If (player = "Lagos")
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
	}
If AA_Attack(2currentunit, 2nearestenemy) = 2
	{
	;msgbox, attack out of range. begin move towards %2NEARESTENEMY%
	2xdistance := %2nearestenemy%_posx - %2currentunit%_posx
	2ydistance := %2nearestenemy%_posy - %2currentunit%_posy
;	msgbox, 1xdistance = %1xdistance% and 1ydistance = %1ydistance%
	If (2xdistance = 0)
		2xvalue =
	If (2xdistance < 0)
		2xvalue = L
	If (2xdistance > 0)
		2xvalue = R
	If (2ydistance = 0)
		2yvalue =
	If (2ydistance > 0)
		2yvalue = D
	If (2ydistance < 0)
		2yvalue = U
	2Dir := 2xvalue . 2yvalue
	;msgbox, direction to travel determined to be %2dir%
	If AA_Move(2currentunit, 2Dir) = 5
		AA_Move(2currentunit, "R")
	Return
	}
If AA_Attack(2currentunit, 2nearestenemy) = 4
	AA_Scan(2currentunit)
return
}
