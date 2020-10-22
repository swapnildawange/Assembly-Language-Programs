;----------------------------------------------------------------------------
;------Sandip Institute of Engineering and Management
;----------(Department of Computer Engineering)
;------Class: S.E.Comp				Sub:Microprocessor Lab

;------Asignment No : 0
;------WRITE AN ALP TO PRINT 8 BIT NUMBER ON SCREEN
;----------------------------------------------------------------------------

;**************************** DATA SECTION **********************************
section .data
	
	msg1 db 10,'The Number is ::'
	msg1_len equ $-msg1

	number db 9fh

;**************************** BSS SECTION ***********************************
section .bss
	num_ascii	resb 2		 ;2 BYTES are reserved to store ASCII value		
;*************************************************************************

;***************MACRO TO PRINT MESSAGE*******************

%macro cout 2
	mov rax,01				;SYSCALL cout MACRO
	mov rdi,01
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

;********************************************************

;**************************** CODE/TEXT SECTION ******************************
section .text
	global _start
_start:

;*************** DISPLAY NUMBER ***********************
	cout msg1,msg1_len		;MESSAGE "The Number is ::'
	mov bl,[number]			;8 Bit number so BL
	call display_proc_8_bit

;*****************************************************************************
exit:
	mov rax,60		;SYSCALL EXIT FUNCTION
	mov rbx,0
	syscall

;********************** DISPLAY 8 BIT NUMBER **********************************
display_proc_8_bit:
	mov cl,2			;Number of digits to display
	mov edi,num_ascii	;Temp buffer to store ASCII value
up1:
	rol bl,4			;Rotate number from bl to get MSB digit to LSB digit
	mov al,bl			;Temporary copy rotated number to AL
	and al,0fh			;Mask/Delete upper digit
	cmp al,09			;Compare the result with 9
	jbe skip_07		;If number below or equal to 9 go to add only 30h
	add al,07h			;Else first add 07h and then 30h
skip_07:	
	add al,30h			;Add 30h Common in both cases  (So either 30h OR 37h) 
	mov [edi],al		;Store the ASCII code in num_ascii variable
	inc edi			;Increment pointer to next location in num_ascii

	dec cl			;repeat till counter CL becomes zero
	jnz up1

	cout num_ascii,2	;display the value from num_ascii
	ret				;return to calling program
;*******************************************************************************
