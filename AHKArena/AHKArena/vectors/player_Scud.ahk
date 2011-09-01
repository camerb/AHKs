scudScript(){ ;v2.0 compatible
GLOBAL
Gosub, scudClass%unitclass%

scudClass1:
	AA_Build(3000003, 2) ;1move, 2build, 3scan, 4attack, 5gather, 6hp, 7missile
return

scudClass2:
X = 241
If (Scud = 1)
	{
	movdir = D
	Y = 421
	}
Else
	{
	movdir = U
	Y = 61
	}
If AA_Missile(X,Y) = 2
	{
	If AA_Move(movdir) = 5
		random, stuckrand, 1, 8
		sDir :=  ((stuckrand = 1) ? ("U") : ( ((stuckrand = 2) ? ("D") : ( ((stuckrand = 3) ? ("L") : ( ((stuckrand = 4) ? ("R") : ( ((stuckrand = 5) ? ("UL") : ( ((stuckrand = 6) ? ("UR") : ( ((stuckrand = 7) ? ("DL") : ( ((stuckrand = 8) ? ("DR"))))))))))))))))
		AA_Move(sDir)
	}
	
return
}