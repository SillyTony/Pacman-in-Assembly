INCLUDE _modules.inc
.code

GetMovement PROC,
	Row:BYTE,
	Column:BYTE

	LookForKey:	 
		mov eax, 50
		call Delay
		call ReadKey
		jz LookForKey

		.IF al == 'w'
			mov bl, Row
			dec bl
			mov bh, Column
		.ELSEIF al == 's'
			mov bl, Row
			inc bl
			mov bh, Column
		.ELSEIF al == 'a'
			mov bh, Column
			dec bh
			mov bl, Row
		.ELSEIF al == 'd'
			mov bh, Column
			inc bh
			mov bl, Row
		.ELSE
			jmp LookForKey
		.ENDIF

		ret
GetMovement ENDP
END