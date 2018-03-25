
INCLUDE Irvine32.inc

CalculateNext PROTO,
	Row:BYTE,
	Column:BYTE

EndDemo PROTO,
	NumberOfGhosts:BYTE,
	Captured:BYTE

DrawCurrentPosition PROTO,
	GameMap:PTR BYTE

PrintMap PROTO,
	GameMap:PTR BYTE

GetMovement PROTO,
	Row:BYTE,
	Column:BYTE