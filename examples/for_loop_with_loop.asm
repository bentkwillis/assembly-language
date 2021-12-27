;Example 2 Example of FOR loops USING LOOP
;for (i=1; i<=10; i++) x = x + i
.586
.model flat, stdcall
option casemap :none
.stack 4096
ExitProcess proto,dwExitCode:dword

.data	
	A	DB	04h
	X	DB 10  DUP(?)
.code
main proc
	MOV ECX, 10		; initialise counter
	MOV EBX,0
ForLoop:
	MOV [EBX+X],'A'		; do loop body
	INC EBX
	LOOP	ForLoop	; repeat until CX = 0

finish:
	push 0
	invoke ExitProcess,0
main endp

end