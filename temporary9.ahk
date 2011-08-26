#include FcnLib.ahk

;vector math for AHK arena

vector:=vector(2,3)
ax := vectorGetX(vector)
ay := vectorGetY(vector)
mag := vectorMagnitude(vector)
norm := vectorNormalized(vector)
magOfNorm := vectorMagnitude(norm)
;debug(vector,ax,ay,mag,norm,magOfNorm)

vector(setX, setY)
{
   returned=%setX%,%setY%
   return returned
}

vectorGetX(vector)
{
   StringSplit, array_item_, vector, `,
   return array_item_1
}

vectorGetY(vector)
{
   StringSplit, array_item_, vector, `,
   return array_item_2
}

vectorNormalized(vector)
{
   ax := vectorGetX(vector)
   ay := vectorGetY(vector)
   mag := vectorMagnitude(vector)
   returned := vector( ax/mag, ay/mag )
   return returned
}

vectorMagnitude(vector)
{
   ax := vectorGetX(vector)
   ay := vectorGetY(vector)
   returned := sqrt((ax * ax) + (ay * ay))
   return returned
}

vectorMultiply(vector, constant)
{
   ax := vectorGetX(vector)
   ay := vectorGetY(vector)
   returned := vector( ax*constant, ay*constant )
   return returned
}

vectorFromCoords(startX, startY, finishX, finishY)
{
   returned := vector( finishX-startX, finishY-startY )
   return returned
}

vectorChangeLength(startX, startY, finishX, finishY, newDistance)
{
   returned := vector( finishX-startX, finishY-startY )
   return returned
}
