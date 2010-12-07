LiquidGravityDScript(){  ;v2.01 compatible
GLOBAL
 
Gosub, LiquidGravityDClass%unitclass%

LiquidGravityDClass1: ; Commander
  If (LiquidGravityDResources > 3)
  {
    If (LiquidGravityDClass2unitCount = 0)
      AA_Build(101020, 2)
    If (LiquidGravityDClass5unitCount = 0)
      AA_Build(004000, 5,"U")
    If (LiquidGravityDClass4unitCount = 0)
      AA_Build(000400, 4,"UL")
    If (LiquidGravityDClass1unitCount = 1)
      AA_Build(020000, 1,"L")
    If (LiquidGravityDClass2unitCount > 3)
      AA_Build(101101, 3) ;if more than 3 workers, build an attacker
    Else ; 1move, 2build, 3scan, 4attack, 5gather, 6hp
      AA_Build(101020, 2) ; otherwise, build a worker
  }
return

LiquidGravityDClass2: ; Gatherer
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


LiquidGravityDClass3: ;Soldier
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


LiquidGravityDClass4: ; Watchtower
GoSub, LiquidGravityDClass3
return


LiquidGravityDClass5: ; Sniper
;msgbox, %1currentunit% class 5 initiated
AA_Scan()
return
}
