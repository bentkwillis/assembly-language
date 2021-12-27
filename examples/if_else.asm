;Example 1 IF/ELSE Demo
;if (a < b) then X = 1 else X = 2
.586
.model flat, stdcall
option casemap :none
.stack 4096
ExitProcess proto,dwExitCode:dword

.data	
	A	DWORD	00004h
	B	DWORD	00006h
	X	BYTE	?
.code
main proc
	MOV EAX, A		; Load value of A
	CMP EAX, B		; Compare it with B
	JGE ElseCase		; If A >= B then “else”
	MOV X, 1		; Otherwise do “then”
	JMP finish		; Jump to end of if
ElseCase:		
	MOV X, 2		; Do “else” case
finish:
	push 0
	invoke ExitProcess,0
main endp

end