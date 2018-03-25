INCLUDE _modules.inc
.code
PrintMap PROC,
	GameMap:PTR BYTE

	push edx
	mov edx, GameMap
	call Clrscr
	call WriteString
	pop edx

	ret
PrintMap ENDP
END