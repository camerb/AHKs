aggromorphScript(){ ;v2.01 compatible
 ;mid outpost and commander gather version 1.1
GLOBAL
IF (turn < 3)
	Retreat = 0
Gosub, AGGROMORPHClass%unitclass%


aggromorphClass1: ;commander 1move, 2build, 3scan, 4attack, 5gather, 6hp
If (%currentunit%_hp < 3 and retcheck != 1)
	Retreat = 10
IF (Retreat > 0)
	{
	retreat -= 1
	retcheck = 1
	IF (aggromorph = 1)
		rDir = U
	Else
		rDir = D
	AA_Move(rDir)
	return
	}
If (aggromorphClass2unitCount = 0)
	AA_Build(020000, 2) ;build factory
If (aggromorphResources > 7 and aggromorphClass3unitcount = 0)
	midphase = 1
If (midphase = 1)
	{
	;msgbox % "x=" .  %2currentunit%_posx . " y=" . %2currentunit%_posy
	If (%currentunit%_posx = 241 and %currentunit%_posy = 241)
		{
		AA_Build(020000, 3) ;build mid outpost
		midphase = 0
		return
		}
	2xdistance := 241 - %currentunit%_posx 
	2ydistance := 241 - %currentunit%_posy
	2Dir :=	aggromorphGetTravelDirection(2xdistance, 2yDistance)
	AA_Move(2Dir)
	}
nearestenemy := FindNearest("enemy")
nearestmineral := FindNearest("mineral")
If (1distanceold < 2distanceold and %nearestenemy%_attack = 0)
	Gosub, attackmove
Else IF (%nearestmineral%_x < 241 and %nearestmineral%_y < 241)
	{
	IF (aggromorph = 1)
		Gosub, gathermove
	}
Else IF (%nearestmineral%_x > 241 and %nearestmineral%_y > 241)
	{
	IF (aggromorph = 2)
		Gosub, gathermove
	}
return

aggromorphClass2: ;factory
If (aggromorph = 1)
	aDir = D
Else
	aDir = U
If (aggromorphClass4unitCount > 1)
	AA_Build(101103, 5, aDir) ;if more than 1 workers, build an attacker
Else ; 1move, 2build, 3scan, 4attack, 5gather, 6hp
	AA_Build(101020, 4, aDir) ; otherwise, build a worker
return

aggromorphClass3: ;mid outpost 1move, 2build, 3scan, 4attack, 5gather, 6hp
If (aggromorphclass6unitcount = 0)
	AA_Build(003300, 6, aDir) ;build scan/attack tower
Else If (aggromorphResources > 6 and aggromorphclass2unitcount < 4) ;if a surplus of resources, build factory
	AA_Build(020000, 2, "L")
AA_Build(101103, 5) ;otherwise build attackers
return

aggromorphClass4: ;workers
GoSub, GatherMove
return

aggromorphClass5: ;attackers
GoSub, AttackMove
return

aggromorphclass6:
GoSub, AttackMove
return

GatherMove:
If AA_Gather() = 2
	{
	nearestmineral := FindNearest("mineral")
	Dir := GetTravelDirection(nearestmineral)
	If AA_Move(Dir) = 5
		stuckrand()
	return
	}
If AA_Gather() = 4
	AA_Scan()
return


AttackMove:
nearestenemy := FindNearest("enemy")
If AA_Attack(nearestenemy) = 2 ;if out of range
	{
	Dir := GetTravelDirection(nearestenemy)
	If AA_Move(Dir) = 5 ;if direction moved is blocked
		stuckrand()
	Return
	}
If AA_Attack(nearestenemy) = 4 ;if target not yet scanned
	AA_Scan()
return
}

StuckRand(){
GLOBAL
random, stuckrand, 1, 8
sDir :=  ((stuckrand = 1) ? ("U") : ( ((stuckrand = 2) ? ("D") : ( ((stuckrand = 3) ? ("L") : ( ((stuckrand = 4) ? ("R") : ( ((stuckrand = 5) ? ("UL") : ( ((stuckrand = 6) ? ("UR") : ( ((stuckrand = 7) ? ("DL") : ( ((stuckrand = 8) ? ("DR"))))))))))))))))
AA_Move(sDir)
return
}

AggromorphGetTravelDirection(xDistance, yDistance)
{
	2xvalue := ((xDistance = 0) ? () : (((xDistance < 0) ? ("L") : ("R"))))
	2yvalue := ((yDistance = 0) ? () : (((yDistance < 0) ? ("U") : ("D"))))
	returned := 2xvalue . 2yvalue
   return returned
}