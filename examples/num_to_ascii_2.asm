.586
.model flat, stdcall
option casemap :none
.stack 4096
extrn ExitProcess@4: proc

GetStdHandle proto :dword
WriteConsoleA proto :dword, :dword, :dword, :dword, :dword
STD_OUTPUT_HANDLE equ -11

.data
 	    bytes_read  DWORD  ?
		sum_string db "The number was ",0
 	 	outputHandle DWORD ?
		bytes_written dd ?
		actualNumber dw 1234
		asciiBuf db 4 dup (0)
.code
	main:
		invoke GetStdHandle, STD_OUTPUT_HANDLE
 	    mov outputHandle, eax
		mov	eax,LENGTHOF sum_string	;length of sum_string
		invoke WriteConsoleA, outputHandle, addr sum_string, eax, addr bytes_written, 0
		mov ax,[actualNumber]
		mov cl,10
		mov	ebx,3
	nextNum:
		div	cl
		add	ah,30h
		mov byte ptr asciiBuf+[ebx],ah
		dec	ebx
		mov	ah,0
		cmp al,0
		ja nextNum
		
		mov	eax,4

 	    invoke WriteConsoleA, outputHandle, addr asciiBuf, eax, addr bytes_written, 0
		push	0

		call	ExitProcess@4
end		main
