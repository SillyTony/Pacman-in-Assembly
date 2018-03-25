INCLUDE _modules.inc
.code
CalculateNext PROC,
	Row:BYTE,
	Column:Byte

	mov al, 14
	mul bl
	add al, bh
	movzx esi, al
	mov al, 14
	mul Row
	add al, Column
	movzx eax, al

	ret
CalculateNext ENDP
END