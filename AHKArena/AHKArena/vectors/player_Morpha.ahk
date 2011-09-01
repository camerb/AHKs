morphaScript(){ ;v2.0 compatible
GLOBAL
Gosub, morphaClass%unitclass%

morphaClass1:
If (morphaResources > 3)
	{
	If (morphaClass2unitCount > 2)
		AA_Build(1011012, 3) ;if more than 2 workers, build an attacker
	Else ; 1move, 2build, 3scan, 4attack, 5gather, 6hp
		AA_Build(1010102, 2) ; otherwise, build a worker
	}
return

morphaClass2:
If AA_Gather() = 2
	{
	nearestmineral := FindNearest("mineral")
	Dir := GetTravelDirection(nearestmineral)
	If AA_Move(Dir) = 5
		random, stuckrand, 1, 8
		sDir :=  ((stuckrand = 1) ? ("U") : ( ((stuckrand = 2) ? ("D") : ( ((stuckrand = 3) ? ("L") : ( ((stuckrand = 4) ? ("R") : ( ((stuckrand = 5) ? ("UL") : ( ((stuckrand = 6) ? ("UR") : ( ((stuckrand = 7) ? ("DL") : ( ((stuckrand = 8) ? ("DR"))))))))))))))))
		AA_Move(sDir)
	return
	}
If AA_Gather() = 4
	AA_Scan()
return

morphaClass3:
nearestenemy := FindNearest("enemy")
If AA_Attack(nearestenemy) = 2 ;if out of range
	{
	Dir := GetTravelDirection(nearestenemy)
	If AA_Move(Dir) = 5 ;if direction moved is blocked
		random, stuckrand, 1, 8
		sDir :=  ((stuckrand = 1) ? ("U") : ( ((stuckrand = 2) ? ("D") : ( ((stuckrand = 3) ? ("L") : ( ((stuckrand = 4) ? ("R") : ( ((stuckrand = 5) ? ("UL") : ( ((stuckrand = 6) ? ("UR") : ( ((stuckrand = 7) ? ("DL") : ( ((stuckrand = 8) ? ("DR"))))))))))))))))
		AA_Move(sDir)
	Return
	}
If AA_Attack(nearestenemy) = 4 ;if target not yet scanned
	AA_Scan()
return
}