INCLUDE _modules.inc
.code
EndDemo PROC,
	NumberOfGhosts:BYTE,
	Captured:Byte

	mov al, Captured
	mov ah, NumberOfGhosts

	.IF al == ah
		exit
	.ENDIF

	ret
EndDemo ENDP
END