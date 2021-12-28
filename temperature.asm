.586
.model flat, stdcall
option casemap :none
.stack 4096
ExitProcess		proto,dwExitCode:dword
GetStdHandle	proto :dword
ExitProcess		proto,dwExitCode:dword
WriteConsoleA	proto :dword, :dword, :dword, :dword, :dword
ReadConsoleA	proto :dword, :dword, :dword, :dword, :dword
MessageBoxA		proto :dword, :dword, :dword, :dword

.data	
	TemperatureResult		DW		?	; Holds the resulting temperature for output.
	STD_INPUT_HANDLE		equ		-10
	STD_OUTPUT_HANDLE		equ		-11
	bufSize 				= 		80
 	inputHandle				DWORD	?
 	buffer					db		bufSize		dup(?)
 	bytes_read				DWORD	?
	newlineString			db		"                                                                                                  ",30
	CorF					db		"Would you like to convert to Celcius or Fahrenheit? (c/f): ",0
	EnterTempPrompt			db		"Please enter the temperature: ",0
	resultText				db		"The result is:",0
	celciusSign				db		"C",0
	fahrenheitSign			db		"F",0
	userChoice				db		bufSize		dup(?)	; holds the users entered conversion choice (c/f)
	outputHandle			DWORD	?
	bytes_written			dd		?
	actualNumber			dw		0	; used in ascii to number conversion
	asciiBuf				db		4			dup(0)
	quit					db		bufSize		dup(?)	; holds the users entered quit choice (y/n)
	quitText				db		"Would you like to make another conversion? (y/n): ",0
	temp1					DW		?	; used when rounding up number

.code
main proc
	; Set registers and variables to zero. Makes sure values are reset when looping back to start.
	mov eax,0
	mov ebx,0
	mov ecx,0
	mov edx,0
	mov actualNumber,0
	mov inputHandle,0
	mov buffer,0
	mov userChoice,0
	mov TemperatureResult,0
	mov temp1,0

	; Prints text asking which conversion to make
	invoke GetStdHandle, STD_OUTPUT_HANDLE
	mov outputHandle, eax
	mov	eax,LENGTHOF CorF	; for printing the length of the text variable (use particular text var after LENGTHOF)
	invoke WriteConsoleA, outputHandle, addr CorF, eax, addr bytes_written, 0 ; Asks if conversion is to C or F

	; Takes and stores input for which conversion to make. Decision stored in userChoice variable.
	invoke GetStdHandle, STD_INPUT_HANDLE
	mov inputHandle, eax
	invoke ReadConsoleA, inputHandle, addr userChoice, bufSize, addr bytes_read,0 ; after entering a word, this sends the console to the next line

	; Prints text prompting the user the enter a number to convert
	invoke GetStdHandle, STD_OUTPUT_HANDLE
	mov outputHandle, eax
	mov	eax,LENGTHOF EnterTempPrompt	; for printing the length of the text variable (use particular text var after LENGTHOF)
	invoke WriteConsoleA, outputHandle, addr EnterTempPrompt, eax, addr bytes_written, 0 ; Asks if conversion is to C or F

	; Takes input of number for conversion
	invoke GetStdHandle, STD_INPUT_HANDLE
	mov inputHandle, eax
	invoke ReadConsoleA, inputHandle, addr buffer, bufSize, addr bytes_read,0 ; after entering a word, this sends the console to the next line
	
	; Ascii to number conversion. Number is stored in actualNumber.
	sub bytes_read, 2	; -2 to remove cr,lf
 	mov ebx,0
	mov al, byte ptr buffer+[ebx] 
	sub al,30h
	add	[actualNumber],ax
	getNext:
	inc	bx
	cmp ebx,bytes_read
	jz cont
	mov	ax,10
	mul	[actualNumber]
	mov actualNumber,ax
	mov al, byte ptr buffer+[ebx] 
	sub	al,30h
	add actualNumber,ax
	jmp getNext
	mov eax,0
	mov eax,bytes_written
	cont: ; when done, call one of the conversion routines

	; IF: to allow user to make the choice between C and F conversion
	MOV AL, userChoice 
	MOV BL, 102		; f = ascii 102, c = ascii 99
	CMP AL, BL		; Compare userChoice with 'f'
	JGE ELSECASE	; If userChoice >= 'f' then �else�
	call FtoC		; Otherwise do �then�
	JMP ENDIFS		; Jump to end of if
	ELSECASE:
	call CtoF		; Do �else� case
	ENDIFS:

	; Conversion procedures return here
	call quitprompt
	
