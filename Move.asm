INCLUDE _modules.inc
.code
DrawCurrentPosition PROC,
	GameMap:PTR BYTE

	push esi
	mov esi, GameMap
	add esi, eax

	.IF ecx == 1
		mov BYTE PTR [esi], 023h
		mov ecx, 0
	.ELSE
		mov  BYTE PTR [esi], 021h
	.ENDIF

	pop esi

	ret
DrawCurrentPosition ENDP
END