;Example 2 Example of FOR loops
;for (i=1; i<=10; i++) x = x + i
.586
.model flat, stdcall
option casemap :none
.stack 4096
ExitProcess proto,dwExitCode:dword

.data	
	X		DB 10  DUP(?)
	
.code
main proc
	MOV ECX, 1					; initialise counter
	MOV EBX, 0
ForLoop:
	MOV [EBX+X],41h					; do loop body
	INC ECX						; increment counter
	INC EBX
	CMP ECX, 10					; do termination test
	JLE ForLoop					; repeat if CX <= 10

finish:
	push 0
	invoke ExitProcess,0
main endp

end