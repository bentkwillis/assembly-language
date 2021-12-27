; shows some of the data addressing modes of 8086
; step this program in debug  mode
 .586
.MODEL FLAT
.STACK 4096
.DATA
      buffer db 20 dup(?) 
.CODE
main:
; Example of passing parameters to a procedure using registers

	MOV AL, 'a'		; Parameter - the character to output
	MOV AH, 20		; Parameter - the number of times to output it
	CALL WRITE_CHAR		; Call the procedure

	MOV AL, 'b'		; Parameter - the character to output
	MOV AH, 10		; Parameter - the number of times to output it
	CALL WRITE_CHAR		; Call the procedure

FINISHED:



; This is the procedure. It prints out a given character a specified number
; of times. The parameters are:
; 	AL = the character to be output
; 	AH = number of times to output it
WRITE_CHAR:
	MOV ECX, 0
	MOV CL, AH		; Set up CX so that we can use LOOP
	MOV DL, AL		; Move the character into DL for DOS output
OUTPUT_CHAR:
;	

	LOOP OUTPUT_CHAR	; Repeat until all characters are output
	RET			; Return from the procedure


end 	main