INCLUDE _modules.inc

.data

	MENU BYTE "Start new game (S)",0Dh,0Ah
	BYTE "Print Map (P)", 0Dh, 0Ah
	BYTE "Demo (R)", 0Dh, 0Ah
	BYTE "Move Up (W)", 0Dh, 0Ah
	BYTE "Move Down (S)", 0Dh, 0Ah
	BYTE "Move Left (A)", 0Dh, 0Ah
	BYTE "Move Right (D)", 0Dh, 0Ah
	BYTE "End game (E)",0

	fileName BYTE "hi.txt",0
	fileName2 BYTE "hia.txt",0

	fileHandle Dword ?

	Win BYTE "CONGRATZ YOU WIN. Hit S to start again, E to exit or P to print the map again",0
	Which BYTE "Press f for map one or press g for map 2",0

	Captured BYTE 0
	NumberOfGhosts BYTE ?
	Row BYTE ?
	CheckFlag BYTE ?
	Column BYTE ?

	GameMap BYTE 12 DUP (14 DUP (?))

.code
main PROC

	call Load
	call FindNumberOfGhosts

	.WHILE TRUE
		call PrintMenu
		call GetInput
	.ENDW
	
main ENDP

Load PROC

	call ClrScr
	mov edx, OFFSET Which
	call WriteString

	LookForKey:	 
		mov eax, 50
		call Delay
		call ReadKey
		jz LookForKey

	.IF al == 'f'
		mov edx, OFFSET fileName
	.ELSEIF al == 'g'
		mov edx, OFFSET fileName2
	.ELSE
		jmp LookForKey
	.ENDIF

	call OpenInputFile
	mov fileHandle,eax
	mov edx, OFFSET GameMap
	mov ecx, 168
	call ReadFromFile		
	call Clrscr
	mov eax, fileHandle
	call CloseFile

	ret
Load ENDP



GetInput PROC

	LookForKey:	 
		mov eax, 50
		call Delay
		call ReadKey
		jz LookForKey

	.IF al == 'r'
		mov al, NumberOfGhosts
		mov ah, Captured
		.IF al == ah
			call Load
			call FindNumberOfGhosts
		.ENDIF
				call FindNumberOfGhosts
		call Demo
	.ELSEIF al == 's'
		call FindNumberOfGhosts
		mov al, NumberOfGhosts
		mov ah, Captured

		.IF al == ah
			call Load
		.ENDIF

		call Start
	.ELSEIF al == 'p'
		Invoke PrintMap,
			ADDR GameMap
	.ELSEIF al == 'e'
		call EndGame
	.ELSE
		jmp LookForKey
	.ENDIF

	ret
GetInput ENDP

Start Proc

	call Clrscr
	call FindNumberOfGhosts
	mov al, NumberOfGhosts
	mov ah, Captured

	.WHILE al != ah
		Invoke PrintMap,
			ADDR GameMap
		Invoke GetMovement,
			 Row,
			 Column
		call CheckValid
		call Clrscr
		mov al, NumberOfGhosts
		mov ah, Captured
	.ENDW

	call WinScreen

	ret
Start ENDP

WinScreen PROC

	mov edx, OFFSET Win
	call WriteString
	call GetInput

	ret
WinScreen ENDP


CheckValid PROC

	Invoke CalculateNext,
		Row,
		Column

	.IF GameMap[esi] == '*'
		ret
	.ENDIF

	.IF CheckFlag == 1
		mov GameMap[eax],	023h
		mov al, 0
		mov CheckFlag, al
	.ELSE
		mov GameMap[eax], 020h
	.ENDIF

	.IF GameMap[esi] == '#'
		mov al, 1
		mov CheckFlag, al
	.ELSEIF GameMap[esi] == '$'
		inc Captured
		mov al, 1
		mov CheckFlag, al
	.ENDIF

	mov GameMap[esi], 040h	
	mov Row, bl
	mov Column, bh
	
	ret
CheckValid ENDP

FindNumberOfGhosts PROC

	mov ecx, 168
	mov eax,0

	L1:
	.IF GameMap[ecx] == '$'
		inc al
	.ENDIF

	.IF GameMap[ecx] == '@'
		mov NumberOfGhosts, al
		mov dx, 0
		mov ax, cx
		mov bx, 14
		div bx
		mov Row, al
		mov Column,dl
		mov al,NumberOfGhosts
	.ENDIF

	Loop L1

	mov NumberOfGhosts, al
	mov Captured, 0
	mov CheckFlag, 0

	ret
FindNumberOfGhosts ENDP

EndGame PROC

    exit

	ret
EndGame ENDP

PrintMenu PROC

	mov edx, OFFSET Menu
	call WriteString
	call Crlf
	
	ret
PrintMenu ENDP

Demo PROC

	Invoke EndDemo,
		NumberOfGhosts,
		Captured

	push EBP
	mov ebp, esp

	;North
	mov bl, Row
	mov bh, Column
	push ebx
	dec bl

	Invoke CalculateNext,
		Row,
		Column


   .IF GameMap[esi] == ' '
		Invoke DrawCurrentPosition,
			ADDR GameMap
		jmp Recursive
   .ELSEIF GameMap[esi] == '$' 
		inc Captured
		Invoke DrawCurrentPosition,
			ADDR GameMap
		mov ecx , 1
		jmp Recursive
	.ENDIF
		
	;South 
	mov bl, Row
	mov bh, Column 
	inc bl

	Invoke CalculateNext,
		Row,
		Column


	.IF GameMap[esi] == ' '
		Invoke DrawCurrentPosition,
			ADDR GameMap
		jmp Recursive
	.ELSEIF GameMap[esi] == '$'
		inc Captured
		Invoke DrawCurrentPosition,
			ADDR GameMap
			mov ecx , 1 
		jmp Recursive
	.ENDIF	

	;West 
	mov bl, Row
	mov bh, Column
	dec bh

	Invoke CalculateNext,
		Row,
		Column


	.IF GameMap[esi] == ' '
		Invoke DrawCurrentPosition,
			ADDR GameMap
		jmp Recursive
	.ELSEIF GameMap[esi] == '$' 
		inc Captured
		Invoke DrawCurrentPosition,
			ADDR GameMap
			mov ecx , 1
		jmp Recursive
	.ENDIF

	;East
	mov bl, Row
	mov bh, Column
	inc bh

	Invoke CalculateNext,
		Row,
		Column

	 
	.IF GameMap[esi] == ' '
		Invoke DrawCurrentPosition,
			ADDR GameMap
		jmp Recursive
	.ELSEIF GameMap[esi] == '$'
		inc Captured
		Invoke DrawCurrentPosition,
			ADDR GameMap
		mov ecx , 1
		jmp Recursive
	.ENDIF

	pop ebx
	pop EBP
	ret

	Recursive:
		mov GameMap[esi], 040h
		Invoke PrintMap,
			ADDR GameMap
		mov eax, 500
		call Delay
		mov Row, bl
		mov Column, bh
		call Demo
		pop ebx
		pop EBP		

		Invoke CalculateNext,
			Row,
			Column

		Invoke DrawCurrentPosition,
			ADDR GameMap

		.IF GameMap[esi] == '#'
			mov ecx , 1 
		.ENDIF

		mov GameMap[esi], 040h 
		Invoke PrintMap,
			ADDR GameMap
		mov eax, 500
		call Delay
		mov Row, bl
		mov Column, bh
		Call Demo
	
	ret
Demo ENDP

END main