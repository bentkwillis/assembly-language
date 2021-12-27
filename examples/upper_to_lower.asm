.586
.model flat, stdcall
option casemap :none
.stack 4096
extrn ExitProcess@4: proc

GetStdHandle proto :dword
ReadConsoleA  proto :dword, :dword, :dword, :dword, :dword
WriteConsoleA proto :dword, :dword, :dword, :dword, :dword
MessageBoxA proto	:dword, :dword, :dword, :dword
STD_INPUT_HANDLE equ -10
STD_OUTPUT_HANDLE equ -11

.data
	
	bufSize = 80
 	inputHandle DWORD ?
 	buffer db bufSize dup(?)
 	bytes_read  DWORD  ?
	sum_string db "The lower case string is ",0
 	outputHandle DWORD ?
	bytes_written dd ?

.code
	main:
		
 	    invoke GetStdHandle, STD_INPUT_HANDLE
 	    mov inputHandle, eax
 		invoke ReadConsoleA, inputHandle, addr buffer, bufSize, addr bytes_read,0
		sub bytes_read, 2	; -2 to remove cr,lf
 		mov ebx,0
	checkChar:
		mov al, byte ptr buffer+[ebx] 
		cmp	al,20h		;Is it a space if so leave it alone
		jz	getNext
		cmp 	al,5Ah		;A = 41H Z=5AH a = 61H z=7AH
		jge 	getNext
		add 	al,20h		;add 20H to the value to convert to lowercase
		mov 	byte ptr buffer+[ebx],al
		
	
	getNext:
		inc	bx
		cmp ebx,bytes_read
		jz cont
		
		
		jmp checkChar
	cont:


		invoke GetStdHandle, STD_OUTPUT_HANDLE
 	    mov outputHandle, eax
	
		mov eax,bytes_read
 	    invoke WriteConsoleA, outputHandle, addr buffer, eax, addr bytes_written, 0
	
		invoke MessageBoxA, 0, addr buffer, addr sum_string,0
		mov eax,0
		mov eax,bytes_written
		push	0

		call	ExitProcess@4
end		main
