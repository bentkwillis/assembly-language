.586
.model flat, stdcall
option casemap :none
.stack	4096
; Example of passing parameters to a procedure using registers
extrn ExitProcess@4: proc
.data
	output db 20 dup(?) 
.code 
main	proc
	MOV AL, 'a'		; Parameter - the character to output
	MOV AH, 20		; Parameter - the number of times to output it
	CALL WRITE_CHAR		; Call the procedure

	MOV AL, 'b'		; Parameter - the character to output
	MOV AH, 10		; Parameter - the number of times to output it
	CALL WRITE_CHAR		; Call the procedure
finish:
	push 0
	call ExitProcess@4
main endp

; This is the procedure. It prints out a given character a specified number
; of times. The parameters are:
; 	AL = the character to be output
; 	AH = number of times to output it
WRITE_CHAR proc near
	MOV ECX, 0
	MOV CL, AH		; Set up CX so that we can use LOOP
	MOV DL, AL		; Move the character into DL for DOS output
OUTPUT_CHAR:
	MOV [output+cx],dl		; DOS function number to write DL to output
	LOOP OUTPUT_CHAR	; Repeat until all characters are output
	RET			; Return from the procedure

WRITE_CHAR endp

end