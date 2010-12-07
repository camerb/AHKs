LagosScript(){ ;v2.0 compatible
GLOBAL
Gosub, LagosClass%unitclass%

LagosClass1:
If (LagosResources > 3)
	{
	If (LagosClass2unitCount > 2)
		AA_Build(201102, 3) ;if more than 2 workers, build an attacker
	Else ; 1move, 2build, 3scan, 4attack, 5gather, 6hp
		AA_Build(202010, 2) ; otherwise, build a worker
	}
return

LagosClass2:
If AA_Gather() = 2
	{
	nearestmineral := FindNearest("mineral")
	Dir := GetTravelDirection(nearestmineral)
	If AA_Move(Dir) = 5
			AA_Move("R")
	return
	}
If AA_Gather() = 4
	AA_Scan()
return

LagosClass3:
nearestenemy := FindNearest("enemy")
If AA_Attack(nearestenemy) = 2 ;if out of range
	{
	Dir := GetTravelDirection(nearestenemy)
	If AA_Move(Dir) = 5 ;if direction moved is blocked
		AA_Move("R")
	Return
	}
If AA_Attack(nearestenemy) = 4 ;if target not yet scanned
	AA_Scan()
return
}