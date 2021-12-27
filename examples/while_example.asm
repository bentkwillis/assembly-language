;Example 3 Example of WHILE loops
;A=0; while (A < 100) A = A + 1;
.586
.model flat, stdcall
option casemap :none
.stack 4096
ExitProcess proto,dwExitCode:dword

.data	
	message DB 'Hello World',0
	A	DB	?
.code
main proc
	
  MOV A, 0			; initialise A
WhileLoop:
  CMP A, 100		; If test fails then
  JGE WhileEnd		;    we can stop
  INC A				; Otherwise do body
  JMP WhileLoop		;    and repeat
WhileEnd:


finish:
	push 0
	invoke ExitProcess,0
main endp

end