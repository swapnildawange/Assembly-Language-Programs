;-----------------------------------------------------------------------------------------
;------Sandip Institute of Engineering and Management
;------(Department of Computer Engineering)
;------Class: S.E.Comp				Sub:Microprocessor Lab
;------Asignment No : 3.2
;------Write an ALP for BCD to Hex Conversion
;------------------------------------------------------------------------------------
;*********************************************************************************
section .data
	
	bcd_in_msg db 10,10,'Please enter 5 digit BCD number::'
	bcd_in_msg_len equ $-bcd_in_msg

	hex_op_msg db 10,10,'Hex Equivalent number is::'
	hex_op_msg_len equ $-hex_op_msg


;***************************  BSS SECTION  *******************************

section .bss
	bcd_num_ascii resb 06			;Buffer for BCD input
	num_ascii resb 08

;************************** ACCEPT / DISPLAY MACRO ******************

%macro cout 2
	mov rax,01				;SYSCALL cout MACRO
	mov rdi,01
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

%macro cin 2
	mov rax,0				;SYSCALL cin MACRO
	mov rdi,0
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro
;************************** TEXT SECTION **************************

section .text
	global _start
_start:
		
;**************************  BCD TO HEX PROCEDURE *****************************
bcd2hex_proc:
	cout bcd_in_msg,bcd_in_msg_len		;Enter 5 digit BCD number::
	cin bcd_num_ascii,6					;cin & STORE BCD NO INTO num_ascii

	cout hex_op_msg,hex_op_msg_len		;Hex Equivalent no is::

	mov rsi,bcd_num_ascii			;POINT RSI TO num_ascii i.e. (BCD NO)
	mov rcx,05					;INITIALISE COUNT INTO RCX AS 5
	mov rax,0					;INITIALISE RAX(Multiplication) AS 0
	mov ebx,0ah				;STORE 0AH (DECIMAL 10) INTO EBX TO MULTIPLY
;----------------------MULTIPLICATION Instruction Rule -----------------------
;BYTE		: |AL is Multiplicand	 | Multiplication in AL and Carry in AH |
;WORD 	: |AX is Multiplicand	 | Multiplication in AX and Carry in DX |
;D WORD	: |EAX is Multiplicand |  Multiplication in EAX and Carry in EDX|
;---------------------------------------------------------------------------

b2hup1:	
	mov rdx,0					;INITIALISE RDX(Carry) AS 0
	mul ebx					;MULTIPLY EAX (Accumulator) BY EBX (0AH)
	mov dl,[rsi]				;COPY VALUE (One by One)from bcd_num_ascii INTO DL
	sub dl,30h					;SUBTRACT 30H FROM DL (As it is BCD Subtract Only 30)
	add rax,rdx				;ADD Subtracted RDX INTO RAX (Accumulator)
	inc rsi					;INCREMENT RSI POINTER (bcd_num_ascii Pointer)
	loop b2hup1				;EXECUTE LOOP UNTILL COUNT BECOMES 0
	mov ebx,eax				;COPY FINAL RESULT (i.e. HEX No) INTO EBX to Print
	call display_proc_32_bit		;CALL disp32_num PROCEDURE TO PRINT OUTPUT
	ret

;************************* DISPLAY PROCEDURE *************************
display_proc_32_bit:
	mov cl,8			;Number digits to display
	mov edi,num_ascii	;Temp buffer to store ASCII value
up1:
	rol bx,4			;Rotate number from BX to get MSB digit to LSB digit
	mov al,bl			;Temporary copy rotated number to AL
	and al,0fh			;Mask/Delete upper digit
	cmp al,09			;Compare the result with 9
	jbe skip_07		;If number below or equal to 9 go to add only 30h
	add al,07h			;Else first add 07h and then 30h
skip_07:	
	add al,30h			;Add 30h Common in both cases (So either 30h OR 37h) 
	mov [edi],al		;Store the ASCII code in num_ascii variable
	inc edi			;Increment pointer to next location in num_ascii

	dec cl			;repeat till counter CL becomes zero
	jnz up1

	cout num_ascii+3,5	;DISPAYS ONLY LOWER 5 DIGITS AS UPPER THREE ARE '0'
	ret				;return to calling program

;***************************************************************************
exit:
	mov rax,60		;SYSCALL EXIT FUNCTION
	mov rbx,0
	syscall
;***************************************************************************