CtoF PROC	; Celsius to Fahrenheit conversion
	MOV AX, actualNumber 
	MOV BX, 9		; put 9 in BL
	IMUL BX			; multiply BL (9) by AL (celcius)
	; DIVIDE by 5 (AX/5)...
	MOV BX, 5	
	IDIV BX			; DX:AX / BX -> AX remainder DX
	MOV temp1, AX	; Save result
	; ...ROUNDING UP
	IMUL AX, DX, 2	; AX = DX * 2
	CDQ				; AX -> DX:AX
	IDIV BX			; DX:AX / BX
	ADD temp1, AX	; Add -1 or 0 or 1
	MOV AX, temp1
	; ADD 32
	ADD AX, 32
	MOV TemperatureResult, AX
	; PRINT
	call printResult
	call fSign
	; Called print procedures return here
	RET
CtoF ENDP

FtoC PROC	; Fahrenheit to Celcius conversion
	; SUBTRACT F-32
	MOV AX, actualNumber
	MOV BX, 32
	SUB AX,BX
	; MULTIPLY AX*BX (5)
	MOV BX, 5
	IMUL BX
	; DIVIDE by 9...
	MOV BX, 9
	IDIV BX			; DX:AX / BX -> AX remainder DX
	MOV temp1, AX	; Save result
	; ...ROUNDING UP
	IMUL AX, DX, 2	; AX = DX * 2
	CDQ				; AX -> DX:AX
	IDIV BX			; DX:AX / BX
	ADD temp1, AX	; Add -1 or 0 or 1
	MOV AX, temp1
	MOV TemperatureResult, AX
	; PRINT
	call printResult
	call cSign
	; Called print procedures return here
	RET
FtoC ENDP

printResult PROC	; Converts result to ascii and prints
invoke GetStdHandle, STD_OUTPUT_HANDLE
		; Prints "The result is: "
		mov outputHandle, eax
		mov	eax,LENGTHOF resultText
		invoke WriteConsoleA, outputHandle, addr resultText, eax, addr bytes_written, 0 
		; Number to ascii conversion
		mov ax,[TemperatureResult]
		mov cl,10
		mov	bl,3
	nextNum:
		div	cl
		add	ah,30h
		mov byte ptr asciiBuf+[ebx],ah
		dec	ebx
		mov	ah,0
		cmp al,0
		ja nextNum
		mov	eax,4
		; Prints temperature result value
 	    invoke WriteConsoleA, outputHandle, addr asciiBuf, eax, addr bytes_written, 0
		mov eax,0
		mov eax,bytes_written
		RET
printResult ENDP

cSign PROC ; Prints the celcius sign after the conversion result
	invoke GetStdHandle, STD_OUTPUT_HANDLE
	mov outputHandle, eax
	mov	eax,LENGTHOF celciusSign
	invoke WriteConsoleA, outputHandle, addr celciusSign, eax, addr bytes_written, 0
	RET
cSign ENDP

fSign PROC ; Prints the fahrenheit sign after the conversion result
	invoke GetStdHandle, STD_OUTPUT_HANDLE
	mov outputHandle, eax
	mov	eax,LENGTHOF fahrenheitSign
	invoke WriteConsoleA, outputHandle, addr fahrenheitSign, eax, addr bytes_written, 0
	RET
fSign ENDP

newline PROC ; prints a string large enough to push the quit prompt to the next line. Assumes the default cmd window size. Should implement better method.
	invoke GetStdHandle, STD_OUTPUT_HANDLE
	mov outputHandle, eax
	mov	eax,LENGTHOF newlineString
	invoke WriteConsoleA, outputHandle, addr newlineString, eax, addr bytes_written, 0
	RET                      
newline ENDP

quitprompt PROC ; Allows the user to make another conversion, or exit the program
	call newline
	; Prints text asking if the user wants to make another conversion
	invoke GetStdHandle, STD_OUTPUT_HANDLE
	mov outputHandle, eax
	mov	eax,LENGTHOF quitText ; for printing the length of the text variable (use particular text var after LENGTHOF)
	invoke WriteConsoleA, outputHandle, addr quitText, eax, addr bytes_written, 0 ; Asks if conversion is to C or F

	; Takes input for whether the user wants to make another conversion or quit
	invoke GetStdHandle, STD_INPUT_HANDLE
	mov inputHandle, eax
	invoke ReadConsoleA, inputHandle, addr quit, bufSize, addr bytes_read,0 ; after entering a word, this sends the console to the next line

	; IF to allow user to make another conversion or quit. In some cases, conversions are incorrect after loop.
	MOV AL, quit 
	MOV BL, 121			; y = ascii 121, n = ascii 110
	CMP AL, BL			; Compare quit with 'y'
	JGE ELSECASE1		; If quit >= 'y' then �else�
	finish:				; if the user enters 'n', jump to finish to exit the program
	JMP ENDIFS1			; Jump to end of if
	ELSECASE1:
	call main			; if the user enters 'y', jump back to the start of the program
	ENDIFS1:
	RET
quitprompt ENDP

finish:
	invoke ExitProcess,0 ; Exits the program

main ENDP
end main