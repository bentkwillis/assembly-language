; Example of passing parameters to a procedure using the stack
; X and Y are 12 and 24 respectively, pass these values via stack to a procedure
;which evaluates 3 * x+7*y
.586
.model flat, stdcall
option casemap :none
.stack	4096
extrn ExitProcess@4: proc

.data
	X DW 12
	Y DW 24

.code
main proc
	push Y
	push X
	call evalProc
finish:
	push 0
	call ExitProcess@4

main endp

; This is the procedure. It prints out a given character a specified number
; of times. The parameters are

evalProc proc 
	PUSH 	EBP			; Setup base pointer (BP) to access parameters
	MOV  	EBP, ESP			;establish a stack frame
	PUSH 	EBX			;save EBX

	MOV	EAX,[EBP+8]		;X VALUE
	IMUL	EAX,3			;3*X
	MOV 	EBX,[EBP+10]		;Y VALUE
	IMUL	EBX,7			;7*Y
	ADD	EAX,EBX			;3*X + 7*Y
	POP	EBX
	POP	EBP
	RET

evalProc endp
end