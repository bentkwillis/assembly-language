;Immediate Addressing and Direct Addressing
.586
.model flat, stdcall
option casemap :none
.stack 4096
ExitProcess proto,dwExitCode:dword

.data	
value1	DWORD	10000h
value2	DWORD	40000h
value3	DWORD	20000h
finalVal	DWORD	?
			
.code
main proc
;Immediate Addressing the value 1234 is immediately put into the BX register.
		mov bx,1234
;Direct Addressing the value in the variable value1 etc	
		mov	eax,[value1] 	 ; [] means contents of
		add	eax,value2	 ; can also do it this way so its the value assigned to value2
		sub	eax,value3
		mov	finalVal,eax
;INDIRECT Addressing
		;SEE THE FOR LOOP EXAMPLES 
;BASED - index addressing
		mov	ebx,offset value1
		mov	ecx,4
		mov eax, [ebx + ecx + 8]	; this should be looking at finalVal

		invoke ExitProcess,0
main endp

end